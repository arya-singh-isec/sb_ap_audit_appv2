import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/network/dio_client.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/partners_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/partner_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDioClient extends Mock implements DioClient {
  @override
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) =>
      super.noSuchMethod(
        Invocation.getter(#get),
        returnValue: Future.value(Response(
            data: {}, requestOptions: RequestOptions(), statusCode: 200)),
        returnValueForMissingStub: Future.value(Response(
            data: {}, requestOptions: RequestOptions(), statusCode: 200)),
      );
}

void main() {
  late MockDioClient mockDioClient;
  late PartnersRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockDioClient = MockDioClient();
    remoteDataSourceImpl = PartnersRemoteDataSourceImpl(client: mockDioClient);
  });

  group('getPartners', () {
    const String tUrl = 'https://test.example.com/getPartners';
    // const tHeaders = {'Content-Type': 'application/json'};
    const List<PartnerModel> tPartnerModels = [
      PartnerModel(id: '1', name: 'Partner A'),
      PartnerModel(id: '2', name: 'Partner B')
    ];

    test('should forward GET request to the http client', () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_partners_success.json'),
          requestOptions: RequestOptions(),
          statusCode: 200));
      // Act
      final _ = await remoteDataSourceImpl.getPartners();
      // Assert
      verify(mockDioClient.get(tUrl));
    });

    test('should return a valid model when the response code is 200 (success)',
        () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_partners_success.json'),
          requestOptions: RequestOptions(),
          statusCode: 200));
      // Act
      final result = await remoteDataSourceImpl.getPartners();
      // Assert
      expect(result, tPartnerModels);
    });

    test(
        'should return a server exception when the response code is 404 or other',
        () async {
      // Arrange
      when(mockDioClient.get(tUrl)).thenAnswer((_) async => Response(
          data: fixture('get_partners_failure.json'),
          requestOptions: RequestOptions(),
          statusCode: 404));
      // Act
      final call = remoteDataSourceImpl.getPartners;
      // Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
