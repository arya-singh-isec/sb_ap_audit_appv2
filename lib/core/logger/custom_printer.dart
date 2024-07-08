import 'dart:io';

import 'package:loggy/loggy.dart';

class CustomPrinter extends LoggyPrinter {
  const CustomPrinter();

  static final Map<LogLevel, String> _levelPrefixes = <LogLevel, String>{
    LogLevel.info: 'I',
    LogLevel.debug: 'D',
    LogLevel.error: 'E',
    LogLevel.warning: 'W'
  };

  static final _levelColors = {
    LogLevel.debug: AnsiColor(foregroundColor: AnsiColor.grey(0.5)),
    LogLevel.info: AnsiColor(foregroundColor: 12),
    LogLevel.warning: AnsiColor(foregroundColor: 11),
    LogLevel.error: AnsiColor(foregroundColor: 9),
  };

  @override
  void onLog(LogRecord record) {
    String logLevel = _levelPrefixes[record.level] ?? '[-]';
    String caller = record.callerFrame == null
        ? '-'
        : '(${record.callerFrame?.location.split('/').last})';
    String time = record.time.toIso8601String().split('T')[1];
    final color = _levelColors[record.level] ?? AnsiColor();
    String stackTraceString = color(record.stackTrace.toString());
    String message = color(
        '[$logLevel] [${record.loggerName}] [$caller] $time - ${record.message}');

    // developer.log(
    //   message,
    //   name: logLevel,
    //   stackTrace: record.stackTrace,
    //   level: record.level.priority,
    //   time: record.time,
    //   zone: record.zone,
    //   sequenceNumber: record.sequenceNumber,
    // );
    stdout.writeln(message);
    if (record.level.priority >= LogLevel.error.priority) {
      stdout.writeln(stackTraceString);
    }
  }
}
