import 'package:test/test.dart';
import 'package:unleash/src/register.dart';
import 'package:unleash/src/version.dart';

void main() {
  test('Register.toJson', () {
    final register = Register(
      started: 'time',
      interval: 20,
      instanceId: 'instanceid',
      appName: 'appname',
      strategies: ['strategy1'],
    );

    expect(register.toJson(), <String, dynamic>{
      'started': 'time',
      'sdkVersion': sdkVersion,
      'interval': 20,
      'instanceId': 'instanceid',
      'appName': 'appname',
      'strategies': ['strategy1']
    });
  });
}
