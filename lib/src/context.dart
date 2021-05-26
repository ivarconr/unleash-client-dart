class UnleashContext {
  UnleashContext(
      {this.appName,
      this.environment,
      this.userId,
      this.sessionId,
      this.remoteAddress,
      this.properties});

  final String? appName;
  final String? environment;
  final String? userId;
  final String? sessionId;
  final String? remoteAddress;
  final Map<String, String>? properties;

  String? getByName(String contextName) {
    switch (contextName) {
      case 'appName':
        return appName;
      case 'environment':
        return environment;
      case 'userId':
        return userId;
      case 'sessionId':
        return sessionId;
      case 'remoteAddress':
        return remoteAddress;
      default:
        return properties?[contextName];
    }
  }
}
