/// See https://unleash.github.io/docs/api/client/metrics
class Metrics {
  Metrics({this.appName, this.instanceId, this.bucket});

  final String? appName;
  final String? instanceId;
  final Bucket? bucket;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['appName'] = appName;
    data['instanceId'] = instanceId;
    if (bucket != null) {
      data['bucket'] = bucket!.toJson();
    }
    return data;
  }
}

class Bucket {
  Bucket({this.start, this.stop, this.toggles});

  final String? start;
  final String? stop;
  final Map<String, Toggle>? toggles;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['start'] = start;
    data['stop'] = stop;
    if (toggles != null) {
      final t = <String, dynamic>{};
      for (final toggle in toggles!.entries) {
        t[toggle.key] = toggle.value.toJson();
      }
      data['toggles'] = t;
    }
    return data;
  }
}

class Toggle {
  Toggle({this.yes, this.no});

  final int? yes;
  final int? no;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['yes'] = yes;
    data['no'] = no;
    return data;
  }
}
