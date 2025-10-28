#!/bin/bash
# Install pre-commit hook for this repository

HOOK_PATH=".git/hooks/pre-commit"
SCRIPT_PATH="scripts/pre_commit_check.sh"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH not found!"
    exit 1
fi

# Make the check script executable
chmod +x "$SCRIPT_PATH"

# Create the pre-commit hook
cat > "$HOOK_PATH" << 'EOF'
#!/bin/bash
./scripts/pre_commit_check.sh
EOF

# Make the hook executable
chmod +x "$HOOK_PATH"

echo "✅ Pre-commit hook installed successfully!"
echo "The hook will run formatting, analysis, and tests before each commit."
echo ""
echo "To bypass the hook (not recommended), use: git commit --no-verify"
