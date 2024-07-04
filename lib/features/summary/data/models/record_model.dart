// lib/data/models/record_model.dart
import '../../domain/entities/record.dart';

class RecordModel extends Record {
  RecordModel({
    required String id,
    required String name,
    required DateTime initiatedDate,
    required String status,
    required String initiatedYear,
    required String initiatedPeriod,
  }) : super(
          id: id,
          name: name,
          initiatedDate: initiatedDate,
          status: status,
          initiatedYear: initiatedYear,
          initiatedPeriod: initiatedPeriod,
        );

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      name: json['name'],
      initiatedDate: DateTime.parse(json['initiatedDate']),
      status: json['status'],
      initiatedYear: json['initiatedYear'],
      initiatedPeriod: json['initiatedPeriod'],
    );
  }
}