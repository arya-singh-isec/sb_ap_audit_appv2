import 'dart:collection';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:loggy/loggy.dart';

// ignore: must_be_immutable
class Audit extends Equatable {
  final String logMessage;
  int recCount;

  Audit({required this.logMessage}) : recCount = 1;

  void increaseCount() {
    recCount++;
  }

  @override
  List<Object?> get props => [logMessage];

  @override
  String toString() {
    return '($logMessage [$recCount])';
  }
}

class CustomPrinter extends LoggyPrinter {
  final int _maxAuditSize;
  final Queue<Audit> _audit;

  CustomPrinter({int maxAuditSize = 5})
      : _maxAuditSize = maxAuditSize,
        _audit = Queue<Audit>();

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

  void addLog(item) {
    if (_audit.length == _maxAuditSize) {
      _audit.removeFirst();
    }
    final toAdd = Audit(logMessage: item);
    if (_audit.isEmpty || toAdd != _audit.last) {
      _audit.addLast(toAdd);
    } else {
      _audit.last.increaseCount();
    }
  }

  List<Audit> getLogs() {
    return List<Audit>.from(_audit);
  }

  @override
  void onLog(LogRecord record) {
    String logLevel = _levelPrefixes[record.level] ?? '[-]';
    String caller = record.callerFrame == null
        ? '-'
        : '(${record.callerFrame?.location.split('/').last})';
    String time = record.time.toIso8601String().split('T')[1];
    final color = _levelColors[record.level] ?? AnsiColor();
    String stackTraceString = record.stackTrace.toString();
    String message =
        '[$logLevel] [${record.loggerName}] [$caller] $time - ${record.message}';

    // developer.log(
    //   message,
    //   name: logLevel,
    //   stackTrace: record.stackTrace,
    //   level: record.level.priority,
    //   time: record.time,
    //   zone: record.zone,
    //   sequenceNumber: record.sequenceNumber,
    // );
    stdout.writeln(color(message));
    addLog('[$logLevel] ${record.message}');
    if (record.level.priority >= LogLevel.error.priority) {
      stdout.writeln(color(stackTraceString));
    }
  }
}
