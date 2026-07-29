import 'package:flutter/material.dart';
import 'package:diginews_offline_first/app/app.dart';
import 'package:diginews_offline_first/app/app_flavor.dart';
import 'package:diginews_offline_first/core/di/injection_container.dart';
import 'package:diginews_offline_first/core/services/background_sync_service.dart';
import 'package:diginews_offline_first/core/utils/app_logger.dart';

/// Bootstrap bersama dipakai oleh main_dev.dart & main_prod.dart.
/// Perbedaan flavor DEV/PROD ditentukan dari --dart-define=FLAVOR=dev|prod
/// yang dibaca AppFlavor, BUKAN dari file main_*.dart ini (supaya tidak
/// ada duplikasi logika antara 2 flavor).
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.i('Booting DigiNews - flavor: ${AppFlavor.flavorLabel}, app name: ${AppFlavor.appName}');

  await ServiceLocator.init();

  await BackgroundSyncService.initialize();
  await BackgroundSyncService.schedulePeriodicSync();

  runApp(const DigiNewsApp());
}
