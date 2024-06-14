// lib/data/repositories/record_repository_impl.dart
import '../../domain/entities/record.dart';
import '../../domain/repositories/record_repository.dart';

class RecordRepositoryImpl implements RecordRepository {
  @override
  Future<List<Record>> getRecords() async {
    // Commented out API call and replaced with static data
    // final response = await client.get(Uri.parse('https://api.example.com/records'));
    // if (response.statusCode == 200) {
    //   List jsonResponse = json.decode(response.body);
    //   return jsonResponse.map((record) => RecordModel.fromJson(record)).toList();
    // } else {
    //   throw Exception('Failed to load records');
    // }

    // Static data
    await Future.delayed(Duration(seconds: 1));  // Simulate network delay
    return [
      Record(
        id: 'RAMN4648',
        name: 'RAMU',
        initiatedDate: DateTime.parse('2024-05-28 12:45:58'),
        status: 'ACCEPTED BY SUBBROKER',
        initiatedYear: 'FY 2024-2025',
        initiatedPeriod: 'First half',
      ),
      Record(
        id: 'KRIS4528',
        name: 'RITAN SHAH',
        initiatedDate: DateTime.parse('2024-05-07 22:32:04'),
        status: 'REJECTED BY REVIEWER',
        initiatedYear: 'FY 2024-2025',
        initiatedPeriod: 'First half',
      ),
      Record(
        id: 'BABC5037',
        name: 'BABU RAO',
        initiatedDate: DateTime.parse('2024-04-17 17:35:05'),
        status: 'ACCEPTED BY CORPORATE',
        initiatedYear: 'FY 2024-2025',
        initiatedPeriod: 'First half',
      ),
      Record(
        id: 'BABC5037',
        name: 'BABU RAO',
        initiatedDate: DateTime.parse('2024-04-15 15:26:59'),
        status: 'ACCEPTED BY CORPORATE',
        initiatedYear: 'FY 2024-2025',
        initiatedPeriod: 'First half',
      ),
      Record(
        id: 'KRIS4528',
        name: 'RITAN SHAH',
        initiatedDate: DateTime.parse('2024-04-15 15:13:09'),
        status: 'ACCEPTED BY CORPORATE',
        initiatedYear: 'FY 2024-2025',
        initiatedPeriod: 'First half',
      ),
    ];
  }
}
