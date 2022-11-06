import 'package:path/path.dart';
import 'package:unleash/unleash.dart';

class UnleashSettings {
  const UnleashSettings({
    required this.appName,
    required this.instanceId,
    required this.unleashApi,
    required this.apiToken,
    this.customHeaders = const {},
    this.pollingInterval = const Duration(seconds: 15),
    this.metricsReportingInterval = const Duration(milliseconds: 10000),
    this.fakeToggles = const [],
    this.strategies = const [],
  });

  /// Name of the application seen by unleash-server.
  ///
  /// Also used by GitLab to evaluate the environment.
  /// See https://docs.gitlab.com/ee/user/project/operations/feature_flags.html#configuring-feature-flags
  final String appName;

  /// Instance id for this application (typically hostname, podId or similar)
  final String instanceId;

  /// See https://docs.getunleash.io/user_guide/api-token
  final String apiToken;

  /// Should be for example Uri.parse('https://unleash.herokuapp.com/api')
  /// or if used with GitLab Uri.parse('https://gitlab.com/api/v4/feature_flags/unleash/42')
  final Uri unleashApi;

  /// List of custom activation strategies
  final List<ActivationStrategy>? strategies;

  /// See https://unleash.github.io/docs/client_specification#fetching-feature-toggles-polling
  /// Polling is disabled if this is null.
  final Duration? pollingInterval;

  /// Currently unused.
  /// At which interval, in milliseconds,
  /// will this client be expected to send metrics.
  /// Metric reporing is disabled if null.
  final Duration? metricsReportingInterval;

  /// List of fake features
  final List<FeatureToggle>? fakeToggles;

  /// Additional http headers to add for each HTTP request towards the Unleash API
  final Map<String, String> customHeaders;

  Map<String, String> toHeaders() {
    return {
      'UNLEASH-APPNAME': appName,
      'UNLEASH-INSTANCEID': instanceId,
      'Authorization': apiToken,
      ...customHeaders
    };
  }

  /// URL to register this client
  Uri get registerUrl => Uri.parse(
        join(unleashApi.toString(), 'client/register'),
      );

  /// URL to send GET requests to load toggles
  Uri get featureUrl => Uri.parse(
        join(unleashApi.toString(), 'client/features'),
      );
}
