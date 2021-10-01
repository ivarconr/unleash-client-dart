import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:unleash/src/features.dart';
import 'package:unleash/src/toggle_backup/toggle_backup.dart';

ToggleBackup create(String backupFilePath) {
  assert(
    backupFilePath.trim().isNotEmpty,
    'backupPath must be null or not empty',
  );
  return IOToggleBackup(backupFilePath);
}

class IOToggleBackup implements ToggleBackup {
  IOToggleBackup(this.backupFilePath);

  final String backupFilePath;

  @override
  Future<void> save(Features toggles) async {
    try {
      await File(backupFilePath).writeAsString(json.encode(toggles.toJson()));
    } catch (e, stacktrace) {
      log(
        'An exception occured during saving toggles to disk',
        stackTrace: stacktrace,
        error: e,
        name: 'unleash',
      );
    }
  }

  @override
  Future<Features?> load() async {
    try {
      final backupFile = File(backupFilePath);
      if (await backupFile.exists()) {
        final jsonString = await backupFile.readAsString();
        return Features.fromJson(
          json.decode(jsonString) as Map<String, dynamic>,
        );
      }
    } catch (e, stacktrace) {
      log(
        'An exception occured during saving toggles to disk',
        stackTrace: stacktrace,
        error: e,
        name: 'unleash',
      );
    }
    return null;
  }
}
