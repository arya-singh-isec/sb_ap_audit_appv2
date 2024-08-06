import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sb_ap_audit_appv2/core/logger/logger.dart';

import 'core/app.dart';
import 'core/logger/logger.dart';
import 'core/logger/logger_config.dart';

Future<void> main() async {
  FlutterError.onError = (details) {
    ErrorLogger().logError(details.exception, details.stack);
  };

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    LoggerConfig.initLogger();

    await Future.wait(<Future<void>>[
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]),
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      ),
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    runApp(MaterialApp(home: MyApp()));
  }, (error, stackTrace) {
    ErrorLogger().logError(error, stackTrace);
  });
}
