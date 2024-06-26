import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/partners_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/partner_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      super.noSuchMethod(
        Invocation.getter(#get),
        returnValue: Future.value(http.Response('{}', 200)),
        returnValueForMissingStub: Future.value(http.Response('{}', 200)),
      );
}

void main() {
  late MockHttpClient mockHttpClient;
  late PartnersRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = PartnersRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getPartners', () {
    final Uri tUrl = Uri.parse('https://test.example.com/getPartners');
    const tHeaders = {'Content-Type': 'application/json'};
    const List<PartnerModel> tPartnerModels = [
      PartnerModel(id: '1', name: 'Partner A'),
      PartnerModel(id: '2', name: 'Partner B')
    ];

    test('should forward GET request to the http client', () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_partners_success.json'), 200));
      // Act
      final _ = await remoteDataSourceImpl.getPartners();
      // Assert
      verify(mockHttpClient.get(tUrl, headers: tHeaders));
    });

    test('should return a valid model when the response code is 200 (success)',
        () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_partners_success.json'), 200));
      // Act
      final result = await remoteDataSourceImpl.getPartners();
      // Assert
      expect(result, tPartnerModels);
    });

    test(
        'should return a server exception when the response code is 404 or other',
        () async {
      // Arrange
      when(mockHttpClient.get(tUrl, headers: tHeaders)).thenAnswer((_) async =>
          http.Response(fixture('get_partners_failure.json'), 404));
      // Act
      final call = remoteDataSourceImpl.getPartners;
      // Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
