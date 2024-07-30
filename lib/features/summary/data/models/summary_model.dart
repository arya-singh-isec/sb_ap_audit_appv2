import 'package:intl/intl.dart';
import '../../domain/entities/summary.dart';

class SummaryModel extends Summary {
  SummaryModel({
    required String subBrokerName,
    required String subBrokerCode,
    required String auditId,
    required DateTime auditStartDate,
    required String auditStatus,
    required String auditFY,
    required String auditFinancialHalf,
  }) : super(
          subBrokerName: subBrokerName,
          subBrokerCode: subBrokerCode,
          auditId: auditId,
          auditStartDate: auditStartDate,
          auditStatus: auditStatus,
          auditFY: auditFY,
          auditFinancialHalf: auditFinancialHalf,
        );

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yy-MM-dd HH:mm:ss');

    return SummaryModel(
      subBrokerName: json['SubBrokerName'] ?? '',
      subBrokerCode: json['SubBrokerCode'] ?? '',
      auditId: json['AuditID'] ?? '',
      auditStartDate: dateFormat.parse(json['AuditStartDate'] ?? ''),
      auditStatus: json['AuditStatus'] ?? '',
      auditFY: json['AuditFY'] ?? '',
      auditFinancialHalf: json['AuditFinancialHalf'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SubBrokerName': subBrokerName,
      'SubBrokerCode': subBrokerCode,
      'AuditID': auditId,
      'AuditStartDate': DateFormat('yy-MM-dd HH:mm:ss').format(auditStartDate),
      'AuditStatus': auditStatus,
      'AuditFY': auditFY,
      'AuditFinancialHalf': auditFinancialHalf,
    };
  }
}
