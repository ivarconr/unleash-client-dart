import 'package:meta/meta.dart';
import 'package:path/path.dart';

class UnleashSettings {
  const UnleashSettings({
    @required this.appName,
    @required this.instanceId,
    @required this.unleashApi,
    this.pollingInterval = const Duration(seconds: 15),
    this.metricsReportingInterval = const Duration(milliseconds: 10000),
  })  : assert(appName != null),
        assert(instanceId != null),
        assert(unleashApi != null);

  /// Name of the application seen by unleash-server.
  ///
  /// Also used by GitLab to evaluate the environment.
  /// See https://docs.gitlab.com/ee/user/project/operations/feature_flags.html#configuring-feature-flags
  final String appName;

  /// Instance id for this application (typically hostname, podId or similar)
  final String instanceId;

  /// Should be for example Uri.parse('https://unleash.herokuapp.com/api')
  /// or if used with GitLab Uri.parse('https://gitlab.com/api/v4/feature_flags/unleash/42')
  final Uri unleashApi;

  /// See https://unleash.github.io/docs/client_specification#fetching-feature-toggles-polling
  /// Polling is disabled if this is null.
  final Duration pollingInterval;

  /// Currently unused.
  /// At which interval, in milliseconds,
  /// will this client be expected to send metrics
  final Duration metricsReportingInterval;

  Map<String, String> toHeaders() {
    return {
      'UNLEASH-APPNAME': appName,
      'UNLEASH-INSTANCEID': instanceId,
    };
  }

  /// URL to register this client
  String get registerUrl => join(unleashApi.toString(), 'client/register');

  /// URL to send GET requests to load toggles
  String get featureUrl => join(unleashApi.toString(), 'client/features');
}
