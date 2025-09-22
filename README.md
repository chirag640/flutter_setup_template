# setup

A new Flutter project.
# setup (Template)

A lightweight Flutter app template intended as a starting point for new apps. It includes platform folders (android, ios, web, macos, windows, linux), a small example app entry in `lib/main.dart`, and optional localization scaffolding.

## Quick start

Prerequisites: Flutter SDK installed and available on PATH. Verify with `flutter --version`.

From Windows cmd (project root):

```cmd
cd D:\Projects\FlutterProjects\my\setup
flutter pub get
flutter run -d windows
```

Replace `-d windows` with `-d chrome`, `-d android`, `-d ios`, or another device id as appropriate.

## Scaffold a new app from this template (Quick)

If you want to use this repository as a template for a new app, follow these quick steps:

1. Clone or copy this folder to a new location and rename the root directory to your app id (for example `my_app`).

2. Update package name / bundle id:
	- Android: edit `android/app/src/main/AndroidManifest.xml` and `android/app/build.gradle.kts` as needed.
	- iOS/macOS: update the bundle identifier in Xcode for `ios/Runner` and `macos/Runner`.

3. Update `pubspec.yaml`:
	- Change the `name:` field to your package name (lowercase_with_underscores).
	- Update `description` and `version`.

4. Replace the example app code in `lib/main.dart` with your own app logic.

5. Regenerate platform-specific files if you change the application id/package name. For Android package renames consider moving/renaming the Kotlin/Java package folders and updating Gradle settings.

6. Run `flutter pub get` and test on each target platform you support:

```cmd
flutter clean
flutter pub get
flutter run
```

## Recommended repository files

This template includes basic tooling files to make development and CI simpler. If you don't see them in your derived project they should be added:

- `.gitignore` – standard Flutter/Dart ignore rules (generated below).
- `.gitattributes` – normalize line endings and mark binary files.
- `.github/workflows/flutter_ci.yml` – example GitHub Actions workflow to run `flutter analyze` and `flutter test`.

## Project structure (short)

- `lib/` — Dart source, app entry at `lib/main.dart`.
- `android/`, `ios/`, `macos/`, `windows/`, `linux/`, `web/` — platform-specific folders.
- `pubspec.yaml` — dependencies and asset configuration.

## Notes

- When scaffolding a new app from this template, carefully update package identifiers and Firebase/third-party keys before publishing.
- This repo contains optional localization scaffolding in `lib/l10n/` if you plan to use `flutter gen-l10n`.

---

If you'd like, I can now add the recommended `.gitignore`, `.gitattributes`, and a CI workflow file into the repository. Tell me if you'd like the GitHub Actions workflow to run on Linux, Windows, macOS, or all three.
