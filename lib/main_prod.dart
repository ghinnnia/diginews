import 'package:diginews_offline_first/main_common.dart';

/// Entry point flavor PROD.
/// Jalankan dengan:
///   flutter run -t lib/main_prod.dart --flavor prod --dart-define=FLAVOR=prod
/// Build APK Release:
///   flutter build apk --release -t lib/main_prod.dart --flavor prod --dart-define=FLAVOR=prod
Future<void> main() async {
  await bootstrap();
}
