/// A floating search button that can be positioned anywhere on screen.
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
/// Authors: Ashley Tang

library;

import 'package:flutter/material.dart';

import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:moviestar/screens/search_screen.dart';
import 'package:moviestar/services/favorites_service.dart';
import 'package:moviestar/services/movie_service.dart';

class FloatingSearchButton extends StatelessWidget {
  /// Position from the right edge of the screen.

  final double? right;

  /// Position from the top edge of the screen.

  final double? top;

  /// Position from the bottom edge of the screen.

  final double? bottom;

  /// Position from the left edge of the screen.

  final double? left;

  /// Service for managing favorite movies.

  final FavoritesService favoritesService;

  /// Service for managing movies.

  final MovieService movieService;

  /// Creates a new [FloatingSearchButton] widget.

  const FloatingSearchButton({
    super.key,
    this.right,
    this.top = 50,
    this.bottom,
    this.left,
    required this.favoritesService,
    required this.movieService,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      bottom: bottom,
      left: left,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: MarkdownTooltip(
            message: '''

**Movie Search**

🔍 **Search Movies**

Search movies by title, actor, or genre for your perfect film.

            ''',
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                      favoritesService: favoritesService,
                      movieService: movieService,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
