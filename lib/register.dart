/// See https://unleash.github.io/docs/api/client/register
class Register {
  Register({
    this.appName,
    this.instanceId,
    this.strategies,
    this.started,
    this.interval,
  });

  /// Name of the application seen by unleash-server
  final String appName;

  /// Instance id for this application (typically hostname, podId or similar)
  final String instanceId;

  /// Optional field that describes the sdk version (name:version)
  final String sdkVersion = 'unleash-client-dart:0.0.3';

  ///  List of strategies implemented by this application
  final List<String> strategies;

  /// When this client started. Should be reported as [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) time.
  final String started;

  /// At which interval, in milliseconds,
  /// will this client be expected to send metrics
  final int interval;

  /// Converts this instance to a JSON object
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['appName'] = appName;
    data['instanceId'] = instanceId;
    data['sdkVersion'] = sdkVersion;
    data['strategies'] = strategies;
    data['started'] = started;
    data['interval'] = interval;
    return data;
  }
}
