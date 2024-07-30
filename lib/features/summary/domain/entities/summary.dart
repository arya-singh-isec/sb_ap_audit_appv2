// lib/features/summary/domain/entities/record.dart
class Summary {
  final String subBrokerName;
  final String subBrokerCode;
  final String auditId;
  final DateTime auditStartDate;
  final String auditStatus;
  final String auditFY;
  final String auditFinancialHalf;

  Summary({
    required this.subBrokerName,
    required this.subBrokerCode,
    required this.auditId,
    required this.auditStartDate,
    required this.auditStatus,
    required this.auditFY,
    required this.auditFinancialHalf,
  });
}
