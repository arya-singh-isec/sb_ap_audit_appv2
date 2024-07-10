import 'package:loggy/loggy.dart';

import 'custom_printer.dart';

class LoggerConfig {
  static bool enableLogging = true;
  // static bool enableLogging =
  //     const String.fromEnvironment("enableLogging") == "true" ? true : false;
  static final _customPrinter = CustomPrinter();
  static List<Audit> get auditLogs => _customPrinter.getLogs();

  static void initLogger() {
    Loggy.initLoggy(
      logPrinter: _customPrinter,
      filters: [CustomLogFilter()],
      logOptions: const LogOptions(
        LogLevel.all,
        stackTraceLevel: LogLevel.error,
        includeCallerInfo: true,
      ),
    );
  }
}

class CustomLogFilter extends BlacklistFilter {
  CustomLogFilter([super.types = const []]);

  @override
  bool shouldLog(LogLevel level, Type type) {
    return LoggerConfig.enableLogging && super.shouldLog(level, type);
  }
}
