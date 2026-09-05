@echo off
setlocal
pushd "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 goto missing_flutter

echo Creating Android project files for SmartSpend...
call flutter create --platforms=android --android-language=java --project-name=smartspend_ui --no-pub .
if errorlevel 1 goto failed

echo Resolving Flutter dependencies...
call flutter pub get
if errorlevel 1 goto failed

echo.
echo Setup complete.
echo Open this whole folder in Android Studio, start an emulator, and run lib/main.dart.
echo Or open a terminal here and run: flutter run
echo Read START_HERE.md for the demo walkthrough.
popd
pause
exit /b 0

:missing_flutter
echo Flutter was not found in PATH.
echo Add your Flutter SDK bin folder to PATH and try again.
popd
pause
exit /b 1

:failed
echo.
echo Setup stopped. Keep the error shown above so it can be fixed.
popd
pause
exit /b 1
