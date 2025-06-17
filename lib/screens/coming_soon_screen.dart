/// Screen displaying upcoming movies and their release dates.
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

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:moviestar/models/movie.dart';
import 'package:moviestar/screens/movie_details_screen.dart';
import 'package:moviestar/services/favorites_service.dart';
import 'package:moviestar/services/movie_service.dart';
import 'package:moviestar/utils/date_format_util.dart';

// A screen that displays upcoming movies and their release dates.

class ComingSoonScreen extends StatefulWidget {
  // Service for managing favorite movies.

  final FavoritesService favoritesService;
  final MovieService movieService;

  // Creates a new [ComingSoonScreen] widget.

  const ComingSoonScreen({
    super.key,
    required this.favoritesService,
    required this.movieService,
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

// State class for the coming soon screen.

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  // Loading state indicator.
  bool _isLoading = false;

  // Error message if any.
  String? _error;

  // List of upcoming movies.
  List<Movie> _upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    _loadUpcomingMovies();
  }

  // Loads the list of upcoming movies.

  Future<void> _loadUpcomingMovies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final movies = await widget.movieService.getUpcomingMovies();
      setState(() {
        _upcomingMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Coming Soon',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                itemCount: _upcomingMovies.length,
                itemBuilder: (context, index) {
                  final movie = _upcomingMovies[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: movie.posterUrl,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      movie.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Release Date: ${DateFormatUtil.formatNumeric(movie.releaseDate)}',
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
              ),
    );
  }
}
