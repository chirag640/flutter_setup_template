@echo off
REM Pre-commit hook for Flutter projects (Windows)
REM This script runs before each commit to ensure code quality

echo Running pre-commit checks...

REM 1. Format code
echo Formatting code...
dart format .
if errorlevel 1 (
    echo Formatting failed!
    exit /b 1
)

REM 2. Analyze code (informational only, don't block commit)
echo Analyzing code...
flutter analyze
echo.

REM 3. Run tests
echo Running tests...
flutter test
if errorlevel 1 (
    echo Tests failed! Please fix the failing tests.
    exit /b 1
)

echo All pre-commit checks passed!
exit /b 0
