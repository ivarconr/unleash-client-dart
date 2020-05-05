import 'package:test/test.dart';
import 'package:unleash/features.dart';

void main() {
  test('Strategies.fromJson', () {
    final strategy = Strategy.fromJson(<String, dynamic>{
      'name': 'example-strategy',
      'parameters': <String, String>{'example': 'example'}
    });

    expect(strategy.name, 'example-strategy');
    expect(strategy.parameters.length, 1);
    expect(strategy.parameters['example'], 'example');
  });

  test('Feature.fromJson', () {}, skip: true);

  test('Features.fromJson', () {}, skip: true);
}
