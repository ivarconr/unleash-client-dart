import 'package:test/test.dart';
import 'package:unleash/unleash.dart';

import 'test_utils.dart';

void main() {
  test('isEnabled return fake toggle correctly', () async {
    final unleash = await Unleash.init(
      UnleashSettings(
        apiToken: '123456789',
        appName: 'foo',
        instanceId: 'bar',
        unleashApi: Uri.parse('https://example.org/api'),
        fakeToggles: [
          FeatureToggle(name: 'fake-toggle-true', enabled: true),
          FeatureToggle(name: 'fake-toggle-false', enabled: false),
        ],
      ),
      client: NoOpUnleashClient(
        features: [
          FeatureToggle(
            name: 'featuristic',
            enabled: true,
            strategies: [],
          )
        ],
      ),
    );

    final statusTrue = unleash.isEnabled('fake-toggle-true');

    expect(statusTrue, true);

    final statusFalse = unleash.isEnabled('fake-toggle-false');

    expect(statusFalse, true);
  });
}
