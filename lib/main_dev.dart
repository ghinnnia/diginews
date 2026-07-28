import 'package:diginews_offline_first/main_common.dart';

/// Entry point flavor DEV.
/// Jalankan dengan:
///   flutter run -t lib/main_dev.dart --flavor dev --dart-define=FLAVOR=dev
Future<void> main() async {
  await bootstrap();
}
