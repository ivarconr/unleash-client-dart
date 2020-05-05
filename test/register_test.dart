import 'package:test/test.dart';
import 'package:unleash/register.dart';

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
      'sdkVersion': 'unleash-client-dart:0.0.2',
      'interval': 20,
      'instanceId': 'instanceid',
      'appName': 'appname',
      'strategies': ['strategy1']
    });
  });
}
