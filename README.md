[![Pub](https://img.shields.io/pub/v/unleash.svg)](https://pub.dartlang.org/packages/unleash)
![GitHub Workflow Status](https://github.com/ueman/unleash/workflows/dart/badge.svg?branch=master)
[![Code Coverage](https://codecov.io/gh/ueman/unleash/branch/master/graph/badge.svg)](https://codecov.io/gh/ueman/unleash)

# Unleash Client SDK for Dart and Flutter
This is the Unleash Client SDK for Dart. It is compatible with the [Unleash-hosted.com SaaS](https://www.unleash-hosted.com/) offering and [Unleash Open-Source](https://github.com/unleash/unleash).
It also works with [GitLab Feature Flags](https://docs.gitlab.com/ee/user/project/operations/feature_flags.html).

## Getting started
First, you will need to add `unleash` to your `pubspec.yaml`:

```yaml
dependencies:
  unleash: 0.0.1 # use the latest version found on pub.dev
```

Then, run `flutter packages get` in your terminal.

### Create a new Unleash instance

It is easy to get a new instance of Unleash. In your app you typically *just want one instance of Unleash*, and inject that where you need it. 

To create a new instance of Unleash you need to pass in a config object:
```dart
import 'package:unleash/unleashdart.dart';

Future<void> main() async {
  await Unleash.init(
    UnleashSettings(
      appName: '<your_app_name_here>',
      instanceId: '<your_instanceId_here>',
      unleashApi:
          Uri.parse('https://example.org/api'),
    ),
  );
  print(Unleash.isEnabled('AwesomeFeature'));
}

```

### Awesome feature toggle API

It is really simple to use unleash.

```dart
if(Unleash.isEnabled("AwesomeFeature")) {
  //do some magic
} else {
  //do old boring stuff
}
```

Calling `Unleash.isEnabled("AwesomeFeature")` is the equivalent of calling `Unleash.isEnabled("AwesomeFeature", false)`. 
Which means that it will return `false` if it cannot find the named toggle. 

If you want it to default to `true` instead, you can pass `true` as the second argument:

```dart
Unleash.isEnabled("AwesomeFeature", {defaultValue: true});
```

## Current state of development

This SDK currently does not support any strategies, metrics reporting or anything else.
It just gets the feature toggels yet.
