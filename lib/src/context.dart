class Context {
  Context({
    this.userId,
    this.sessionId,
    this.remoteAddress,
    this.properties,
  });

  final String? userId;
  final String? sessionId;
  final String? remoteAddress;
  final Map<String, String>? properties;

  Context copyWith({
    String? userId,
    String? sessionId,
    String? remoteAddress,
    Map<String, String>? properties,
  }) {
    return Context(
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      remoteAddress: remoteAddress ?? this.remoteAddress,
      properties: properties ?? this.properties,
    );
  }
}
