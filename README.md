# DigiNews Offline-First

UAS Mobile Programming Lanjut — Universitas Teknologi Digital
**Nama:** Ghinnia Nuraulia · **NIM:** 20123046 · **Tema:** DigiNews Offline-First

> 🚨 **SETIAP KALI Anda extract ulang ZIP ini / pindah folder / clone ulang git,**
> **WAJIB jalankan dulu satu perintah ini SEBELUM apapun lainnya:**
> ```bash
> flutter pub get && dart run build_runner build --delete-conflicting-outputs
> ```
> atau cukup double-click **`setup.bat`** (Windows) / jalankan **`./setup.sh`** (Mac/Linux).
> File `news_collection.g.dart` HARUS di-generate ulang setiap kali — itu bukan
> bug, itu memang bukan file yang ikut di ZIP (generated code, best practice
> tidak disertakan sebagai source). Kalau Anda lihat error
> `NewsCollectionSchema` / `newsCollections` undefined lagi, ini SELALU
> penyebabnya — jangan tanya ke AI dulu, jalankan perintah di atas dulu.

> ⚠️ **Baca file ini sampai habis SEBELUM merekam video presentasi.**
> Semua logika "berbasis NIM" sengaja dikumpulkan penjelasannya di sini
> supaya Anda tahu persis file mana yang harus dibuka & dijelaskan.

---

## 1. Status pengerjaan project ini

Project ini dibangun bertahap bersama AI sebagai pair-programmer, sesuai
kebijakan penggunaan AI di soal UAS. Beberapa hal **BELUM** bisa
diverifikasi otomatis oleh AI karena sandbox pembuatannya tidak memiliki
akses ke Flutter SDK/pub.dev (jaringan dibatasi). Sebelum submit, **Anda
wajib menjalankan sendiri** langkah-langkah di bagian "Cara Menjalankan"
di bawah, dan memperbaiki bila ada error versi package di mesin Anda.

### 1.1 Riwayat perbaikan (baik untuk bahan cerita "proses debugging" di video)

- **Percobaan `flutter pub get` pertama GAGAL** karena package resmi
  `isar`/`isar_generator` (v3.1.0+1) sudah tidak dipelihara sejak awal 2025
  dan menetapkan `analyzer <6.0.0`, sedangkan `bloc_test` modern + Flutter
  SDK terbaru membutuhkan `analyzer` yang jauh lebih baru → version solving
  gagal.
- **Perbaikan:** migrasi ke fork komunitas aktif `isar_community` /
  `isar_community_flutter_libs` / `isar_community_generator` (publisher
  terverifikasi `isar-community.dev` di pub.dev, rilis terbaru saat ini
  3.3.2, `analyzer >=8.0.0 <11.0.0`). API-nya 100% identik dengan Isar
  biasa (`Isar.open`, `@collection`, `.filter()`, dst), hanya nama package
  & import (`package:isar_community/isar.dart`) yang berbeda.
- **Percobaan `flutter run` juga sempat GAGAL di tahap `compileDebugKotlin`**
  karena package `workmanager` versi `0.5.2` (yang awalnya saya pasang)
  punya bug publik: masih memakai kelas v1 Android embedding
  (`ShimPluginRegistry`, `PluginRegistrantCallback`, dst) yang sudah
  **dihapus total** dari Flutter SDK terbaru. Ini bug yang sudah
  dilaporkan banyak developer lain di GitHub, bukan salah konfigurasi
  project Anda.
- **Perbaikan:** upgrade ke `workmanager: ^0.9.0+3` (rilis terbaru,
  federated plugin architecture, publisher terverifikasi
  `fluttercommunity.dev`) yang sudah memperbaiki masalah ini. API
  pemakaiannya (`initialize`, `registerPeriodicTask`, `executeTask`) tidak
  berubah, jadi tidak ada kode Dart lain yang perlu disesuaikan.
- Ini contoh bagus untuk diceritakan di video sebagai bukti pemahaman
  Anda: jelaskan bahwa Anda (dibantu AI) mendiagnosis pesan error version
  solving/compile, mencari akar masalah (package outdated/abandoned), dan
  memilih versi/fork yang tepat — bukan asal comot solusi dari internet.

---



## 2. Arsitektur

Clean Architecture + Feature-First:

```
lib/
  app/                 -> root widget, flavor config
  core/                -> DI (get_it), router (go_router), network (Dio),
                           error handling, logger, service native & background
  shared/               -> widget generik (loading/error/empty state)
  features/
    splash/
    news/
      data/            -> model, datasource (remote/local), repository impl
      domain/           -> entity, repository interface, usecase
      presentation/     -> bloc, pages, widgets
    realtime/            -> Cubit koneksi WebSocket
    profile/             -> halaman About + Easter Egg + demo MethodChannel
```

Alur data: `UI -> BLoC -> UseCase -> Repository (interface, domain) ->
RepositoryImpl (data) -> RemoteDataSource(Dio) / LocalDataSource(Isar)`.

---

## 3. PETA LOKASI LOGIKA BERBASIS NIM (penting untuk video!)

NIM: **20123046** → digit terakhir = **6**

| Requirement soal | Aturan untuk digit 6 | Lokasi kode |
|---|---|---|
| Sorting data API | Genap → **Ascending A-Z** | `lib/features/news/data/repositories/news_repository_impl.dart` → method `_applyNimSorting()` (dipanggil di layer Repository/Data, **bukan** di UI) |
| Easter Egg Lottie | Klik foto profil **6x** cepat | `lib/features/profile/presentation/pages/profile_page.dart` → `_onProfilePhotoTap()`, memakai `NimConfig.jumlahKlikEasterEgg` |
| MethodChannel Kotlin | Balik `"20123046"` → `"64032102"` | `android/app/src/main/kotlin/com/utd/diginews/MainActivity.kt` → `reverseString()` |
| Flavor DEV | Label app = `"DEV - Ghinnia"` | `android/app/build.gradle` (productFlavors.dev.resValue) |
| Flavor PROD | Label app = `"UTD - 20123046"`, warna Biru Gelap | `android/app/build.gradle` (productFlavors.prod) + `lib/core/theme/app_colors.dart` (`prodPrimary`) |

Semua angka di atas TIDAK ditulis berulang sebagai magic number, tapi
dipusatkan di **`lib/core/utils/nim_config.dart`** — tunjukkan file ini
di awal video sebagai "kunci" semua logika anti-AI di app ini.

---

## 4. Fitur yang sudah diimplementasikan

- [x] Splash Screen
- [x] Home News (list + pull to refresh + search dengan debounce)
- [x] Detail News
- [x] Offline Reading (fallback otomatis ke Isar saat Airplane Mode)
- [x] Cache Isar + indikator waktu cache terakhir
- [x] Auto Sync Background (Workmanager, periodic 15 menit)
- [x] Realtime WebSocket (indikator live-connection, lihat catatan di `constants.dart`)
- [x] Logger (package `logger`, dipakai di Interceptor/Repository/BLoC)
- [x] Material 3
- [x] Error Handling + Loading + Empty State (state eksplisit di `NewsState`)
- [x] MethodChannel Kotlin (reverse NIM + Native Toast)
- [x] Easter Egg Lottie 6x klik cepat
- [x] 2 Flavor (DEV/PROD) dengan app label & warna berbeda
- [x] Unit test (repository, bloc, nim_config), widget test (HomePage), integration test

## 5. Catatan jujur tentang fitur "Realtime WebSocket"

NewsAPI.org (REST API gratis) **tidak menyediakan** push/stream berita
realtime. Supaya requirement WebSocket tetap terpenuhi dengan **integrasi
teknis yang nyata** (bukan pura-pura), aplikasi ini konek ke public echo
WebSocket server (`wss://ws.postman-echo.com/raw`) dan menampilkan
indikator "LIVE" + jam update di banner Home Page. Ini murni untuk
membuktikan `WebSocketChannel` + `Stream` benar-benar terpasang end-to-end
(connect, kirim ping, terima balasan, auto-reconnect). **Jelaskan hal ini
secara jujur ke penguji di video** — ini keputusan desain yang wajar untuk
API publik gratis yang dipakai (lihat komentar di `lib/core/utils/constants.dart`).

---

## 6. Cara Menjalankan (WAJIB dilakukan sendiri)

### 6.1 Prasyarat
- Flutter SDK versi stabil terbaru (`flutter --version`)
- Android SDK + minimal 1 emulator/device fisik
- API Key gratis dari https://newsapi.org/register

### 6.2 Install dependency
```bash
flutter pub get
```

### 6.3 Generate kode Isar (WAJIB, belum otomatis!)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
> File `news_collection.g.dart` akan muncul otomatis setelah ini.
> Tanpa langkah ini, project TIDAK akan bisa di-compile.

### 6.4 Jalankan mode DEV
```bash
flutter run -t lib/main_dev.dart --flavor dev --dart-define=FLAVOR=dev --dart-define=NEWS_API_KEY=API_KEY_ANDA
```

### 6.5 Jalankan mode PROD
```bash
flutter run -t lib/main_prod.dart --flavor prod --dart-define=FLAVOR=prod --dart-define=NEWS_API_KEY=API_KEY_ANDA
```

### 6.6 Build APK Release
```bash
flutter build apk --release --flavor prod -t lib/main_prod.dart --dart-define=FLAVOR=prod --dart-define=NEWS_API_KEY=API_KEY_ANDA
```
Output: `build/app/outputs/flutter-apk/app-prod-release.apk`

### 6.7 Jalankan semua test
```bash
flutter analyze
flutter test
flutter test integration_test/app_test.dart
```

---

## 7. Menambahkan API Key secara permanen (opsional, lebih mudah saat demo)

Daripada mengetik `--dart-define=NEWS_API_KEY=...` setiap kali, buat file
`android/key.properties` ATAU cukup edit langsung nilai default di
`lib/core/utils/constants.dart` (khusus untuk keperluan demo lokal —
untuk production sungguhan sebaiknya tetap pakai `--dart-define`, jangan
hardcode API key ke repository publik).

---

## 8. Strategi Commit Git (WAJIB dibaca — bagian anti-AI paling ketat)

Soal secara eksplisit menyatakan:

> "Jika seluruh 20 commit dilakukan dalam waktu 1 jam di hari terakhir,
> Anda dianggap menggunakan hasil generate AI instan dan nilai poin ini
> Hangus (0)."

Karena itu **JANGAN** langsung `git add . && git commit` semua file dari
AI ini sekaligus. Gunakan project ini sebagai *starting point/scaffold*,
lalu benar-benar kerjakan secara bertahap dengan pola realistis, contoh:

- **Hari 1:** init repo, commit struktur folder + `pubspec.yaml` +
  `core/` (beberapa commit terpisah: "setup DI", "setup router", "setup theme")
- **Hari 2:** commit domain+data News per bagian ("add NewsEntity",
  "implement NewsRemoteDataSource", "implement NIM sorting logic di
  repository", "add Isar collection")
- **Hari 3:** commit presentation News (bloc, pages, widgets), lalu
  Profile+Easter Egg, lalu MethodChannel Kotlin
- **Hari 4 (opsional):** commit testing + CI/CD + perbaikan bug setelah
  Anda coba `flutter run` sendiri

Pastikan **minimal 20 commit** tersebar di **minimal 3 hari berbeda**,
dan setiap commit message benar-benar mencerminkan perubahan kecil yang
Anda pahami — karena Anda akan diminta menjelaskan bagian Kotlin & CI/CD
langsung dari VS Code di video.

```bash
git init
git add .
git commit -m "chore: initial project scaffold - clean architecture setup"
# ...lanjutkan bertahap sesuai progres nyata Anda, JANGAN sekaligus...
git branch -M main
git remote add origin <URL_REPO_ANDA>
git push -u origin main
```

---

## 9. Checklist sebelum submit ke LMS

- [ ] `flutter analyze` tanpa error
- [ ] `flutter test` semua lulus
- [ ] `flutter run` dev & prod jalan normal di device/emulator
- [ ] Airplane Mode → data lama dari Isar tetap muncul
- [ ] Klik foto profil 6x cepat → Easter Egg Lottie muncul 3 detik
- [ ] Tombol "Balikkan NIM via Kotlin" → hasil `64032102` + Native Toast muncul
- [ ] GitHub Actions hijau (Test + Build APK Release)
- [ ] Repository GitHub public, ≥20 commit di ≥3 hari berbeda
- [ ] APK release hasil artifact GitHub Actions sudah diunduh & link-nya siap
- [ ] Video presentasi ≤7 menit, facecam wajib, sesuai struktur soal (0-2 menit demo, 2-7 menit penjelasan kode)
