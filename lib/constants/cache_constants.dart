/// Cache constants for the Movie Star application.
///
// Time-stamp: <Friday 2025-02-21 17:02:01 +1100 Graham Williams>
///
/// Copyright (C) 2024-2025, Software Innovation Institute, ANU.
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

/// Movie category constants for caching.

class MovieCategories {
  /// Popular movies category.

  static const String popular = 'popular';

  /// Currently playing movies category.

  static const String nowPlaying = 'now_playing';

  /// Top rated movies category.

  static const String topRated = 'top_rated';

  /// Upcoming movies category.

  static const String upcoming = 'upcoming';

  /// List of all available categories.

  static const List<String> all = [popular, nowPlaying, topRated, upcoming];
}

/// Cache duration constants.

class CacheDuration {
  /// Default cache duration for movie data (1 hour).

  static const Duration defaultDuration = Duration(hours: 1);

  /// Short cache duration for frequently changing data (15 minutes).

  static const Duration shortDuration = Duration(minutes: 15);

  /// Long cache duration for rarely changing data (24 hours).

  static const Duration longDuration = Duration(hours: 24);
}
