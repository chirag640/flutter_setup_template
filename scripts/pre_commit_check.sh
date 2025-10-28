#!/bin/bash
# Pre-commit hook for Flutter projects
# This script runs before each commit to ensure code quality

set -e

echo "🔍 Running pre-commit checks..."

# 1. Format code
echo "📝 Formatting code..."
dart format .
if [ $? -ne 0 ]; then
  echo "❌ Formatting failed!"
  exit 1
fi

# 2. Analyze code (informational only, don't block commit)
echo "🔬 Analyzing code..."
flutter analyze || true
echo ""

# 3. Run tests
echo "🧪 Running tests..."
flutter test
if [ $? -ne 0 ]; then
  echo "❌ Tests failed! Please fix the failing tests."
  exit 1
fi

echo "✅ All pre-commit checks passed!"
exit 0
