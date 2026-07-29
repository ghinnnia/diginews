import 'package:diginews_offline_first/core/utils/nim_config.dart';

/// Enum flavor aplikasi. Dibaca dari --dart-define=FLAVOR=dev|prod
/// yang dikirim baik ke Dart maupun diteruskan ke Gradle (lihat
/// android/app/build.gradle) sehingga app label di HP Android ikut berubah.
enum Flavor { dev, prod }

class AppFlavor {
  AppFlavor._();

  /// Dibaca sekali saat aplikasi start dari --dart-define=FLAVOR=dev/prod
  /// Dijalankan lewat main_dev.dart atau main_prod.dart.
  static const String _flavorString = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static Flavor get current =>
      _flavorString == 'prod' ? Flavor.prod : Flavor.dev;

  static bool get isProd => current == Flavor.prod;
  static bool get isDev => current == Flavor.dev;

  /// Nama aplikasi yang ditampilkan di dalam UI (AppBar/Splash).
  /// Label ikon aplikasi di launcher HP diatur terpisah lewat
  /// android/app/src/dev/res/values/strings.xml dan
  /// android/app/src/prod/res/values/strings.xml (Android product flavor),
  /// supaya benar-benar berubah di level sistem operasi, bukan cuma di UI.
  static String get appName => isProd
      ? 'UTD - ${NimConfig.nim}'
      : 'DEV - ${NimConfig.namaDepan}';

  static String get flavorLabel => isProd ? 'PRODUCTION' : 'DEVELOPMENT';
}
