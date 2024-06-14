// lib/presentation/widgets/record_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/record.dart';

class RecordCard extends StatelessWidget {
  final Record record;

  RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${record.id} - ${record.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Initiated Date: ${record.initiatedDate.toLocal()}'),
            Text('Initiated Year: ${record.initiatedYear}'),
            Text('Initiated Period: ${record.initiatedPeriod}'),
            Text('Status: ${record.status}', style: TextStyle(color: record.status.contains('REJECTED') ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }
}
