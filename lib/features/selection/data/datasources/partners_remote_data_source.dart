import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
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
    const String url = 'https://test.example.com/getPartners';
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data['data'];
        final List<PartnerModel> models =
            jsonData.map((jsonMap) => PartnerModel.fromJson(jsonMap)).toList();
        return models;
      } else {
        final body = response.data;
        throw ServerException(
            code: body['error']['code'], message: body['error']['message']);
      }
    } on Exception {
      throw ServerException(
          code: 500, message: 'Server error. Please try again later!');
    }
  }
}
