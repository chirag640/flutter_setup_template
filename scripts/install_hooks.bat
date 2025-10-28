@echo off
REM Install pre-commit hook for this repository (Windows)

set HOOK_PATH=.git\hooks\pre-commit
set SCRIPT_PATH=scripts\pre_commit_check.bat

if not exist "%SCRIPT_PATH%" (
    echo Error: %SCRIPT_PATH% not found!
    exit /b 1
)

REM Create the pre-commit hook
(
echo @echo off
echo call scripts\pre_commit_check.bat
) > "%HOOK_PATH%"

echo Pre-commit hook installed successfully!
echo The hook will run formatting, analysis, and tests before each commit.
echo.
echo To bypass the hook (not recommended), use: git commit --no-verify
