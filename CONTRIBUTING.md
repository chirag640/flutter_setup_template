# Contributing to Flutter Setup Template

Thank you for considering contributing to this project! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Pre-commit Hooks](#pre-commit-hooks)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and professional in all interactions.

## Getting Started

### Prerequisites

- Flutter SDK 3.35.7 or later
- Dart SDK (included with Flutter)
- Git

### Setup

1. Fork the repository
2. Clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter_setup_template.git
   cd flutter_setup_template
   ```

3. Add upstream remote:

   ```bash
   git remote add upstream https://github.com/chirag640/flutter_setup_template.git
   ```

4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Verify setup:
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

## Development Workflow

### 1. Create a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

Branch naming conventions:

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or fixes

### 2. Make Changes

- Write clean, readable code
- Follow the [Code Standards](#code-standards)
- Add tests for new features
- Update documentation as needed

### 3. Test Your Changes

Before committing, ensure:

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Build for your platform (optional)
flutter build apk --debug  # Android
flutter build ios --debug --no-codesign  # iOS
flutter build windows --debug  # Windows
```

### 4. Commit Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "feat: add user authentication feature"
```

Commit message format:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Test additions or fixes
- `chore:` - Build process or auxiliary tool changes

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Code Standards

### Dart/Flutter Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Follow linting rules in `analysis_options.yaml`
- Use single quotes for strings (enforced by linter)
- Prefer `const` constructors where possible
- Use meaningful variable and function names

### Code Organization

```
lib/
├── core/           # Core utilities, constants, themes
├── features/       # Feature modules (each self-contained)
├── widgets/        # Reusable widgets
├── l10n/           # Localization files
└── main.dart       # App entry point
```

### Best Practices

- **Immutability**: Prefer `final` and `const` where possible
- **Null Safety**: Use null-safe types correctly
- **Widget Size**: Keep widgets small and focused
- **State Management**: Use consistent state management patterns
- **Error Handling**: Use proper error handling and logging
- **Documentation**: Add doc comments for public APIs

### Example Code

```dart
/// A widget that displays a user profile card.
///
/// The [user] parameter must not be null.
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(user.name),
      ),
    );
  }
}
```

## Testing

### Test Categories

1. **Unit Tests** (`test/unit/`) - Test individual functions/classes
2. **Widget Tests** (`test/widget/`) - Test widget behavior
3. **Integration Tests** (`test/integration/`) - Test complete user flows

### Writing Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:setup/widgets/user_profile_card.dart';

void main() {
  group('UserProfileCard', () {
    testWidgets('displays user name', (tester) async {
      final user = User(name: 'John Doe', id: '123');

      await tester.pumpWidget(
        MaterialApp(
          home: UserProfileCard(user: user),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });
  });
}
```

### Coverage Goals

- Aim for >80% code coverage
- Critical paths should have 100% coverage
- Run coverage reports:
  ```bash
  flutter test --coverage
  # View coverage/lcov.info in your IDE or upload to Codecov
  ```

## Pull Request Process

### Before Submitting

- [ ] Code is formatted (`dart format .`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] All tests pass (`flutter test`)
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commits are clean and descriptive
- [ ] Branch is up to date with main

### PR Description Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

Describe how you tested your changes

## Screenshots (if applicable)

Add screenshots for UI changes

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
```

### Review Process

1. Automated checks run (CI/CD)
2. Code review by maintainers
3. Address feedback
4. Approval and merge

## Pre-commit Hooks

### Setup (Optional but Recommended)

Install pre-commit hooks to automatically format and check code:

#### Option 1: Manual Setup

Create `.git/hooks/pre-commit`:

```bash
#!/bin/sh
echo "Running pre-commit checks..."

# Format code
echo "Formatting code..."
dart format .

# Analyze code
echo "Analyzing code..."
flutter analyze --fatal-infos

# Run tests
echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "Pre-commit checks failed. Please fix errors and try again."
  exit 1
fi

echo "Pre-commit checks passed!"
```

Make it executable:

```bash
chmod +x .git/hooks/pre-commit
```

#### Option 2: Using Melos (for monorepos)

If using Melos:

```bash
dart pub global activate melos
melos bootstrap
melos run analyze
melos run test
```

### Quick Pre-commit Check Script

Create `scripts/pre_commit_check.sh` (or `.bat` for Windows):

```bash
#!/bin/bash
dart format . && flutter analyze --fatal-infos && flutter test
```

Windows version (`scripts/pre_commit_check.bat`):

```batch
@echo off
dart format . && flutter analyze --fatal-infos && flutter test
```

## Questions or Need Help?

- **Issues**: Open an issue for bug reports or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact maintainers for sensitive issues

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
