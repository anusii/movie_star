/// Welcome dialog for introducing cache features to new users.
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

import 'package:shared_preferences/shared_preferences.dart';

/// Dialog to welcome new users and introduce cache features.

class CacheWelcomeDialog extends StatelessWidget {
  /// Callback when user wants to go to settings.

  final VoidCallback? onGoToSettings;

  /// Creates a cache welcome dialog.

  const CacheWelcomeDialog({super.key, this.onGoToSettings});

  /// Shows the welcome dialog if it hasn't been shown before.

  static Future<void> showIfFirstTime(
    BuildContext context, {
    VoidCallback? onGoToSettings,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownWelcome = prefs.getBool('cache_welcome_shown') ?? false;

    if (!hasShownWelcome && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => CacheWelcomeDialog(onGoToSettings: onGoToSettings),
      );
      await prefs.setBool('cache_welcome_shown', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.offline_bolt, color: Colors.green, size: 28),
          SizedBox(width: 8),
          Text('Welcome to Movie Star!'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Movie Star now includes smart caching to improve your experience:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          _FeatureItem(
            icon: Icons.offline_bolt,
            color: Colors.green,
            title: 'Lightning Fast Loading',
            description: 'Movies load instantly from cache',
          ),
          SizedBox(height: 12),
          _FeatureItem(
            icon: Icons.offline_pin,
            color: Colors.orange,
            title: 'Offline Mode',
            description: 'Browse movies without internet',
          ),
          SizedBox(height: 12),
          _FeatureItem(
            icon: Icons.storage,
            color: Colors.blue,
            title: 'Smart Caching',
            description: 'Automatically saves data for better performance',
          ),
          SizedBox(height: 16),
          Text(
            'Look for these cache indicators throughout the app!',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it!'),
        ),
        if (onGoToSettings != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onGoToSettings!();
            },
            child: const Text('Cache Settings'),
          ),
      ],
    );
  }
}

/// Widget for displaying a feature item in the welcome dialog.

class _FeatureItem extends StatelessWidget {
  /// Icon to display.

  final IconData icon;

  /// Color of the icon.

  final Color color;

  /// Title of the feature.

  final String title;

  /// Description of the feature.

  final String description;

  /// Creates a feature item.

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
