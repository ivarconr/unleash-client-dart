import 'package:unleash/src/features.dart';
import '_io_toggle_backup.dart' if (dart.library.html) '_web_toggle_backup.dart'
    as toggle_backup;

abstract class ToggleBackup {
  factory ToggleBackup(
    /// The path where Unleash stores it's backup.
    /// On web this does nothing. It's only used on dart:io platforms.
    /// Setting [backupFilePath] to null disables the backup.
    String backupFilePath,
  ) {
    return toggle_backup.create(backupFilePath);
  }

  Future<void> save(Features toggleJson);
  Future<Features?> load();
}
