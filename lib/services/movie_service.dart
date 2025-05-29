import '../models/movie.dart';
import '../utils/network_client.dart';
import 'api_key_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// A service class that handles movie-related API requests.

class MovieService {
  /// Base URL for The Movie Database API.

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// Network client for making HTTP requests.

  NetworkClient _client;

  /// Service for managing the API key.

  final ApiKeyService _apiKeyService;

  /// Creates a new MovieService instance.

  MovieService(ApiKeyService apiKeyService)
    : _client = NetworkClient(
        baseUrl: _baseUrl,
        apiKey: apiKeyService.getApiKey() ?? '',
      ),
      _apiKeyService = apiKeyService;

  /// Updates the API key and recreates the network client.

  void updateApiKey() {
    _client.dispose();
    _client = NetworkClient(
      baseUrl: _baseUrl,
      apiKey: _apiKeyService.getApiKey() ?? '',
    );
  }

  /// Gets a list of popular movies.

  Future<List<Movie>> getPopularMovies() async {
    final results = await _client.getJsonList('movie/popular');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of movies currently playing in theaters.

  Future<List<Movie>> getNowPlayingMovies() async {
    final results = await _client.getJsonList('movie/now_playing');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of top rated movies.

  Future<List<Movie>> getTopRatedMovies() async {
    final results = await _client.getJsonList('movie/top_rated');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Gets a list of upcoming movies.

  Future<List<Movie>> getUpcomingMovies() async {
    final results = await _client.getJsonList('movie/upcoming');
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  /// Searches for movies based on the provided query.
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final apiKey = _apiKeyService.getApiKey();
    if (apiKey == null) {
      throw Exception('API key not set');
    }

    // Search by title
    final titleResults = await _searchByTitle(query, apiKey);

    // Search by actor
    final actorResults = await _searchByActor(query, apiKey);

    // Search by genre
    final genreResults = await _searchByGenre(query, apiKey);

    // Combine and deduplicate results
    final allResults = {...titleResults, ...actorResults, ...genreResults};
    return allResults.toList();
  }

  /// Searches for movies by title.
  Future<Set<Movie>> _searchByTitle(String query, String apiKey) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toSet();
    }
    return {};
  }

  /// Searches for movies by actor.
  Future<Set<Movie>> _searchByActor(String query, String apiKey) async {
    // First, search for the actor
    final actorResponse = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=$apiKey&query=$query',
      ),
    );

    if (actorResponse.statusCode != 200) return {};

    final actorData = jsonDecode(actorResponse.body);
    final actors = actorData['results'] as List;
    if (actors.isEmpty) return {};

    // Get movies for each actor found
    final Set<Movie> movies = {};
    for (var actor in actors) {
      final actorId = actor['id'];
      final moviesResponse = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/person/$actorId/movie_credits?api_key=$apiKey',
        ),
      );

      if (moviesResponse.statusCode == 200) {
        final moviesData = jsonDecode(moviesResponse.body);
        final cast = moviesData['cast'] as List;
        movies.addAll(cast.map((movie) => Movie.fromJson(movie)));
      }
    }
    return movies;
  }

  /// Searches for movies by genre.
  Future<Set<Movie>> _searchByGenre(String query, String apiKey) async {
    // First, get all genres
    final genresResponse = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey',
      ),
    );

    if (genresResponse.statusCode != 200) return {};

    final genresData = jsonDecode(genresResponse.body);
    final genres = genresData['genres'] as List;

    // Find matching genre
    final matchingGenre = genres.firstWhere(
      (genre) =>
          genre['name'].toString().toLowerCase().contains(query.toLowerCase()),
      orElse: () => null,
    );

    if (matchingGenre == null) return {};

    // Get movies for the matching genre
    final genreId = matchingGenre['id'];
    final moviesResponse = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId',
      ),
    );

    if (moviesResponse.statusCode == 200) {
      final moviesData = jsonDecode(moviesResponse.body);
      final results = moviesData['results'] as List;
      return results.map((movie) => Movie.fromJson(movie)).toSet();
    }
    return {};
  }

  /// Gets detailed information about a specific movie.

  Future<Movie> getMovieDetails(int movieId) async {
    final data = await _client.getJson('movie/$movieId');
    return Movie.fromJson(data);
  }

  /// Disposes the network client.

  void dispose() {
    _client.dispose();
  }
}
