/// File state model for the file service.
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

import 'package:moviestar/constants/paths.dart';

/// A model class to manage the state of file operations in the file service.
///
/// This class encapsulates all the state variables that were previously scattered
/// throughout the FileService widget, providing a more organized and maintainable
/// way to manage file operation states.

class FileState {
  /// The currently selected file for upload.

  String? uploadFile;

  /// The currently selected file for download.

  String? downloadFile;

  /// The name of the file on the remote server.

  String? remoteFileName;

  /// The clean name of the file (without encryption extension).

  String? cleanFileName;

  /// The URL of the remote file.

  String? remoteFileUrl;

  /// The preview content of the selected file.

  String? filePreview;

  /// The current directory path.

  String? currentPath;

  /// Operation status flags.

  bool uploadInProgress = false;
  bool downloadInProgress = false;
  bool deleteInProgress = false;
  bool importInProgress = false;
  bool exportInProgress = false;
  bool uploadDone = false;
  bool downloadDone = false;
  bool deleteDone = false;
  bool showPreview = false;

  /// Creates a new [FileState] with default values.

  FileState({
    this.uploadFile,
    this.downloadFile,
    this.remoteFileName = 'remoteFileName',
    this.cleanFileName = 'remoteFileName',
    this.remoteFileUrl,
    this.filePreview,
    this.currentPath = basePath,
    this.uploadInProgress = false,
    this.downloadInProgress = false,
    this.deleteInProgress = false,
    this.importInProgress = false,
    this.exportInProgress = false,
    this.uploadDone = false,
    this.downloadDone = false,
    this.deleteDone = false,
    this.showPreview = false,
  });

  /// Creates a copy of this [FileState] with the given fields replaced with new values.

  FileState copyWith({
    String? uploadFile,
    String? downloadFile,
    String? remoteFileName,
    String? cleanFileName,
    String? remoteFileUrl,
    String? filePreview,
    String? currentPath,
    bool? uploadInProgress,
    bool? downloadInProgress,
    bool? deleteInProgress,
    bool? importInProgress,
    bool? exportInProgress,
    bool? uploadDone,
    bool? downloadDone,
    bool? deleteDone,
    bool? showPreview,
  }) {
    return FileState(
      uploadFile: uploadFile ?? this.uploadFile,
      downloadFile: downloadFile ?? this.downloadFile,
      remoteFileName: remoteFileName ?? this.remoteFileName,
      cleanFileName: cleanFileName ?? this.cleanFileName,
      remoteFileUrl: remoteFileUrl ?? this.remoteFileUrl,
      filePreview: filePreview ?? this.filePreview,
      currentPath: currentPath ?? this.currentPath,
      uploadInProgress: uploadInProgress ?? this.uploadInProgress,
      downloadInProgress: downloadInProgress ?? this.downloadInProgress,
      deleteInProgress: deleteInProgress ?? this.deleteInProgress,
      importInProgress: importInProgress ?? this.importInProgress,
      exportInProgress: exportInProgress ?? this.exportInProgress,
      uploadDone: uploadDone ?? this.uploadDone,
      downloadDone: downloadDone ?? this.downloadDone,
      deleteDone: deleteDone ?? this.deleteDone,
      showPreview: showPreview ?? this.showPreview,
    );
  }

  /// Checks if the current path is in the blood pressure directory.

  bool get isInBpDirectory {
    return currentPath != null &&
        (currentPath!.endsWith('/blood_pressure') ||
            currentPath!.contains('/blood_pressure/') ||
            currentPath == '$basePath/blood_pressure');
  }

  /// Checks if the current path is in the vaccination directory.

  bool get isInVaccinationDirectory {
    return currentPath != null &&
        (currentPath!.endsWith('/vaccination') ||
            currentPath!.contains('/vaccination/') ||
            currentPath == '$basePath/vaccination');
  }

  /// Checks if the current path is in the profile directory.

  bool get isInProfileDirectory {
    return currentPath != null &&
        (currentPath!.endsWith('/profile') ||
            currentPath!.contains('/profile/') ||
            currentPath == '$basePath/profile' ||
            currentPath == basePath);
  }
}
