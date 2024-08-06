import 'package:dio/dio.dart';
import '../../../../core/utils/common_utils.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class SelectionRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<String>> getFiscalYearData();
}

class SelectionRemoteDataSourceImpl extends SelectionRemoteDataSource {
  final DioClient client;

  SelectionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<String>> getFiscalYearData() async {
    const String url = ApiConstants.getData;
    try {
      final requestBody = auditGetData('MOBILE_SELF_FETCH_YEAR');

      final response = await client.post(url, data: requestBody);
      final responseBody = response.data;

      if (responseBody['Status'] == 200 &&
          responseBody['Success']!['FinancialYear'] != null) {
        List<String> fiscalYears = responseBody['Success']['FinancialYear']
            .map<String>((val) => val.toString())
            .toList();
        return fiscalYears;
      } else {
        throw ServerException(
            code: responseBody['Status'],
            message: responseBody['Error'] ?? 'Unexpected error!');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
            code: e.response!.statusCode!, message: e.message!);
      } else {
        throw ServerException(
            code: 500, message: 'Server error. Please try again later!');
      }
    }
  }
}
