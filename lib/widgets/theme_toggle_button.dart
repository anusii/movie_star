/// Theme toggle button widget for switching between light and dark modes.
///
// Time-stamp: <Thursday 2025-01-16 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.

library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moviestar/providers/theme_provider.dart';

/// A widget that displays a theme toggle button.
class ThemeToggleButton extends ConsumerWidget {
  /// Whether to show as an icon button or a regular button.
  final bool isIconButton;
  
  /// Custom icon for light mode (defaults to sun icon).
  final IconData? lightModeIcon;
  
  /// Custom icon for dark mode (defaults to moon icon).
  final IconData? darkModeIcon;
  
  /// Tooltip text for the button.
  final String? tooltip;

  /// Creates a new [ThemeToggleButton] widget.
  const ThemeToggleButton({
    super.key,
    this.isIconButton = true,
    this.lightModeIcon,
    this.darkModeIcon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    
    final isDarkMode = themeMode == ThemeMode.dark;
    final icon = isDarkMode 
        ? (lightModeIcon ?? Icons.light_mode)
        : (darkModeIcon ?? Icons.dark_mode);
    
    final buttonTooltip = tooltip ?? 
        (isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode');

    if (isIconButton) {
      return IconButton(
        icon: Icon(icon),
        tooltip: buttonTooltip,
        onPressed: () async {
          await themeModeNotifier.toggleTheme();
        },
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () async {
          await themeModeNotifier.toggleTheme();
        },
        icon: Icon(icon, size: 18),
        label: Text(isDarkMode ? 'Light' : 'Dark'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
    }
  }
}

/// A floating theme toggle button that can be positioned anywhere on screen.
class FloatingThemeToggle extends ConsumerWidget {
  /// Position from the right edge of the screen.
  final double? right;
  
  /// Position from the top edge of the screen.
  final double? top;
  
  /// Position from the bottom edge of the screen.
  final double? bottom;
  
  /// Position from the left edge of the screen.
  final double? left;

  /// Creates a new [FloatingThemeToggle] widget.
  const FloatingThemeToggle({
    super.key,
    this.right = 16,
    this.top = 50,
    this.bottom,
    this.left,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    
    final isDarkMode = themeMode == ThemeMode.dark;

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
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(isDarkMode),
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () async {
              await themeModeNotifier.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
} 