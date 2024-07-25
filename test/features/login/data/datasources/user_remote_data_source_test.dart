import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sb_ap_audit_appv2/core/config/constants.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/features/login/data/datasources/user_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/login/data/models/user_model.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      super.noSuchMethod(
        Invocation.getter(#get),
        returnValue: Future.value(http.Response('{}', 200)),
        returnValueForMissingStub: Future.value(http.Response('{}', 200)),
      );

  @override
  Future<http.Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      super.noSuchMethod(
        Invocation.getter(#post),
        returnValue: Future.value(http.Response('{}', 200)),
        returnValueForMissingStub: Future.value(http.Response('{}', 200)),
      );
}

void main() {
  late MockHttpClient mockHttpClient;
  late UserRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = UserRemoteDataSourceImpl(client: mockHttpClient);
  });

  const headers = {'Content-Type': 'application/json; charset=UTF-8'};

  // group('login', () {
  //   final Uri url = Uri.parse(ApiConstants.login);
  //   const Credentials credentials =
  //       Credentials(username: 'test', password: 'test');
  //   const UserModel tUserModel = UserModel(
  //     id: '739333',
  //     isLoggedIn: true,
  //     sessionToken: '<Session-Token>',
  //   );

  //   test('should forward correct GET request to http client', () async {
  //     // Arrange
  //     when(mockHttpClient.post(url, headers: headers, body: any)).thenAnswer(
  //         (_) async => http.Response(fixture('user_login_success.json'), 200));
  //     // Act
  //     remoteDataSourceImpl
  //         .login(const Credentials(username: 'test', password: 'test'));
  //     // Assert
  //     verify(mockHttpClient.post(url, headers: headers, body: any));
  //   });

  //   test('should return valid model when the response code is 200 (success)',
  //       () async {
  //     // Arrange
  //     when(mockHttpClient.post(url, headers: headers, body: anyNamed('body')))
  //         .thenAnswer((_) async =>
  //             http.Response(fixture('user_login_success.json'), 200));
  //     // Act
  //     final result = await remoteDataSourceImpl
  //         .login(const Credentials(username: 'test', password: 'test'));
  //     // Assert
  //     expect(result, tUserModel);
  //   });

  //   test(
  //       'should return server exception when the response code is 401 or other',
  //       () async {
  //     // Arrange
  //     when(mockHttpClient.post(url, headers: headers, body: anyNamed('body')))
  //         .thenAnswer((_) async =>
  //             http.Response(fixture('user_login_failure.json'), 500));
  //     // Act
  //     final call = remoteDataSourceImpl.login;
  //     // Assert
  //     expect(() => call(credentials),
  //         throwsA(const TypeMatcher<ServerException>()));
  //   });
  // });

  // group('logout', () {
  //   final Uri url = Uri.parse('https://test.example.com/logout');

  //   test('should return true when the response code is 200 (success)',
  //       () async {
  //     // Arrange
  //     when(mockHttpClient.get(url, headers: headers)).thenAnswer((_) async =>
  //         http.Response(
  //             '{"Status": 200, "Error": null, "Success": {"LoginFlag": "N", "SessionToken":null}}',
  //             200));
  //     // Act
  //     final result = await remoteDataSourceImpl.logout();
  //     // Assert
  //     expect(result, true);
  //   });

  //   test(
  //       'should return server exception when the response code is 401 or other',
  //       () async {
  //     // Arrange
  //     when(mockHttpClient.get(url, headers: headers)).thenAnswer((_) async =>
  //         http.Response(
  //             '{"Status": 500, "Error": "Invalid Input Data", "Success": null}',
  //             500));
  //     // Act
  //     final call = remoteDataSourceImpl.logout;
  //     // Assert
  //     expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
  //   });
  // });
}
