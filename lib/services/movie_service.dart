/// Service for managing movies in the Movie Star application.
///
// Time-stamp: <Thursday 2025-04-10 11:47:48 +1000 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Kevin Wang

library;

import 'package:moviestar/models/movie.dart';
import 'package:moviestar/services/api_key_service.dart';
import 'package:moviestar/utils/network_client.dart';

/// A service class that handles movie-related API requests.

class MovieService {
  /// Base URL for The Movie Database API.

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// Network client for making HTTP requests.

  NetworkClient? _client;

  /// Service for managing the API key.

  final ApiKeyService _apiKeyService;

  /// Creates a new MovieService instance.

  MovieService(ApiKeyService apiKeyService) : _apiKeyService = apiKeyService {
    _initializeClient();
  }

  /// Initializes the network client with the API key from secure storage.

  Future<void> _initializeClient() async {
    final apiKey = await _apiKeyService.getApiKey();
    _client = NetworkClient(baseUrl: _baseUrl, apiKey: apiKey ?? '');
  }

  /// Updates the API key and recreates the network client.

  Future<void> updateApiKey() async {
    _client?.dispose();
    // Reset to null to force recreation.

    _client = null;
    await _initializeClient();
  }

  /// Ensures the client is initialized before making requests.

  Future<void> _ensureClientInitialized() async {
    if (_client == null) {
      await _initializeClient();
    }
  }

  /// Gets a list of popular movies.

  Future<List<Movie>> getPopularMovies() async {
    await _ensureClientInitialized();
    final results = await _client!.getJsonList('movie/popular');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of movies currently playing in theaters.

  Future<List<Movie>> getNowPlayingMovies() async {
    await _ensureClientInitialized();
    final results = await _client!.getJsonList('movie/now_playing');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of top rated movies.

  Future<List<Movie>> getTopRatedMovies() async {
    await _ensureClientInitialized();
    final results = await _client!.getJsonList('movie/top_rated');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of upcoming movies.

  Future<List<Movie>> getUpcomingMovies() async {
    await _ensureClientInitialized();
    final results = await _client!.getJsonList('movie/upcoming');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Searches for movies matching the given query.

  Future<List<Movie>> searchMovies(String query) async {
    await _ensureClientInitialized();
    final results = await _client!.getJsonList(
      'search/movie?query=${Uri.encodeComponent(query)}',
    );
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Searches for movies by actor/person name.

  Future<List<Movie>> searchMoviesByActor(String actorName) async {
    await _ensureClientInitialized();

    // First search for people.

    final personResults = await _client!.getJsonList(
      'search/person?query=${Uri.encodeComponent(actorName)}',
    );

    if (personResults.isEmpty) return [];

    final allMovies = <Movie>[];
    final seenMovieIds = <int>{};

    // Determine if this is a specific search (contains space) or generic search.

    final isSpecificSearch = actorName.contains(' ');

    // Sort people by popularity (descending) and known_for_department.

    final sortedPeople = List<Map<String, dynamic>>.from(personResults);
    sortedPeople.sort((a, b) {
      final popularityA = (a['popularity'] as num?)?.toDouble() ?? 0.0;
      final popularityB = (b['popularity'] as num?)?.toDouble() ?? 0.0;

      // Prioritise actors over other professions.

      final knownForA = a['known_for_department'] as String? ?? '';
      final knownForB = b['known_for_department'] as String? ?? '';
      final isActorA = knownForA.toLowerCase() == 'acting';
      final isActorB = knownForB.toLowerCase() == 'acting';

      if (isActorA && !isActorB) return -1;
      if (!isActorA && isActorB) return 1;

      return popularityB.compareTo(popularityA);
    });

    // For generic searches, process more people to find famous actors.
    // For specific searches, process fewer but still enough to find the target.

    final maxPeopleToProcess = isSpecificSearch ? 5 : 10;
    final peopleToProcess = sortedPeople.take(maxPeopleToProcess);

    for (final person in peopleToProcess) {
      try {
        final personId = person['id'];
        final popularity = (person['popularity'] as num?)?.toDouble() ?? 0.0;

        // Skip people who are too unknown (but be more lenient for specific searches).

        final minPopularity = isSpecificSearch ? 0.1 : 0.5;
        if (popularity < minPopularity) {
          continue;
        }

        final movieCredits = await _client!.getJson(
          'person/$personId/movie_credits',
        );
        final cast = movieCredits['cast'] as List<dynamic>? ?? [];

        for (final movieData in cast) {
          final movieId = movieData['id'] as int;

          // Avoid duplicate movies.

          if (!seenMovieIds.contains(movieId)) {
            try {
              final movie = Movie.fromJson(movieData);
              allMovies.add(movie);
              seenMovieIds.add(movieId);
            } catch (e) {
              continue;
            }
          }
        }

        // If we have a very specific search and found a highly popular match, prioritise that.

        if (isSpecificSearch && popularity > 10.0) {
          break;
        }
      } catch (e) {
        continue;
      }
    }

    // Sort by popularity/rating for better results ordering.

    allMovies.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));

    return allMovies;
  }

  /// Searches for movies by genre name.

  Future<List<Movie>> searchMoviesByGenre(String genreName) async {
    await _ensureClientInitialized();

    // Get genre list first.

    final genreResponse = await _client!.getJson('genre/movie/list');
    final genres = genreResponse['genres'] as List<dynamic>;

    // Find matching genre.

    final matchingGenre = genres.firstWhere(
      (genre) => (genre['name'] as String).toLowerCase().contains(
        genreName.toLowerCase(),
      ),
      orElse: () => null,
    );

    if (matchingGenre == null) return [];

    // Search movies by genre ID.

    final genreId = matchingGenre['id'];
    final results = await _client!.getJsonList(
      'discover/movie?with_genres=$genreId',
    );

    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Comprehensive search that searches by title, actor, and genre.

  Future<Map<String, List<Movie>>> searchMoviesComprehensive(
    String query,
  ) async {
    await _ensureClientInitialized();

    final results = <String, List<Movie>>{};

    try {
      // Search by title.

      results['title'] = await searchMovies(query);
    } catch (e) {
      results['title'] = [];
    }

    try {
      // Search by actor.

      results['actor'] = await searchMoviesByActor(query);
    } catch (e) {
      results['actor'] = [];
    }

    try {
      // Search by genre.

      results['genre'] = await searchMoviesByGenre(query);
    } catch (e) {
      results['genre'] = [];
    }

    return results;
  }

  /// Gets detailed information about a specific movie.

  Future<Movie> getMovieDetails(int movieId) async {
    await _ensureClientInitialized();
    final data = await _client!.getJson('movie/$movieId');
    return Movie.fromJson(data);
  }

  /// Disposes the network client.

  void dispose() {
    _client?.dispose();
    // Reset to null after disposal.

    _client = null;
  }
}
