# DigiNews Offline-First

UAS Mobile Programming Lanjut — Universitas Teknologi Digital
**Nama:** Ghinnia Nuraulia · **NIM:** 20123046 · **Tema:** DigiNews Offline-First

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
