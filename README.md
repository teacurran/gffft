# gffft

steps to get started:

1. install flutter Sdk: https://docs.flutter.dev/get-started/install/macos
2. flutter run -d macos


## other stuff

## Json Serialization
* model classes are annotated with @JsonSerializable and toJson()/fromJson() stubbed out

to run the generation:
```
flutter pub run build_runner build
```

with a watcher:
```
flutter pub run build_runner watch
```
