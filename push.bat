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

:: --- Step 3: Stage everything ---
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
set MSG=fix: hardcoded paths - replace /root/lscript with $LPATH [%TODAY% %NOW%]

echo  [2/4] Committing...
echo       msg: !MSG!
git commit -m "!MSG!"
if errorlevel 1 (
    echo  [ERROR] Commit failed.
    echo.
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
