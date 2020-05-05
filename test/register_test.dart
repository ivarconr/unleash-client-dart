import 'package:test/test.dart';
import 'package:unleash/register.dart';

void main() {
  test('Register.toJson', () {
    final register = Register(
        started: 'time',
        sdkVersion: 'version',
        interval: 20,
        instanceId: 'instanceid',
        appName: 'appname',
        strategies: ['strategy1']);

    expect(register.toJson(), <String, dynamic>{
      'started': 'time',
      'sdkVersion': 'version',
      'interval': 20,
      'instanceId': 'instanceid',
      'appName': 'appname',
      'strategies': ['strategy1']
    });
  });
}
