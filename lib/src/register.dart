import 'package:unleash/src/version.dart' as version;

/// See https://unleash.github.io/docs/api/client/register
class Register {
  Register({
    required this.appName,
    required this.instanceId,
    this.strategies = const [],
    required this.started,
    this.interval,
  });

  /// Name of the application seen by unleash-server
  final String appName;

  /// Instance id for this application (typically hostname, podId or similar)
  final String instanceId;

  /// Optional field that describes the sdk version (name:version)
  final String sdkVersion = version.sdkVersion;

  ///  List of strategies implemented by this application
  final List<String> strategies;

  /// When this client started. Should be reported as
  /// [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) time.
  final DateTime started;

  /// At which interval, in milliseconds,
  /// will this client be expected to send metrics
  final int? interval;

  /// Converts this instance to a JSON object
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appName': appName,
      'instanceId': instanceId,
      'sdkVersion': sdkVersion,
      'strategies': strategies,
      'started': started.toIso8601String(),
      if (interval != null) 'interval': interval,
    };
  }
}
