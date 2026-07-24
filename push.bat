@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo.
echo  ============================================
echo   Lazyscript - GitHub Push
echo  ============================================
echo.

:: --- Step 0: Navigate to script's own directory ---
cd /d "%~dp0"
echo  [dir] %cd%
echo.

:: --- Step 1: Check git is available ---
where git >nul 2>&1
if errorlevel 1 (
    echo  [ERROR] git not found in PATH.
    echo  Install Git: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

:: --- Step 2: Check we are inside a git repo ---
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo  [ERROR] Not a git repository.
    echo  Run this script from inside the lazyscript folder.
    echo.
    pause
    exit /b 1
)

:: --- Step 2b: Install attribution stripper hook (no Cursor/Claude in commits) ---
if not exist "hooks\prepare-commit-msg" goto after_hook
if not exist ".git\hooks" mkdir ".git\hooks" >nul 2>&1
copy /Y "hooks\prepare-commit-msg" ".git\hooks\prepare-commit-msg" >nul
:after_hook

:: --- Step 3: Stage everything (respects .gitignore) ---
echo  [1/4] Staging files...
git add -A
echo       Done.
echo.

:: --- Step 4: Check if there is anything to commit ---
git diff --cached --quiet
if not errorlevel 1 (
    echo  [info] Nothing to commit - already up to date.
    echo.
    echo  ============================================
    echo   All good, nothing to push.
    echo  ============================================
    echo.
    pause
    exit /b 0
)

:: --- Step 5: Build commit message with timestamp ---
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set TODAY=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set NOW=%%a%%b
set MSG=Update lazyscript [%TODAY% %NOW%]

echo  [2/4] Committing...
echo       msg: !MSG!
git commit -m "!MSG!"
if errorlevel 1 (
    echo  [ERROR] Commit failed.
    echo.
    pause
    exit /b 1
)

:: Reject if Cursor/Claude trailers somehow remain
git log -1 --format=%%B | findstr /I /C:"Co-authored-by: Cursor" /C:"Co-authored-by: Claude" /C:"Made-with: Cursor" /C:"Made-with: Claude" >nul 2>&1
if not errorlevel 1 (
    echo  [ERROR] Commit still mentions Cursor/Claude. Aborting push.
    echo  Turn off: Cursor Settings - Agents - Attribution (Commit + PR)
    pause
    exit /b 1
)
echo       Done.
echo.

:: --- Step 6: Push ---
echo  [3/4] Pushing to origin...
git push origin
if errorlevel 1 (
    echo.
    echo  [ERROR] Push failed.
    echo  Possible causes:
    echo    - No internet connection
    echo    - Not authenticated (run: git credential-manager)
    echo    - Remote rejected (check branch name)
    echo.
    pause
    exit /b 1
)

:: --- Step 7: Done ---
echo.
echo  [4/4] Verifying...
git log --oneline -1
echo.
echo  ============================================
echo   Push successful!
echo  ============================================
echo.
pause
exit /b 0
