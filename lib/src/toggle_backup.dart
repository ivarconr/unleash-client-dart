import 'dart:convert';
import 'dart:developer';

import 'package:unleash/src/features.dart';
import 'package:unleash/src/unleash_settings.dart';

/// Should return the backuped feature toggles for the given [UnleashSettings]
typedef ReadBackup = Future<String> Function(UnleashSettings settings);

/// Should persist [toggles] to disk. [settings] can be used to create a unique
/// key for the backup
typedef WriteBackup = Future<void> Function(
  UnleashSettings settings,
  String toggles,
);

/// Used to save and load feature toggle backups. Provides exception
/// handling around [ReadBackup] and [WriteBackup].
class ToggleBackupRepository {
  ToggleBackupRepository(this.read, this.write)
      : assert(read != null),
        assert(write != null);

  final ReadBackup read;
  final WriteBackup write;

  Future<void> save(UnleashSettings settings, String toggles) async {
    if (toggles == null) {
      return;
    }
    if (toggles.isEmpty) {
      return;
    }
    try {
      await write(settings, toggles);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Features> load(UnleashSettings settings) async {
    try {
      final jsonString = await read(settings);
      return Features.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
