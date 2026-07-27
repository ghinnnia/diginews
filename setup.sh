#!/usr/bin/env bash
# Jalankan file ini SETIAP KALI Anda extract ulang / clone ulang project ini,
# SEBELUM menjalankan flutter analyze / flutter test / flutter run.
set -e

echo "=== [1/2] flutter pub get ==="
flutter pub get

echo "=== [2/2] Generate kode Isar (build_runner) ==="
dart run build_runner build --delete-conflicting-outputs

echo ""
echo "=== SELESAI. Sekarang aman menjalankan flutter analyze / flutter test / flutter run ==="
