# EduLearn Flutter

Flutter implementation of the EduLearn course catalog. The original Kotlin/Compose application remains in the parent folder.

## Run

Install Flutter 3.50.1 or newer and make sure `flutter/bin` is on `PATH`. The Android platform scaffold is included. From this folder, run:

```sh
flutter pub get
flutter test
flutter run
```

Alternatively, open this `flutter_app` folder in Android Studio, select an Android emulator or connected device, and run the `main.dart` configuration.

The home dashboard and course overview load asynchronously from the lab REST API through `HttpLearningContentRepository`. The catalog loads the course from `/feed/details` through `HttpCourseRepository`. Repository contracts and use cases live in `domain`; HTTP and JSON mapping live in `data`; Cubits and widgets live in `features` and `widgets`. Internet access is required for both API data and remote media.