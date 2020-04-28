import 'package:meta/meta.dart';

class UnleashSettings {
  UnleashSettings({
    @required this.appName,
    @required this.instanceTag,
    @required this.unleashApi,
    this.pollingInterval = const Duration(seconds: 15),
    this.metricsReportingInterval = const Duration(milliseconds: 10000),
  })  : assert(appName != null),
        assert(instanceTag != null),
        assert(unleashApi != null);

  final String appName;
  final String instanceTag;
  final Uri unleashApi;

  /// See https://unleash.github.io/docs/client_specification#fetching-feature-toggles-polling
  final Duration pollingInterval;

  final Duration metricsReportingInterval;

  Map<String, String> toHeaders() {
    return {
      'UNLEASH-APPNAME': appName,
      'UNLEASH-INSTANCEID': instanceTag,
    };
  }
}
