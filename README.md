<p align="center">
  <img src="img/unleash.png" max-height="80" alt="Unleash" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/unleash"><img src="https://img.shields.io/pub/v/unleash.svg" alt="pub.dev"></a>
  <img src="https://github.com/ueman/unleash/workflows/unleash/badge.svg?branch=master" alt="GitHub Workflow Status">
  <a href="https://codecov.io/gh/ueman/unleash"><img src="https://codecov.io/gh/ueman/unleash/branch/master/graph/badge.svg" alt="Code Coverage"></a>
  <a href="https://github.com/ueman#sponsor-me"><img src="https://img.shields.io/github/sponsors/ueman" alt="Sponsoring"></a>
  <!-- 
  <a href="https://pub.dev/packages/unleash/score"><img src="https://badges.bar/unleash/likes" alt="likes"></a>
  <a href="https://pub.dev/packages/unleash/score"><img src="https://badges.bar/unleash/popularity" alt="popularity"></a>
  <a href="https://pub.dev/packages/unleash/score"><img src="https://badges.bar/unleash/pub%20points" alt="pub points"></a>
  -->
</p>

# Unleash Client SDK for Dart and Flutter

This is an unofficial Unleash Client SDK for Dart. It is compatible with the [Unleash-hosted.com SaaS](https://www.unleash-hosted.com/) offering and [Unleash Open-Source](https://github.com/unleash/unleash).
It also works with [GitLab Feature Flags](https://docs.gitlab.com/ee/user/project/operations/feature_flags.html).

## Getting started
First, you will need to add `unleash` to your `pubspec.yaml`:

```yaml
dependencies:
  unleash: x.y.z 
  # use the latest version found on pub.dev
```

Then, run `flutter packages get` in your terminal.

### Create a new Unleash instance

It is easy to get a new instance of Unleash. In your app you typically *just want one instance of Unleash*, and inject that where you need it. 

To create a new instance of Unleash you need to pass in a config object:
```dart
import 'package:unleash/unleash.dart';

Future<void> main() async {
  final unleash = await Unleash.init(
    UnleashSettings(
      appName: '<appname>',
      instanceId: '<instanceid>',
      unleashApi: Uri.parse('<api_url>'),
    ),
  );
  print(unleash.isEnabled('Awesome Feature'));
}
```

### Awesome feature toggle API

It is really simple to use unleash.

```dart
if(unleash.isEnabled("AwesomeFeature")) {
  //do some magic
} else {
  //do old boring stuff
}
```

Calling `unleash.isEnabled("AwesomeFeature")` is the equivalent of calling `unleash.isEnabled("AwesomeFeature", defaultValue: false)`. 
Which means that it will return `false` if it cannot find the named toggle. 

If you want it to default to `true` instead, you can pass `true` as the second argument:

```dart
unleash.isEnabled("AwesomeFeature", defaultValue: true);
```

## Current state of development
This client SDK supports version 3 of the API.

This SDK currently does not support any strategies, metrics reporting or anything else.
It just gets the feature toggels yet.

## Author

- Jonas Uekötter [GitHub](https://github.com/ueman) [Twitter](https://twitter.com/ue_man)

## Sponsoring
I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to [sponsor](https://github.com/ueman#sponsor-me) me. By doing so, I will prioritize your issues or your pull-requests before the others.
