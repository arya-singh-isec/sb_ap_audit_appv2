// lib/domain/entities/record.dart
class Record {
  final String id;
  final String name;
  final DateTime initiatedDate;
  final String status;
  final String initiatedYear;
  final String initiatedPeriod;

  Record({
    required this.id,
    required this.name,
    required this.initiatedDate,
    required this.status,
    required this.initiatedYear,
    required this.initiatedPeriod,
  });
}
