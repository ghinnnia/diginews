# DigiNews Offline-First

UAS Mobile Programming Lanjut — Universitas Teknologi Digital
**Nama:** Ghinnia Nuraulia · **NIM:** 20123046 · **Tema:** DigiNews Offline-First

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

## 1. Arsitektur

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

## 2. PETA LOKASI LOGIKA BERBASIS NIM

NIM: **20123046** → digit terakhir = **6**

| Requirement soal     | Aturan untuk digit 6                             | Lokasi kode                                                                                                                                         |
| -------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sorting data API     | Genap → **Ascending A-Z**                        | `lib/features/news/data/repositories/news_repository_impl.dart` → method `_applyNimSorting()` (dipanggil di layer Repository/Data, **bukan** di UI) |
| Easter Egg Lottie    | Klik foto profil **6x** cepat                    | `lib/features/profile/presentation/pages/profile_page.dart` → `_onProfilePhotoTap()`, memakai `NimConfig.jumlahKlikEasterEgg`                       |
| MethodChannel Kotlin | Balik `"20123046"` → `"64032102"`                | `android/app/src/main/kotlin/com/utd/diginews/MainActivity.kt` → `reverseString()`                                                                  |
| Flavor DEV           | Label app = `"DEV - Ghinnia"`                    | `android/app/build.gradle` (productFlavors.dev.resValue)                                                                                            |
| Flavor PROD          | Label app = `"UTD - 20123046"`, warna Biru Gelap | `android/app/build.gradle` (productFlavors.prod) + `lib/core/theme/app_colors.dart` (`prodPrimary`)                                                 |

## 3. Checklist sebelum submit ke LMS

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
