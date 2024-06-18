import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/utils/input_validator.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';

void main() {
  late InputValidator inputValidator;

  setUp(() {
    inputValidator = InputValidator();
  });

  test('should return a failure when either of username or password is empty',
      () async {
    // Arrange
    const credentials = Credentials(username: '', password: 'password');
    // Act
    final result = inputValidator.validateCredentials(credentials);
    // Assert
    expect(result, Left(InvalidInputFailure()));
  });
}
