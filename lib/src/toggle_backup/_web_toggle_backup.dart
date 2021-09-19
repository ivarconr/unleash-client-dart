import 'package:unleash/src/features.dart';
import 'package:unleash/src/toggle_backup/toggle_backup.dart';
import '../unleash_settings.dart';

ToggleBackup create(UnleashSettings settings) => NoOpToggleBackup();

class NoOpToggleBackup implements ToggleBackup {
  @override
  Future<Features?> load() async => null;

  @override
  Future<void> save(Features toggleJson) => Future.value();
}
