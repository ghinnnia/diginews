@echo off
REM Jalankan file ini SETIAP KALI Anda extract ulang / clone ulang project ini,
REM SEBELUM menjalankan flutter analyze / flutter test / flutter run.
REM Ini menggantikan 2 langkah manual: flutter pub get + build_runner.

echo === [1/2] flutter pub get ===
call flutter pub get
if %errorlevel% neq 0 (
    echo GAGAL di flutter pub get, hentikan.
    exit /b %errorlevel%
)

echo === [2/2] Generate kode Isar (build_runner) ===
call dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo GAGAL di build_runner, hentikan.
    exit /b %errorlevel%
)

echo.
echo === SELESAI. Sekarang aman menjalankan flutter analyze / flutter test / flutter run ===
