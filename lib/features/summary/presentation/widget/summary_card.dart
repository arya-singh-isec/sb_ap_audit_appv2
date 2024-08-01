// lib/presentation/widgets/summary_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/summary.dart';

class SummaryCard extends StatelessWidget {
  final Summary record;

  const SummaryCard({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${record.auditId} - ${record.subBrokerName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Audit Start Date:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.auditStartDate.toLocal()}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Audit FY:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.auditFY}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Audit Financial Half:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.auditFinancialHalf}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: record.auditStatus.contains('REJECTED') ? Colors.red : Colors.green,
                ),
              ),
              Text(
                '${record.auditStatus}',
                style: TextStyle(
                  color: record.auditStatus.contains('REJECTED') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
