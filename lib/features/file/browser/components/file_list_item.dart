/// A file list item widget for displaying individual files.
///
// Time-stamp: <Friday 2025-02-14 08:40:39 +1100 Graham Williams>
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

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:solidpod/solidpod.dart';

import 'package:moviestar/features/file/browser/models/file_item.dart';
import 'package:moviestar/theme/app_theme.dart';

/// A widget that displays a single file item with its metadata and actions.
///
/// The widget adapts its layout based on available width constraints:
/// - At < 40px: Shows only the file name.
/// - At 40-100px: Adds file icon with minimal spacing.
/// - At 100-150px: Increases icon spacing.
/// - At > 150px: Shows modification date.
/// - At > 200px: Shows action buttons (download, delete).
///
/// The item supports selection state, showing a highlight when selected.
/// Action buttons are conditionally rendered based on available space.

class FileListItem extends StatelessWidget {
  /// The file item to display.

  final FileItem file;

  /// The current directory path.

  final String currentPath;

  /// Whether this file is currently selected.

  final bool isSelected;

  /// Callback when the file is selected.

  final Function(String, String) onFileSelected;

  /// Callback when the file is downloaded.

  final Function(String, String) onFileDownload;

  /// Callback when the file is deleted.

  final Function(String, String) onFileDelete;

  const FileListItem({
    super.key,
    required this.file,
    required this.currentPath,
    required this.isSelected,
    required this.onFileSelected,
    required this.onFileDownload,
    required this.onFileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define minimum width threshold for showing action buttons.

          const minWidthForButtons = 200;
          final showButtons = constraints.maxWidth >= minWidthForButtons;

          return InkWell(
            onTap: () => onFileSelected(file.name, currentPath),
            borderRadius: BorderRadius.circular(AppTheme.defaultBorderRadius),
            child: Container(
              // Apply selection highlighting using theme colours.
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1)
                        : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                  AppTheme.defaultBorderRadius,
                ),
              ),

              // Adjust horizontal padding based on available width.
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 50 ? 4 : 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show file icon only if width permits.
                  if (constraints.maxWidth > 40)
                    Icon(
                      Icons.insert_drive_file,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),

                  // Responsive spacing after icon.
                  if (constraints.maxWidth > 40)
                    SizedBox(width: constraints.maxWidth < 100 ? 4 : 12),

                  // File information column.
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File name with overflow protection.
                        Text(
                          file.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Show modification date if width permits.
                        if (constraints.maxWidth > 150)
                          Text(
                            'Modified: ${file.dateModified.toString().split('.')[0]}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Action buttons shown only if sufficient width.
                  if (showButtons) ...[
                    const SizedBox(width: 8),

                    // Preview button for PDF files.
                    if (file.name.toLowerCase().contains('.pdf.enc.ttl'))
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.preview,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          // Retrieve the PDF file content as a base64-encoded string.

                          final String fileContent = await readPod(
                            '$currentPath/${file.name}',
                            context,
                            Container(),
                          );

                          // Decode the base64 string into raw PDF bytes.

                          final pdfBytes = base64Decode(fileContent);

                          if (!context.mounted) return;

                          // Show the PDF preview dialog.

                          showDialog(
                            context: context,
                            builder:
                                (dialogContext) => AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).dialogBackgroundColor,
                                  title: Text(
                                    'File Preview',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 500,
                                    child: PdfPreview(
                                      build:
                                          (PdfPageFormat format) async =>
                                              pdfBytes,
                                      canChangeOrientation: false,
                                      canChangePageFormat: false,
                                      allowPrinting: false,
                                      allowSharing: false,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(dialogContext),
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(35, 35),
                        ),
                      ),
                    if (file.name.toLowerCase().contains('.pdf.enc.ttl'))
                      const SizedBox(width: 10),

                    // Download button.
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.download,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => onFileDownload(file.name, currentPath),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(35, 35),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Delete button.
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => onFileDelete(file.name, currentPath),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.1),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(35, 35),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
