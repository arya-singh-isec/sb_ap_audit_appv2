// lib/presentation/pages/rejected_record_page.dart
import 'package:flutter/material.dart';
import '../../domain/entities/record.dart';

class RejectedRecordPage extends StatelessWidget {
  final Record record;

  const RejectedRecordPage({required this.record, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${record.name} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${record.id}', style: const TextStyle(fontSize: 18)),
            Text('Name: ${record.name}', style: const TextStyle(fontSize: 18)),
            Text('Initiated Date: ${record.initiatedDate.toLocal()}', style: const TextStyle(fontSize: 18)),
            Text('Status: ${record.status}', style: const TextStyle(fontSize: 18, color: Colors.red)),
            Text('Initiated Year: ${record.initiatedYear}', style: const TextStyle(fontSize: 18)),
            Text('Initiated Period: ${record.initiatedPeriod}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
