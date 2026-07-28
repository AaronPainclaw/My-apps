@echo off
setlocal
cd /d "%~dp0"

set "OUT=Ordo-Hereticus-Archive-2.0.0-Windows-x64.zip"
set "EXPECTED=74d509f0da3caf2746ef25b7a38169c809deaedbcbb81740411d173e0bbeba7f"

if exist "%OUT%" del /q "%OUT%"

copy /b "Portable.parts\Ordo-Hereticus-Archive-2.0.0-Windows-x64.zip.001"+"Portable.parts\Ordo-Hereticus-Archive-2.0.0-Windows-x64.zip.002"+"Portable.parts\Ordo-Hereticus-Archive-2.0.0-Windows-x64.zip.003"+"Portable.parts\Ordo-Hereticus-Archive-2.0.0-Windows-x64.zip.004" "%OUT%" >nul
if errorlevel 1 (
  echo ERROR: Failed to assemble the archive.
  pause
  exit /b 1
)

for /f %%H in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '%OUT%').Hash.ToLower()"') do set "ACTUAL=%%H"

if /i not "%ACTUAL%"=="%EXPECTED%" (
  echo ERROR: SHA-256 mismatch.
  echo Expected: %EXPECTED%
  echo Actual:   %ACTUAL%
  del /q "%OUT%"
  pause
  exit /b 2
)

echo Archive assembled and verified:
echo %OUT%
echo SHA-256: %ACTUAL%
pause
