// lib/presentation/widgets/record_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/summary.dart';

class SummaryCard extends StatelessWidget {
  final Summary record;

  SummaryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${record.auditId} - ${record.subBrokerName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Audit Start Date: ${record.auditStartDate.toLocal()}'),
            Text('Audit FY: ${record.auditFY}'),
            Text('Audit Financial Half: ${record.auditFinancialHalf}'),
            Text('Status: ${record.auditStatus}', style: TextStyle(color: record.auditStatus.contains('REJECTED') ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }
}
