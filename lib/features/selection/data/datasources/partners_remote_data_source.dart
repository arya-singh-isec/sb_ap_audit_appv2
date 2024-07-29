import 'package:dio/dio.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/common_utils.dart';
import '../models/partner_model.dart';

abstract class PartnersRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<PartnerModel>?>? getPartners();
}

class PartnersRemoteDataSourceImpl extends PartnersRemoteDataSource {
  final DioClient client;

  PartnersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PartnerModel>?>? getPartners() async {
    const String url = ApiConstants.getData;
    try {
      final requestBody = auditGetData('MOBILE_SELF_FETCH_SUB_BROKER');

      final response = await client.post(url, data: requestBody);
      final responseBody = response.data;
      if (responseBody['Status'] == 200) {
        final List<dynamic> jsonData = responseBody['Success'];
        final List<PartnerModel> models =
            jsonData.map((jsonMap) => PartnerModel.fromJson(jsonMap)).toList();
        return models;
      } else {
        throw ServerException(
            code: responseBody['Status'], message: responseBody['Error']);
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
