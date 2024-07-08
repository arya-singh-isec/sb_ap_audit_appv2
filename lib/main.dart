import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app.dart';
import 'core/logger/logger_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerConfig.initLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}
