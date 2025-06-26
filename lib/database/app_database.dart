/// Database configuration for the Movie Star application using Drift.
///
/// This file defines the database schema and provides access to cached movie data
/// to reduce API calls and improve app performance.
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
/// Licensed under the GNU General Public License, Version 3 (the "License").

library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:moviestar/models/movie.dart' as movie_model;

part 'app_database.g.dart';

/// Table definition for storing movie data.

class Movies extends Table {
  /// Unique identifier for the movie (from TMDB API).

  IntColumn get id => integer()();

  /// Title of the movie.

  TextColumn get title => text()();

  /// Overview/description of the movie.

  TextColumn get overview => text()();

  /// Path to the movie's poster image (without base URL).

  TextColumn get posterPath => text()();

  /// Path to the movie's backdrop image (without base URL).

  TextColumn get backdropPath => text()();

  /// Average rating of the movie.

  RealColumn get voteAverage => real()();

  /// Release date of the movie.

  DateTimeColumn get releaseDate => dateTime()();

  /// JSON string of genre IDs.

  TextColumn get genreIds => text()();

  /// Timestamp when this movie was cached.

  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table definition for storing movie categories (popular, now_playing, etc.).

class MovieCategories extends Table {
  /// Auto-incrementing primary key.

  IntColumn get id => integer().autoIncrement()();

  /// Movie ID (foreign key to Movies table).

  IntColumn get movieId => integer().references(Movies, #id)();

  /// Category type (popular, now_playing, top_rated, upcoming).

  TextColumn get category => text()();

  /// Position in the category list (for maintaining order).

  IntColumn get position => integer()();

  /// Timestamp when this category entry was cached.

  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table definition for storing cache metadata.

class CacheMetadata extends Table {
  /// Category identifier (e.g., 'popular', 'now_playing').

  TextColumn get category => text()();

  /// Timestamp when this category was last updated.

  DateTimeColumn get lastUpdated => dateTime()();

  /// Number of movies in this category.

  IntColumn get movieCount => integer()();

  @override
  Set<Column> get primaryKey => {category};
}

/// Main database class that extends Drift's database.

@DriftDatabase(tables: [Movies, MovieCategories, CacheMetadata])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Gets cached movies for a specific category.

  Future<List<movie_model.Movie>> getCachedMoviesForCategory(
    String category,
  ) async {
    final query =
        select(movies).join([
            innerJoin(
              movieCategories,
              movieCategories.movieId.equalsExp(movies.id),
            ),
          ])
          ..where(movieCategories.category.equals(category))
          ..orderBy([OrderingTerm.asc(movieCategories.position)]);

    final rows = await query.get();
    return rows.map((row) {
      final movieData = row.readTable(movies);
      return movie_model.Movie(
        id: movieData.id,
        title: movieData.title,
        overview: movieData.overview,
        posterUrl:
            movieData.posterPath.isNotEmpty
                ? 'https://image.tmdb.org/t/p/w500${movieData.posterPath}'
                : '',
        backdropUrl:
            movieData.backdropPath.isNotEmpty
                ? 'https://image.tmdb.org/t/p/original${movieData.backdropPath}'
                : '',
        voteAverage: movieData.voteAverage,
        releaseDate: movieData.releaseDate,
        genreIds: List<int>.from(jsonDecode(movieData.genreIds)),
      );
    }).toList();
  }

  /// Caches movies for a specific category.

  Future<void> cacheMoviesForCategory(
    String category,
    List<movie_model.Movie> movieList,
  ) async {
    await transaction(() async {
      // Clear existing category entries.

      await (delete(movieCategories)
        ..where((tbl) => tbl.category.equals(category))).go();

      // Insert/update movies.

      for (final movie in movieList) {
        final movieCompanion = MoviesCompanion(
          id: Value(movie.id),
          title: Value(movie.title),
          overview: Value(movie.overview),
          posterPath: Value(_extractPosterPath(movie.posterUrl)),
          backdropPath: Value(_extractBackdropPath(movie.backdropUrl)),
          voteAverage: Value(movie.voteAverage),
          releaseDate: Value(movie.releaseDate),
          genreIds: Value(jsonEncode(movie.genreIds)),
        );
        await into(movies).insertOnConflictUpdate(movieCompanion);
      }

      // Insert category mappings.

      for (int i = 0; i < movieList.length; i++) {
        await into(movieCategories).insert(
          MovieCategoriesCompanion.insert(
            movieId: movieList[i].id,
            category: category,
            position: i,
          ),
        );
      }

      // Update cache metadata.

      await into(cacheMetadata).insertOnConflictUpdate(
        CacheMetadataCompanion.insert(
          category: category,
          lastUpdated: DateTime.now(),
          movieCount: movieList.length,
        ),
      );
    });
  }

  /// Checks if cache for a category is valid (not expired).

  Future<bool> isCacheValid(String category, Duration maxAge) async {
    final metadata =
        await (select(cacheMetadata)
          ..where((tbl) => tbl.category.equals(category))).getSingleOrNull();

    if (metadata == null) return false;

    final age = DateTime.now().difference(metadata.lastUpdated);
    return age <= maxAge;
  }

  /// Gets cache metadata for a category.

  Future<CacheMetadataData?> getCacheMetadata(String category) async {
    return await (select(cacheMetadata)
      ..where((tbl) => tbl.category.equals(category))).getSingleOrNull();
  }

  /// Clears all cached data.

  Future<void> clearAllCache() async {
    await transaction(() async {
      await delete(movieCategories).go();
      await delete(movies).go();
      await delete(cacheMetadata).go();
    });
  }

  /// Clears cache for a specific category.

  Future<void> clearCacheForCategory(String category) async {
    await transaction(() async {
      await (delete(movieCategories)
        ..where((tbl) => tbl.category.equals(category))).go();
      await (delete(cacheMetadata)
        ..where((tbl) => tbl.category.equals(category))).go();
    });
  }

  /// Helper method to extract poster path from full URL.

  String _extractPosterPath(String posterUrl) {
    if (posterUrl.isEmpty) return '';
    // Extract path from URLs like 'https://image.tmdb.org/t/p/w500/poster.jpg'
    final uri = Uri.tryParse(posterUrl);
    if (uri == null) return '';
    return uri.pathSegments.isNotEmpty ? '/${uri.pathSegments.last}' : '';
  }

  /// Helper method to extract backdrop path from full URL.

  String _extractBackdropPath(String backdropUrl) {
    if (backdropUrl.isEmpty) return '';
    // Extract path from URLs like 'https://image.tmdb.org/t/p/original/backdrop.jpg'
    final uri = Uri.tryParse(backdropUrl);
    if (uri == null) return '';
    return uri.pathSegments.isNotEmpty ? '/${uri.pathSegments.last}' : '';
  }
}

/// Opens a connection to the database file.

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moviestar.db'));
    return NativeDatabase.createInBackground(file);
  });
}
