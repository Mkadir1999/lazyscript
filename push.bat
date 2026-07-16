@echo off
echo ============================================
echo   Lazyscript - One-Click GitHub Push
echo ============================================
echo.

cd /d "%~dp0"

echo [1/3] Staging all changes...
git add -A

echo [2/3] Committing...
git commit -m "Fix hardcoded paths: replace /root/lscript with $LPATH in helper scripts (v2.2.8)"

echo [3/3] Pushing to origin...
git push origin

echo.
echo ============================================
echo   Done! Changes pushed to GitHub.
echo ============================================
pause
