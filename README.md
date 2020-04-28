# Unleash Client SDK for Dart and Flutter
This is the Unleash Client SDK for Dart. It is compatible with the [Unlesah-hosted.com SaaS](https://www.unleash-hosted.com/) offering and [Unleash Open-Source](https://github.com/unleash/unleash).
Probably also with the [GitLab Feature Flags](https://docs.gitlab.com/ee/user/project/operations/feature_flags.html)

[![Pub](https://img.shields.io/pub/v/unleash.svg)](https://pub.dartlang.org/packages/unleash)
![GitHub Workflow Status](https://github.com/ueman/unleash/workflows/dart/badge.svg?branch=master)
[![Code Coverage](https://codecov.io/gh/ueman/unleash/branch/master/graph/badge.svg)](https://codecov.io/gh/ueman/unleash)


## Getting started
First, you will need to add `feedback` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  feedback: 0.2.1 # use the latest version found on pub.dev
```

Then, run `flutter packages get` in your terminal.


### Create a new Unleash instance

It is easy to get a new instance of Unleash. In your app you typically *just want one instance of Unleash*, and inject that where you need it. 

To create a new instance of Unleash you need to pass in a config object:
```dart

// TODO code example
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

Calling `unleash.isEnabled("AwesomeFeature")` is the equvivalent of calling `unleash.isEnabled("AwesomeFeature", false)`. 
Which means that it will return `false` if it cannot find the named toggle. 

If you want it to default to `true` instead, you can pass `true` as the second argument:

```dart
Unleash.isEnabled("AwesomeFeature", true)
```

## Local backup