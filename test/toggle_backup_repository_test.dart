import 'package:test/test.dart';
import 'package:unleash/src/toggle_backup.dart';
import 'package:unleash/src/unleash_settings.dart';

import 'test_utils.dart';

void main() {
  group('ToggleBackupRepositoryBackup ', () {
    test('test assertions', () async {
      Future<void> write(UnleashSettings settings, String json) {
        return Future.value();
      }

      Future<String> read(UnleashSettings settings) {
        return Future.value(testFeatureToggleJson);
      }

      expect(() {
        ToggleBackupRepository(null, write);
      }, throwsAssertionError);
      expect(() {
        ToggleBackupRepository(read, null);
      }, throwsAssertionError);

      expect(() {
        ToggleBackupRepository(null, null);
      }, throwsAssertionError);
    });

    test('happy path', () async {
      Future<void> write(UnleashSettings settings, String json) {
        expect(settings, testSettings);
        expect(json, testFeatureToggleJson);
        // pretend everything is saved gracefully
        return Future.value();
      }

      Future<String> read(UnleashSettings settings) {
        expect(settings, testSettings);
        return Future.value(testFeatureToggleJson);
      }

      final backupRepository = ToggleBackupRepository(read, write);
      await backupRepository.save(testSettings, testFeatureToggleJson);
      final backup = await backupRepository.load(testSettings);

      expect(backup != null, true);
      expect(backup.features.length, 3);
      expect(backup.features[0].name, 'Demo');
    });

    test('unsuccessful saving', () async {
      Future<void> write(UnleashSettings settings, String json) {
        throw Exception();
      }

      Future<String> read(UnleashSettings settings) {
        expect(settings, testSettings);
        return Future.value(testFeatureToggleJson);
      }

      var exceptionThrown = false;
      final backupRepository = ToggleBackupRepository(read, write);
      try {
        await backupRepository.save(testSettings, testFeatureToggleJson);
      } catch (e) {
        exceptionThrown = true;
      }

      expect(exceptionThrown, false);
    });
  });
}

final testSettings = UnleashSettings(
  unleashApi: Uri.parse('https://unleash.herokuapp.com/api'),
  instanceId: 'instance',
  appName: 'appname',
);
