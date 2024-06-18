import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/features/login/data/models/user_model.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const UserModel tUserModel = UserModel(
      id: '1', name: 'Arya Singh', email: 'arya.singh@icicisecurities.com');

  test('model should be a subclass of User entity', () {
    // Assert
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    final Map<String, dynamic> jsonMapOnSuccess =
        json.decode(fixture('user_login_success.json'));
    final Map<String, dynamic> jsonMapOnFailure =
        json.decode(fixture('user_login_failure.json'));
    test('should return a valid model on successful login', () async {
      // Act
      final result = UserModel.fromJson(jsonMapOnSuccess);
      // Assert
      expect(result, tUserModel);
    });

    // test('should return a valid response on login failure', () async {
    //   // Arrange
    //   when(UserModel.fromJson(jsonMapOnFailure)).thenThrow(ServerException(
    //       code: jsonMapOnFailure['error']['code'],
    //       message: jsonMapOnFailure['error']['message']));
    //   // Act
    //   final result = UserModel.fromJson(jsonMapOnFailure);
    //   // Assert
    //   expect(result, isA<ServerException>());
    // });
  });

  group("toJson", () {
    test('should return valid conversion to json map', () async {
      // Act
      final result = tUserModel.toJson();
      // Assert
      expect(result, {
        'id': '1',
        'name': 'Arya Singh',
        'email': 'arya.singh@icicisecurities.com'
      });
    });
  });
}
