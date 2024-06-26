import 'dart:convert';

import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';

import '../models/partner_model.dart';
import 'package:http/http.dart' as http;

abstract class PartnersRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<PartnerModel>?>? getPartners();
}

class PartnersRemoteDataSourceImpl extends PartnersRemoteDataSource {
  final http.Client client;

  PartnersRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PartnerModel>?>? getPartners() async {
    final Uri url = Uri.parse('https://test.example.com/getPartners');
    try {
      final response =
          await client.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['data'];
        final List<PartnerModel> models =
            jsonData.map((jsonMap) => PartnerModel.fromJson(jsonMap)).toList();
        return models;
      } else {
        final body = json.decode(response.body);
        throw ServerException(
            code: body['error']['code'], message: body['error']['message']);
      }
    } on Exception {
      throw ServerException(
          code: 500, message: 'Server error. Please try again later!');
    }
  }
}
