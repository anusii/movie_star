// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MoviesTable extends Movies with TableInfo<$MoviesTable, Movy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backdropPathMeta = const VerificationMeta(
    'backdropPath',
  );
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
    'backdrop_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voteAverageMeta = const VerificationMeta(
    'voteAverage',
  );
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
    'vote_average',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
    'release_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genreIdsMeta = const VerificationMeta(
    'genreIds',
  );
  @override
  late final GeneratedColumn<String> genreIds = GeneratedColumn<String>(
    'genre_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        genreIds,
        cachedAt,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    } else if (isInserting) {
      context.missing(_overviewMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    } else if (isInserting) {
      context.missing(_posterPathMeta);
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
        _backdropPathMeta,
        backdropPath.isAcceptableOrUnknown(
          data['backdrop_path']!,
          _backdropPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backdropPathMeta);
    }
    if (data.containsKey('vote_average')) {
      context.handle(
        _voteAverageMeta,
        voteAverage.isAcceptableOrUnknown(
          data['vote_average']!,
          _voteAverageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_voteAverageMeta);
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_releaseDateMeta);
    }
    if (data.containsKey('genre_ids')) {
      context.handle(
        _genreIdsMeta,
        genreIds.isAcceptableOrUnknown(data['genre_ids']!, _genreIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_genreIdsMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      )!,
      backdropPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_path'],
      )!,
      voteAverage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vote_average'],
      )!,
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}release_date'],
      )!,
      genreIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre_ids'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $MoviesTable createAlias(String alias) {
    return $MoviesTable(attachedDatabase, alias);
  }
}

class Movy extends DataClass implements Insertable<Movy> {
  /// Unique identifier for the movie (from TMDB API)
  final int id;

  /// Title of the movie
  final String title;

  /// Overview/description of the movie
  final String overview;

  /// Path to the movie's poster image (without base URL)
  final String posterPath;

  /// Path to the movie's backdrop image (without base URL)
  final String backdropPath;

  /// Average rating of the movie
  final double voteAverage;

  /// Release date of the movie
  final DateTime releaseDate;

  /// JSON string of genre IDs
  final String genreIds;

  /// Timestamp when this movie was cached
  final DateTime cachedAt;
  const Movy({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['overview'] = Variable<String>(overview);
    map['poster_path'] = Variable<String>(posterPath);
    map['backdrop_path'] = Variable<String>(backdropPath);
    map['vote_average'] = Variable<double>(voteAverage);
    map['release_date'] = Variable<DateTime>(releaseDate);
    map['genre_ids'] = Variable<String>(genreIds);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MoviesCompanion toCompanion(bool nullToAbsent) {
    return MoviesCompanion(
      id: Value(id),
      title: Value(title),
      overview: Value(overview),
      posterPath: Value(posterPath),
      backdropPath: Value(backdropPath),
      voteAverage: Value(voteAverage),
      releaseDate: Value(releaseDate),
      genreIds: Value(genreIds),
      cachedAt: Value(cachedAt),
    );
  }

  factory Movy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movy(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      overview: serializer.fromJson<String>(json['overview']),
      posterPath: serializer.fromJson<String>(json['posterPath']),
      backdropPath: serializer.fromJson<String>(json['backdropPath']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
      releaseDate: serializer.fromJson<DateTime>(json['releaseDate']),
      genreIds: serializer.fromJson<String>(json['genreIds']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'overview': serializer.toJson<String>(overview),
      'posterPath': serializer.toJson<String>(posterPath),
      'backdropPath': serializer.toJson<String>(backdropPath),
      'voteAverage': serializer.toJson<double>(voteAverage),
      'releaseDate': serializer.toJson<DateTime>(releaseDate),
      'genreIds': serializer.toJson<String>(genreIds),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  Movy copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    DateTime? releaseDate,
    String? genreIds,
    DateTime? cachedAt,
  }) =>
      Movy(
        id: id ?? this.id,
        title: title ?? this.title,
        overview: overview ?? this.overview,
        posterPath: posterPath ?? this.posterPath,
        backdropPath: backdropPath ?? this.backdropPath,
        voteAverage: voteAverage ?? this.voteAverage,
        releaseDate: releaseDate ?? this.releaseDate,
        genreIds: genreIds ?? this.genreIds,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  Movy copyWithCompanion(MoviesCompanion data) {
    return Movy(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      overview: data.overview.present ? data.overview.value : this.overview,
      posterPath:
          data.posterPath.present ? data.posterPath.value : this.posterPath,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      voteAverage:
          data.voteAverage.present ? data.voteAverage.value : this.voteAverage,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      genreIds: data.genreIds.present ? data.genreIds.value : this.genreIds,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movy(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genreIds: $genreIds, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        genreIds,
        cachedAt,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movy &&
          other.id == this.id &&
          other.title == this.title &&
          other.overview == this.overview &&
          other.posterPath == this.posterPath &&
          other.backdropPath == this.backdropPath &&
          other.voteAverage == this.voteAverage &&
          other.releaseDate == this.releaseDate &&
          other.genreIds == this.genreIds &&
          other.cachedAt == this.cachedAt);
}

class MoviesCompanion extends UpdateCompanion<Movy> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> overview;
  final Value<String> posterPath;
  final Value<String> backdropPath;
  final Value<double> voteAverage;
  final Value<DateTime> releaseDate;
  final Value<String> genreIds;
  final Value<DateTime> cachedAt;
  const MoviesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.overview = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.voteAverage = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.genreIds = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  MoviesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String overview,
    required String posterPath,
    required String backdropPath,
    required double voteAverage,
    required DateTime releaseDate,
    required String genreIds,
    this.cachedAt = const Value.absent(),
  })  : title = Value(title),
        overview = Value(overview),
        posterPath = Value(posterPath),
        backdropPath = Value(backdropPath),
        voteAverage = Value(voteAverage),
        releaseDate = Value(releaseDate),
        genreIds = Value(genreIds);
  static Insertable<Movy> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? overview,
    Expression<String>? posterPath,
    Expression<String>? backdropPath,
    Expression<double>? voteAverage,
    Expression<DateTime>? releaseDate,
    Expression<String>? genreIds,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (overview != null) 'overview': overview,
      if (posterPath != null) 'poster_path': posterPath,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (voteAverage != null) 'vote_average': voteAverage,
      if (releaseDate != null) 'release_date': releaseDate,
      if (genreIds != null) 'genre_ids': genreIds,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  MoviesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? overview,
    Value<String>? posterPath,
    Value<String>? backdropPath,
    Value<double>? voteAverage,
    Value<DateTime>? releaseDate,
    Value<String>? genreIds,
    Value<DateTime>? cachedAt,
  }) {
    return MoviesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (genreIds.present) {
      map['genre_ids'] = Variable<String>(genreIds.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoviesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('overview: $overview, ')
          ..write('posterPath: $posterPath, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('voteAverage: $voteAverage, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genreIds: $genreIds, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $MovieCategoriesTable extends MovieCategories
    with TableInfo<$MovieCategoriesTable, MovieCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovieCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movies (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
        id,
        movieId,
        category,
        position,
        cachedAt,
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movie_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovieCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovieCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovieCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $MovieCategoriesTable createAlias(String alias) {
    return $MovieCategoriesTable(attachedDatabase, alias);
  }
}

class MovieCategory extends DataClass implements Insertable<MovieCategory> {
  /// Auto-incrementing primary key
  final int id;

  /// Movie ID (foreign key to Movies table)
  final int movieId;

  /// Category type (popular, now_playing, top_rated, upcoming)
  final String category;

  /// Position in the category list (for maintaining order)
  final int position;

  /// Timestamp when this category entry was cached
  final DateTime cachedAt;
  const MovieCategory({
    required this.id,
    required this.movieId,
    required this.category,
    required this.position,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['movie_id'] = Variable<int>(movieId);
    map['category'] = Variable<String>(category);
    map['position'] = Variable<int>(position);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MovieCategoriesCompanion toCompanion(bool nullToAbsent) {
    return MovieCategoriesCompanion(
      id: Value(id),
      movieId: Value(movieId),
      category: Value(category),
      position: Value(position),
      cachedAt: Value(cachedAt),
    );
  }

  factory MovieCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovieCategory(
      id: serializer.fromJson<int>(json['id']),
      movieId: serializer.fromJson<int>(json['movieId']),
      category: serializer.fromJson<String>(json['category']),
      position: serializer.fromJson<int>(json['position']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<int>(movieId),
      'category': serializer.toJson<String>(category),
      'position': serializer.toJson<int>(position),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  MovieCategory copyWith({
    int? id,
    int? movieId,
    String? category,
    int? position,
    DateTime? cachedAt,
  }) =>
      MovieCategory(
        id: id ?? this.id,
        movieId: movieId ?? this.movieId,
        category: category ?? this.category,
        position: position ?? this.position,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  MovieCategory copyWithCompanion(MovieCategoriesCompanion data) {
    return MovieCategory(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      category: data.category.present ? data.category.value : this.category,
      position: data.position.present ? data.position.value : this.position,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovieCategory(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, movieId, category, position, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovieCategory &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.category == this.category &&
          other.position == this.position &&
          other.cachedAt == this.cachedAt);
}

class MovieCategoriesCompanion extends UpdateCompanion<MovieCategory> {
  final Value<int> id;
  final Value<int> movieId;
  final Value<String> category;
  final Value<int> position;
  final Value<DateTime> cachedAt;
  const MovieCategoriesCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.category = const Value.absent(),
    this.position = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  MovieCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int movieId,
    required String category,
    required int position,
    this.cachedAt = const Value.absent(),
  })  : movieId = Value(movieId),
        category = Value(category),
        position = Value(position);
  static Insertable<MovieCategory> custom({
    Expression<int>? id,
    Expression<int>? movieId,
    Expression<String>? category,
    Expression<int>? position,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (category != null) 'category': category,
      if (position != null) 'position': position,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  MovieCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? movieId,
    Value<String>? category,
    Value<int>? position,
    Value<DateTime>? cachedAt,
  }) {
    return MovieCategoriesCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      category: category ?? this.category,
      position: position ?? this.position,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovieCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('category: $category, ')
          ..write('position: $position, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $CacheMetadataTable extends CacheMetadata
    with TableInfo<$CacheMetadataTable, CacheMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movieCountMeta = const VerificationMeta(
    'movieCount',
  );
  @override
  late final GeneratedColumn<int> movieCount = GeneratedColumn<int>(
    'movie_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [category, lastUpdated, movieCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('movie_count')) {
      context.handle(
        _movieCountMeta,
        movieCount.isAcceptableOrUnknown(data['movie_count']!, _movieCountMeta),
      );
    } else if (isInserting) {
      context.missing(_movieCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {category};
  @override
  CacheMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetadataData(
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
      movieCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_count'],
      )!,
    );
  }

  @override
  $CacheMetadataTable createAlias(String alias) {
    return $CacheMetadataTable(attachedDatabase, alias);
  }
}

class CacheMetadataData extends DataClass
    implements Insertable<CacheMetadataData> {
  /// Category identifier (e.g., 'popular', 'now_playing')
  final String category;

  /// Timestamp when this category was last updated
  final DateTime lastUpdated;

  /// Number of movies in this category
  final int movieCount;
  const CacheMetadataData({
    required this.category,
    required this.lastUpdated,
    required this.movieCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category'] = Variable<String>(category);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['movie_count'] = Variable<int>(movieCount);
    return map;
  }

  CacheMetadataCompanion toCompanion(bool nullToAbsent) {
    return CacheMetadataCompanion(
      category: Value(category),
      lastUpdated: Value(lastUpdated),
      movieCount: Value(movieCount),
    );
  }

  factory CacheMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetadataData(
      category: serializer.fromJson<String>(json['category']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      movieCount: serializer.fromJson<int>(json['movieCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'category': serializer.toJson<String>(category),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'movieCount': serializer.toJson<int>(movieCount),
    };
  }

  CacheMetadataData copyWith({
    String? category,
    DateTime? lastUpdated,
    int? movieCount,
  }) =>
      CacheMetadataData(
        category: category ?? this.category,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        movieCount: movieCount ?? this.movieCount,
      );
  CacheMetadataData copyWithCompanion(CacheMetadataCompanion data) {
    return CacheMetadataData(
      category: data.category.present ? data.category.value : this.category,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      movieCount:
          data.movieCount.present ? data.movieCount.value : this.movieCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataData(')
          ..write('category: $category, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('movieCount: $movieCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(category, lastUpdated, movieCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetadataData &&
          other.category == this.category &&
          other.lastUpdated == this.lastUpdated &&
          other.movieCount == this.movieCount);
}

class CacheMetadataCompanion extends UpdateCompanion<CacheMetadataData> {
  final Value<String> category;
  final Value<DateTime> lastUpdated;
  final Value<int> movieCount;
  final Value<int> rowid;
  const CacheMetadataCompanion({
    this.category = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.movieCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetadataCompanion.insert({
    required String category,
    required DateTime lastUpdated,
    required int movieCount,
    this.rowid = const Value.absent(),
  })  : category = Value(category),
        lastUpdated = Value(lastUpdated),
        movieCount = Value(movieCount);
  static Insertable<CacheMetadataData> custom({
    Expression<String>? category,
    Expression<DateTime>? lastUpdated,
    Expression<int>? movieCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (category != null) 'category': category,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (movieCount != null) 'movie_count': movieCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetadataCompanion copyWith({
    Value<String>? category,
    Value<DateTime>? lastUpdated,
    Value<int>? movieCount,
    Value<int>? rowid,
  }) {
    return CacheMetadataCompanion(
      category: category ?? this.category,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      movieCount: movieCount ?? this.movieCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (movieCount.present) {
      map['movie_count'] = Variable<int>(movieCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataCompanion(')
          ..write('category: $category, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('movieCount: $movieCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoviesTable movies = $MoviesTable(this);
  late final $MovieCategoriesTable movieCategories = $MovieCategoriesTable(
    this,
  );
  late final $CacheMetadataTable cacheMetadata = $CacheMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        movies,
        movieCategories,
        cacheMetadata,
      ];
}

typedef $$MoviesTableCreateCompanionBuilder = MoviesCompanion Function({
  Value<int> id,
  required String title,
  required String overview,
  required String posterPath,
  required String backdropPath,
  required double voteAverage,
  required DateTime releaseDate,
  required String genreIds,
  Value<DateTime> cachedAt,
});
typedef $$MoviesTableUpdateCompanionBuilder = MoviesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> overview,
  Value<String> posterPath,
  Value<String> backdropPath,
  Value<double> voteAverage,
  Value<DateTime> releaseDate,
  Value<String> genreIds,
  Value<DateTime> cachedAt,
});

final class $$MoviesTableReferences
    extends BaseReferences<_$AppDatabase, $MoviesTable, Movy> {
  $$MoviesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovieCategoriesTable, List<MovieCategory>>
      _movieCategoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(
            db.movieCategories,
            aliasName:
                $_aliasNameGenerator(db.movies.id, db.movieCategories.movieId),
          );

  $$MovieCategoriesTableProcessedTableManager get movieCategoriesRefs {
    final manager = $$MovieCategoriesTableTableManager(
      $_db,
      $_db.movieCategories,
    ).filter((f) => f.movieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movieCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MoviesTableFilterComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
        column: $table.title,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get overview => $composableBuilder(
        column: $table.overview,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get posterPath => $composableBuilder(
        column: $table.posterPath,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get backdropPath => $composableBuilder(
        column: $table.backdropPath,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<double> get voteAverage => $composableBuilder(
        column: $table.voteAverage,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
        column: $table.releaseDate,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get genreIds => $composableBuilder(
        column: $table.genreIds,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
        column: $table.cachedAt,
        builder: (column) => ColumnFilters(column),
      );

  Expression<bool> movieCategoriesRefs(
    Expression<bool> Function($$MovieCategoriesTableFilterComposer f) f,
  ) {
    final $$MovieCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieCategories,
      getReferencedColumn: (t) => t.movieId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$MovieCategoriesTableFilterComposer(
        $db: $db,
        $table: $db.movieCategories,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$MoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get title => $composableBuilder(
        column: $table.title,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get overview => $composableBuilder(
        column: $table.overview,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get posterPath => $composableBuilder(
        column: $table.posterPath,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get backdropPath => $composableBuilder(
        column: $table.backdropPath,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<double> get voteAverage => $composableBuilder(
        column: $table.voteAverage,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
        column: $table.releaseDate,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get genreIds => $composableBuilder(
        column: $table.genreIds,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
        column: $table.cachedAt,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$MoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoviesTable> {
  $$MoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
        column: $table.posterPath,
        builder: (column) => column,
      );

  GeneratedColumn<String> get backdropPath => $composableBuilder(
        column: $table.backdropPath,
        builder: (column) => column,
      );

  GeneratedColumn<double> get voteAverage => $composableBuilder(
        column: $table.voteAverage,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
        column: $table.releaseDate,
        builder: (column) => column,
      );

  GeneratedColumn<String> get genreIds =>
      $composableBuilder(column: $table.genreIds, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  Expression<T> movieCategoriesRefs<T extends Object>(
    Expression<T> Function($$MovieCategoriesTableAnnotationComposer a) f,
  ) {
    final $$MovieCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movieCategories,
      getReferencedColumn: (t) => t.movieId,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$MovieCategoriesTableAnnotationComposer(
        $db: $db,
        $table: $db.movieCategories,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return f(composer);
  }
}

class $$MoviesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MoviesTable,
    Movy,
    $$MoviesTableFilterComposer,
    $$MoviesTableOrderingComposer,
    $$MoviesTableAnnotationComposer,
    $$MoviesTableCreateCompanionBuilder,
    $$MoviesTableUpdateCompanionBuilder,
    (Movy, $$MoviesTableReferences),
    Movy,
    PrefetchHooks Function({bool movieCategoriesRefs})> {
  $$MoviesTableTableManager(_$AppDatabase db, $MoviesTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$MoviesTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$MoviesTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$MoviesTableAnnotationComposer($db: db, $table: table),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<String> title = const Value.absent(),
              Value<String> overview = const Value.absent(),
              Value<String> posterPath = const Value.absent(),
              Value<String> backdropPath = const Value.absent(),
              Value<double> voteAverage = const Value.absent(),
              Value<DateTime> releaseDate = const Value.absent(),
              Value<String> genreIds = const Value.absent(),
              Value<DateTime> cachedAt = const Value.absent(),
            }) =>
                MoviesCompanion(
              id: id,
              title: title,
              overview: overview,
              posterPath: posterPath,
              backdropPath: backdropPath,
              voteAverage: voteAverage,
              releaseDate: releaseDate,
              genreIds: genreIds,
              cachedAt: cachedAt,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required String title,
              required String overview,
              required String posterPath,
              required String backdropPath,
              required double voteAverage,
              required DateTime releaseDate,
              required String genreIds,
              Value<DateTime> cachedAt = const Value.absent(),
            }) =>
                MoviesCompanion.insert(
              id: id,
              title: title,
              overview: overview,
              posterPath: posterPath,
              backdropPath: backdropPath,
              voteAverage: voteAverage,
              releaseDate: releaseDate,
              genreIds: genreIds,
              cachedAt: cachedAt,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$MoviesTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({movieCategoriesRefs = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [
                  if (movieCategoriesRefs) db.movieCategories,
                ],
                addJoins: null,
                getPrefetchedDataCallback: (items) async {
                  return [
                    if (movieCategoriesRefs)
                      await $_getPrefetchedData<Movy, $MoviesTable,
                          MovieCategory>(
                        currentTable: table,
                        referencedTable: $$MoviesTableReferences
                            ._movieCategoriesRefsTable(db),
                        managerFromTypedResult: (p0) => $$MoviesTableReferences(
                          db,
                          table,
                          p0,
                        ).movieCategoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                          (e) => e.movieId == item.id,
                        ),
                        typedResults: items,
                      ),
                  ];
                },
              );
            },
          ),
        );
}

typedef $$MoviesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MoviesTable,
    Movy,
    $$MoviesTableFilterComposer,
    $$MoviesTableOrderingComposer,
    $$MoviesTableAnnotationComposer,
    $$MoviesTableCreateCompanionBuilder,
    $$MoviesTableUpdateCompanionBuilder,
    (Movy, $$MoviesTableReferences),
    Movy,
    PrefetchHooks Function({bool movieCategoriesRefs})>;
typedef $$MovieCategoriesTableCreateCompanionBuilder = MovieCategoriesCompanion
    Function({
  Value<int> id,
  required int movieId,
  required String category,
  required int position,
  Value<DateTime> cachedAt,
});
typedef $$MovieCategoriesTableUpdateCompanionBuilder = MovieCategoriesCompanion
    Function({
  Value<int> id,
  Value<int> movieId,
  Value<String> category,
  Value<int> position,
  Value<DateTime> cachedAt,
});

final class $$MovieCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $MovieCategoriesTable, MovieCategory> {
  $$MovieCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MoviesTable _movieIdTable(_$AppDatabase db) => db.movies.createAlias(
        $_aliasNameGenerator(db.movieCategories.movieId, db.movies.id),
      );

  $$MoviesTableProcessedTableManager get movieId {
    final $_column = $_itemColumn<int>('movie_id')!;

    final manager = $$MoviesTableTableManager(
      $_db,
      $_db.movies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovieCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MovieCategoriesTable> {
  $$MovieCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<String> get category => $composableBuilder(
        column: $table.category,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get position => $composableBuilder(
        column: $table.position,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
        column: $table.cachedAt,
        builder: (column) => ColumnFilters(column),
      );

  $$MoviesTableFilterComposer get movieId {
    final $$MoviesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$MoviesTableFilterComposer(
        $db: $db,
        $table: $db.movies,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$MovieCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MovieCategoriesTable> {
  $$MovieCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
        column: $table.id,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<String> get category => $composableBuilder(
        column: $table.category,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get position => $composableBuilder(
        column: $table.position,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
        column: $table.cachedAt,
        builder: (column) => ColumnOrderings(column),
      );

  $$MoviesTableOrderingComposer get movieId {
    final $$MoviesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$MoviesTableOrderingComposer(
        $db: $db,
        $table: $db.movies,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$MovieCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovieCategoriesTable> {
  $$MovieCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  $$MoviesTableAnnotationComposer get movieId {
    final $$MoviesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movieId,
      referencedTable: $db.movies,
      getReferencedColumn: (t) => t.id,
      builder: (
        joinBuilder, {
        $addJoinBuilderToRootComposer,
        $removeJoinBuilderFromRootComposer,
      }) =>
          $$MoviesTableAnnotationComposer(
        $db: $db,
        $table: $db.movies,
        $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
        joinBuilder: joinBuilder,
        $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
      ),
    );
    return composer;
  }
}

class $$MovieCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovieCategoriesTable,
    MovieCategory,
    $$MovieCategoriesTableFilterComposer,
    $$MovieCategoriesTableOrderingComposer,
    $$MovieCategoriesTableAnnotationComposer,
    $$MovieCategoriesTableCreateCompanionBuilder,
    $$MovieCategoriesTableUpdateCompanionBuilder,
    (MovieCategory, $$MovieCategoriesTableReferences),
    MovieCategory,
    PrefetchHooks Function({bool movieId})> {
  $$MovieCategoriesTableTableManager(
    _$AppDatabase db,
    $MovieCategoriesTable table,
  ) : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$MovieCategoriesTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$MovieCategoriesTableOrderingComposer(
              $db: db,
              $table: table,
            ),
            createComputedFieldComposer: () =>
                $$MovieCategoriesTableAnnotationComposer(
              $db: db,
              $table: table,
            ),
            updateCompanionCallback: ({
              Value<int> id = const Value.absent(),
              Value<int> movieId = const Value.absent(),
              Value<String> category = const Value.absent(),
              Value<int> position = const Value.absent(),
              Value<DateTime> cachedAt = const Value.absent(),
            }) =>
                MovieCategoriesCompanion(
              id: id,
              movieId: movieId,
              category: category,
              position: position,
              cachedAt: cachedAt,
            ),
            createCompanionCallback: ({
              Value<int> id = const Value.absent(),
              required int movieId,
              required String category,
              required int position,
              Value<DateTime> cachedAt = const Value.absent(),
            }) =>
                MovieCategoriesCompanion.insert(
              id: id,
              movieId: movieId,
              category: category,
              position: position,
              cachedAt: cachedAt,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    $$MovieCategoriesTableReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: ({movieId = false}) {
              return PrefetchHooks(
                db: db,
                explicitlyWatchedTables: [],
                addJoins: <
                    T extends TableManagerState<
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic,
                        dynamic>>(state) {
                  if (movieId) {
                    state = state.withJoin(
                      currentTable: table,
                      currentColumn: table.movieId,
                      referencedTable:
                          $$MovieCategoriesTableReferences._movieIdTable(db),
                      referencedColumn:
                          $$MovieCategoriesTableReferences._movieIdTable(db).id,
                    ) as T;
                  }

                  return state;
                },
                getPrefetchedDataCallback: (items) async {
                  return [];
                },
              );
            },
          ),
        );
}

typedef $$MovieCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovieCategoriesTable,
    MovieCategory,
    $$MovieCategoriesTableFilterComposer,
    $$MovieCategoriesTableOrderingComposer,
    $$MovieCategoriesTableAnnotationComposer,
    $$MovieCategoriesTableCreateCompanionBuilder,
    $$MovieCategoriesTableUpdateCompanionBuilder,
    (MovieCategory, $$MovieCategoriesTableReferences),
    MovieCategory,
    PrefetchHooks Function({bool movieId})>;
typedef $$CacheMetadataTableCreateCompanionBuilder = CacheMetadataCompanion
    Function({
  required String category,
  required DateTime lastUpdated,
  required int movieCount,
  Value<int> rowid,
});
typedef $$CacheMetadataTableUpdateCompanionBuilder = CacheMetadataCompanion
    Function({
  Value<String> category,
  Value<DateTime> lastUpdated,
  Value<int> movieCount,
  Value<int> rowid,
});

class $$CacheMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get category => $composableBuilder(
        column: $table.category,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
        column: $table.lastUpdated,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get movieCount => $composableBuilder(
        column: $table.movieCount,
        builder: (column) => ColumnFilters(column),
      );
}

class $$CacheMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get category => $composableBuilder(
        column: $table.category,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
        column: $table.lastUpdated,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get movieCount => $composableBuilder(
        column: $table.movieCount,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$CacheMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
        column: $table.lastUpdated,
        builder: (column) => column,
      );

  GeneratedColumn<int> get movieCount => $composableBuilder(
        column: $table.movieCount,
        builder: (column) => column,
      );
}

class $$CacheMetadataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CacheMetadataTable,
    CacheMetadataData,
    $$CacheMetadataTableFilterComposer,
    $$CacheMetadataTableOrderingComposer,
    $$CacheMetadataTableAnnotationComposer,
    $$CacheMetadataTableCreateCompanionBuilder,
    $$CacheMetadataTableUpdateCompanionBuilder,
    (
      CacheMetadataData,
      BaseReferences<_$AppDatabase, $CacheMetadataTable, CacheMetadataData>,
    ),
    CacheMetadataData,
    PrefetchHooks Function()> {
  $$CacheMetadataTableTableManager(_$AppDatabase db, $CacheMetadataTable table)
      : super(
          TableManagerState(
            db: db,
            table: table,
            createFilteringComposer: () =>
                $$CacheMetadataTableFilterComposer($db: db, $table: table),
            createOrderingComposer: () =>
                $$CacheMetadataTableOrderingComposer($db: db, $table: table),
            createComputedFieldComposer: () =>
                $$CacheMetadataTableAnnotationComposer(
              $db: db,
              $table: table,
            ),
            updateCompanionCallback: ({
              Value<String> category = const Value.absent(),
              Value<DateTime> lastUpdated = const Value.absent(),
              Value<int> movieCount = const Value.absent(),
              Value<int> rowid = const Value.absent(),
            }) =>
                CacheMetadataCompanion(
              category: category,
              lastUpdated: lastUpdated,
              movieCount: movieCount,
              rowid: rowid,
            ),
            createCompanionCallback: ({
              required String category,
              required DateTime lastUpdated,
              required int movieCount,
              Value<int> rowid = const Value.absent(),
            }) =>
                CacheMetadataCompanion.insert(
              category: category,
              lastUpdated: lastUpdated,
              movieCount: movieCount,
              rowid: rowid,
            ),
            withReferenceMapper: (p0) => p0
                .map(
                  (e) => (
                    e.readTable(table),
                    BaseReferences(db, table, e),
                  ),
                )
                .toList(),
            prefetchHooksCallback: null,
          ),
        );
}

typedef $$CacheMetadataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CacheMetadataTable,
    CacheMetadataData,
    $$CacheMetadataTableFilterComposer,
    $$CacheMetadataTableOrderingComposer,
    $$CacheMetadataTableAnnotationComposer,
    $$CacheMetadataTableCreateCompanionBuilder,
    $$CacheMetadataTableUpdateCompanionBuilder,
    (
      CacheMetadataData,
      BaseReferences<_$AppDatabase, $CacheMetadataTable, CacheMetadataData>,
    ),
    CacheMetadataData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoviesTableTableManager get movies =>
      $$MoviesTableTableManager(_db, _db.movies);
  $$MovieCategoriesTableTableManager get movieCategories =>
      $$MovieCategoriesTableTableManager(_db, _db.movieCategories);
  $$CacheMetadataTableTableManager get cacheMetadata =>
      $$CacheMetadataTableTableManager(_db, _db.cacheMetadata);
}
