import 'dart:io';

import 'package:test/test.dart';
import 'package:unleash/src/toggle_backup/_io_toggle_backup.dart';

import 'test_utils.dart';

void main() {
  String path = 'backup.json';
  group('ToggleBackupRepositoryBackup ', () {
    tearDown(() {
      var backupFile = File(path);
      if (backupFile.existsSync()) {
        backupFile.deleteSync();
      }
    });

    test('happy path', () async {
      final backupRepository = IOToggleBackup(path);

      await backupRepository.save(testFeatures);
      final backup = await backupRepository.load();

      expect(backup != null, true);
      expect(backup!.features!.length, 6);
      expect(backup.features![0].name, 'Demo');
    });
  });
}
