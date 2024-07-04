import 'package:flutter/material.dart';
import '../../domain/entities/record.dart';

class RecordCard extends StatelessWidget {
  final Record record;

  const RecordCard({Key? key, required this.record}) : super(key: key);

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
          Text('${record.id} - ${record.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Initiated Year:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.initiatedYear}'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Initiated Date:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.initiatedDate.toLocal()}'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Initiated Period:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${record.initiatedPeriod}'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status:', style: TextStyle(fontWeight: FontWeight.bold, color: record.status.contains('REJECTED') ? Colors.red : Colors.green)),
              Text('${record.status}',style: TextStyle(color: record.status.contains('REJECTED') ? Colors.red : Colors.green),),
            ],
          ),
        ],
      ),
    );
  }
}


