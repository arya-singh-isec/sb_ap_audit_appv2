import 'package:loggy/loggy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/logger/logger_config.dart';

void main() {
  late Loggy logger;

  setUp(() {
    LoggerConfig.initLogger();
    logger = Loggy('Test Loggy');
  });

  // List<String> captureOutput(void Function() fn) {
  //   final output = <String>[];
  //   runZonedGuarded(
  //     fn,
  //     (error, stack) => print('Error: $error'),
  //     zoneSpecification: ZoneSpecification(
  //       print: (_, __, ___, String msg) {
  //         output.add(msg);
  //       },
  //     ),
  //   );
  //   return output;
  // }

  // tearDown(() {
  //   LoggerConfig.logAudit.clear();
  // });

  const testMessage = 'Test message';

  test('Info level logging', () {
    // Act
    logger.info(testMessage);
    final output = LoggerConfig.auditLogs;
    // Assert
    expect(output.length, 1);
    expect(output.last, contains('[I]'));
    expect(output.last, contains(testMessage));
  });

  test('Error level logging', () {
    // Act
    logger.error(testMessage);
    final output = LoggerConfig.auditLogs;
    // Assert
    expect(output.last, contains('[E]'));
    expect(output.last, contains('\n'));
    expect(output.last, contains(testMessage));
  });
}
