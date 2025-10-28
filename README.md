# Flutter Setup Template

[![CI - Build and Test](https://github.com/chirag640/flutter_setup_template/actions/workflows/ci.yml/badge.svg)](https://github.com/chirag640/flutter_setup_template/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/chirag640/flutter_setup_template/branch/main/graph/badge.svg)](https://codecov.io/gh/chirag640/flutter_setup_template)
[![Release Build](https://github.com/chirag640/flutter_setup_template/actions/workflows/release.yml/badge.svg)](https://github.com/chirag640/flutter_setup_template/actions/workflows/release.yml)
[![Flutter Version](https://img.shields.io/badge/flutter-3.35.7-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)

A production-ready Flutter app template with best practices, comprehensive testing, CI/CD pipelines, and multi-platform support. Use this as a starting point for your next Flutter project!

## ✨ Features

- 🎯 **Multi-platform support**: Android, iOS, Web, Windows, macOS, Linux
- 🧪 **Comprehensive testing**: Unit, widget, and integration tests with coverage reporting
- 🔄 **CI/CD pipelines**: Automated testing, building, and releases via GitHub Actions
- 🎨 **Strict linting**: Enhanced analysis rules for code quality and consistency
- 🌍 **Localization ready**: Pre-configured `l10n` support with ARB templates
- 📦 **Pre-commit hooks**: Automatic formatting and checks before commits
- 📚 **Well-documented**: Comprehensive guides for contributors
- 🚀 **Release automation**: Automated build and release for all platforms

## 🚀 Quick Start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.35.7 or later)
- Git
- IDE: [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/chirag640/flutter_setup_template.git
   cd flutter_setup_template
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify setup**

   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

4. **Run the app**

   ```bash
   # For Windows
   flutter run -d windows

   # For Web
   flutter run -d chrome

   # For Android (device/emulator must be connected)
   flutter run -d android

   # For iOS (macOS only, device/simulator must be connected)
   flutter run -d ios
   ```

## 📁 Project Structure

```
lib/
├── core/              # Core utilities, constants, themes, extensions
├── features/          # Feature modules (each self-contained)
├── widgets/           # Reusable widgets
├── l10n/              # Localization files (ARB format)
└── main.dart          # App entry point

test/
├── helpers/           # Test utilities and mocks
├── unit/              # Unit tests
├── widget/            # Widget tests
└── integration/       # Integration tests

scripts/               # Helper scripts (pre-commit, etc.)
.github/
├── workflows/         # CI/CD workflows
└── ISSUE_TEMPLATE/    # Issue and PR templates
```

## 🛠️ Development

### Code Quality

This project enforces strict code quality standards:

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Pre-commit Hooks (Recommended)

Install pre-commit hooks to automatically check code quality before commits:

**Windows:**

```cmd
scripts\install_hooks.bat
```

**Linux/macOS:**

```bash
chmod +x scripts/install_hooks.sh
./scripts/install_hooks.sh
```

This will automatically run formatting, analysis, and tests before each commit.

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific test file
flutter test test/unit/example_test.dart

# Integration tests
flutter test integration_test/
```

### Coverage

Coverage reports are automatically generated and uploaded to Codecov via CI. To view locally:

```bash
flutter test --coverage
# Then open coverage/lcov.info in your IDE
```

## 🏗️ Building

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS (macOS only)

```bash
# Debug
flutter build ios --debug --no-codesign

# Release (requires signing)
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🔄 CI/CD

This project includes two GitHub Actions workflows:

### CI Workflow (`ci.yml`)

Runs on every push and PR:

- ✅ Code formatting check
- ✅ Static analysis
- ✅ Unit and widget tests with coverage
- ✅ Build verification for Android, iOS, Web

### Release Workflow (`release.yml`)

Triggers on push to `main` or manually:

- 📦 Builds release artifacts for all platforms
- 🚀 Creates GitHub release with version from `pubspec.yaml`
- 📤 Uploads APK, AAB, IPA, and desktop builds

## 🌍 Localization

This project uses Flutter's built-in localization support:

1. Add ARB files in `lib/l10n/`
2. Run code generation:
   ```bash
   flutter gen-l10n
   ```
3. Use in code:
   ```dart
   Text(AppLocalizations.of(context)!.helloWorld)
   ```

## 📖 Documentation

- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Code of Conduct](CODE_OF_CONDUCT.md) - Community guidelines
- [Issue Templates](.github/ISSUE_TEMPLATE/) - Bug reports and feature requests
- [PR Template](.github/pull_request_template.md) - Pull request guidelines

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:

- Development workflow
- Code standards
- Testing requirements
- Pull request process

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and checks
5. Commit (`git commit -m 'feat: add amazing feature'`)
6. Push (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📋 Roadmap

See our [open issues](https://github.com/chirag640/flutter_setup_template/issues) for planned features and known issues.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors and maintainers
- Open source community

## 📧 Contact

- **Issues**: [GitHub Issues](https://github.com/chirag640/flutter_setup_template/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chirag640/flutter_setup_template/discussions)

---

**Made with ❤️ using Flutter**
