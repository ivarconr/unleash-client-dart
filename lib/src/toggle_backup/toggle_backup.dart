import 'package:unleash/src/features.dart';
import 'package:unleash/unleash.dart';
import '_io_toggle_backup.dart' if (dart.library.html) '_web_toggle_backup.dart'
    as toggle_backup;

abstract class ToggleBackup {
  factory ToggleBackup(UnleashSettings settings) {
    return toggle_backup.create(settings);
  }

  Future<void> save(Features toggleJson);
  Future<Features?> load();
}
