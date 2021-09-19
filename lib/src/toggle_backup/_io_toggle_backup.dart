import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:unleash/src/features.dart';
import 'package:unleash/src/toggle_backup/toggle_backup.dart';
import 'package:unleash/unleash.dart';

ToggleBackup create(UnleashSettings settings) => IOToggleBackup(settings);

class IOToggleBackup implements ToggleBackup {
  IOToggleBackup(this._settings);

  final UnleashSettings _settings;

  @override
  Future<void> save(Features toggles) async {
    final path = _settings.backupFilePath;
    if (path == null) {
      return;
    }
    try {
      await File(path).writeAsString(json.encode(toggles.toJson()));
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
      final path = _settings.backupFilePath;
      if (path == null) {
        return null;
      }
      final backupFile = File(path);
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
