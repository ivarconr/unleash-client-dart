import 'package:test/test.dart';
import 'package:unleash/src/toggle_backup/_io_toggle_backup.dart';
import 'package:unleash/src/unleash_settings.dart';

import 'test_utils.dart';

void main() {
  group('ToggleBackupRepositoryBackup ', () {
    test('happy path', () async {
      final backupRepository = IOToggleBackup(testSettings('backup.json'));

      await backupRepository.save(testFeatures);
      final backup = await backupRepository.load();

      expect(backup != null, true);
      expect(backup!.features!.length, 5);
      expect(backup.features![0].name, 'Demo');
    });
  });
}

UnleashSettings testSettings(String? path) => UnleashSettings(
      unleashApi: Uri.parse('https://unleash.herokuapp.com/api'),
      instanceId: 'instance',
      appName: 'appname',
      backupFilePath: path,
      apiToken: '',
    );
