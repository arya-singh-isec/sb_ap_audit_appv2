import 'package:loggy/loggy.dart';

import 'custom_printer.dart';

class LoggerConfig {
  static bool enableLogging = true;
  // static bool enableLogging =
  //     const String.fromEnvironment("enableLogging") == "true" ? true : false;
  static void initLogger() {
    Loggy.initLoggy(
      logPrinter: const CustomPrinter(),
      filters: [
        // BlacklistFilter([BlocLoggy])
      ],
      logOptions: const LogOptions(
        LogLevel.all,
        stackTraceLevel: LogLevel.error,
        includeCallerInfo: true,
      ),
    );
  }
}
