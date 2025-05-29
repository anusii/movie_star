/// Main home screen of the Movie Star application, displaying featured and trending movies.
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

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/favorites_service.dart';
import 'movie_details_screen.dart';
import 'search_screen.dart';

/// A screen that displays various movie categories and trending content.
class HomeScreen extends StatefulWidget {
  /// Service for managing favorite movies.

  final FavoritesService favoritesService;
  final MovieService movieService;

  /// Creates a new [HomeScreen] widget.

  const HomeScreen({
    super.key,
    required this.favoritesService,
    required this.movieService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State class for the home screen.

class _HomeScreenState extends State<HomeScreen> {
  /// Loading state indicator.

  bool _isLoading = true;

  /// Error message if any.

  String? _error;

  /// List of popular movies.

  List<Movie> _popularMovies = [];

  /// List of now playing movies.

  List<Movie> _nowPlayingMovies = [];

  /// List of top rated movies.

  List<Movie> _topRatedMovies = [];

  /// List of upcoming movies.

  List<Movie> _upcomingMovies = [];

  /// Map of scroll controllers for different movie categories.

  final Map<String, ScrollController> _scrollControllers = {};

  /// Controller for the search text field.
  final TextEditingController _searchController = TextEditingController();

  /// Whether the search bar is expanded.
  bool _isSearchExpanded = false;

  /// Current search query.
  String _searchQuery = '';

  /// Search results.
  List<Movie> _searchResults = [];

  /// Whether search is in progress.
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollControllers['popular'] = ScrollController();
    _scrollControllers['nowPlaying'] = ScrollController();
    _scrollControllers['topRated'] = ScrollController();
    _scrollControllers['upcoming'] = ScrollController();
    _loadAllMovies();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the movie service instance has changed or been updated.

    if (oldWidget.movieService != widget.movieService) {
      _loadAllMovies();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Loads all movie categories.

  Future<void> _loadAllMovies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final popular = await widget.movieService.getPopularMovies();
      final nowPlaying = await widget.movieService.getNowPlayingMovies();
      final topRated = await widget.movieService.getTopRatedMovies();
      final upcoming = await widget.movieService.getUpcomingMovies();

      setState(() {
        _popularMovies = popular;
        _nowPlayingMovies = nowPlaying;
        _topRatedMovies = topRated;
        _upcomingMovies = upcoming;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Performs search based on the current query.
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await widget.movieService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSearching = false;
      });
    }
  }

  /// Builds a movie poster image with error handling.
  Widget _buildMoviePoster(
    String imageUrl, {
    double width = 130,
    double height = 200,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              width: width,
              height: height,
              color: Colors.grey[900],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget:
            (context, url, error) => Container(
              width: width,
              height: height,
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie, color: Colors.grey, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Image not available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        memCacheWidth: (width * 2).toInt(), // Optimize memory usage
        memCacheHeight: (height * 2).toInt(),
      ),
    );
  }

  /// Builds a horizontal scrollable row of movies.
  Widget _buildMovieRow(String title, List<Movie> movies, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: Scrollbar(
            controller: _scrollControllers[key],
            thickness: 6,
            radius: const Radius.circular(3),
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollControllers[key],
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MovieDetailsScreen(
                                movie: movie,
                                favoritesService: widget.favoritesService,
                              ),
                        ),
                      );
                    },
                    child: _buildMoviePoster(movie.posterUrl),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the search results view.
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No movies found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return ListTile(
          leading: _buildMoviePoster(movie.posterUrl, width: 50, height: 75),
          title: Text(movie.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(
            '⭐ ${movie.voteAverage.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MovieDetailsScreen(
                      movie: movie,
                      favoritesService: widget.favoritesService,
                    ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            _isSearchExpanded
                ? TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _searchResults = [];
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _performSearch(value);
                  },
                )
                : const Text(
                  'MOVIE STAR',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearchExpanded ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  _searchQuery = '';
                  _searchResults = [];
                }
              });
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAllMovies,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : _isSearchExpanded
              ? _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSearchResults()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMovieRow(
                      'Popular on Movie Star',
                      _popularMovies,
                      'popular',
                    ),
                    _buildMovieRow(
                      'Now Playing',
                      _nowPlayingMovies,
                      'nowPlaying',
                    ),
                    _buildMovieRow('Top Rated', _topRatedMovies, 'topRated'),
                    _buildMovieRow('Upcoming', _upcomingMovies, 'upcoming'),
                  ],
                ),
              ),
    );
  }
}
