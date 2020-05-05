import 'package:test/test.dart';
import 'package:unleash/features.dart';

void main() {
  test('Features.fromJson', () {
    final features = Features.fromJson(<String, dynamic>{
      'version': 1,
      'features': [
        <String, dynamic>{
          'name': 'example-feature',
          'description': 'example description',
          'enabled': false,
          'strategy': 'example-strategy',
          'strategies': [
            <String, dynamic>{
              'name': 'example-strategy',
              'parameters': <String, String>{'example': 'example'}
            },
          ],
        }
      ],
    });

    // Features
    expect(features.version, 1);
    expect(features.features.length, 1);

    // FeatureToggle
    final feature = features.features[0];
    expect(feature.name, 'example-feature');
    expect(feature.description, 'example description');
    expect(feature.enabled, false);
    expect(feature.strategy, 'example-strategy');
    expect(feature.strategies.length, 1);

    // Strategy
    final strategy = feature.strategies[0];
    expect(strategy.name, 'example-strategy');
    expect(strategy.parameters.length, 1);
    expect(strategy.parameters['example'], 'example');
  });
}
