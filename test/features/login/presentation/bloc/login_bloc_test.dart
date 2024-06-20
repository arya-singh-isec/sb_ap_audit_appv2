import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/core/utils/input_validator.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/usecases/login_user.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/usecases/logout_user.dart';
import 'package:sb_ap_audit_appv2/features/login/presentation/blocs/bloc.dart';

class MockLoginUser extends Mock implements LoginUser {}

class MockLogoutUser extends Mock implements LogoutUser {}

class MockInputValidator extends Mock implements InputValidator {}

void main() {
  late LoginBloc bloc;
  late MockLoginUser mockLoginUser;
  late MockLogoutUser mockLogoutUser;
  late MockInputValidator mockInputValidator;

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockLogoutUser = MockLogoutUser();
    mockInputValidator = MockInputValidator();
    bloc = LoginBloc(
        loginUser: mockLoginUser,
        logoutUser: mockLogoutUser,
        inputValidator: mockInputValidator);
  });

  test('initialState should be LoginEmpty', () {
    // assert
    expect(bloc.state, equals(LoginEmpty()));
  });

  const Credentials tCredentials =
      Credentials(username: 'test', password: 'test');

  void setUpMockInputValidatorSuccess() =>
      when(mockInputValidator.validateCredentials(tCredentials))
          .thenReturn(const Right(tCredentials));

  test('should call the inputValidator to validate the credentials', () async {
    // Arrange
    setUpMockInputValidatorSuccess();
    // Act
    bloc.add(const Submitted(credentials: tCredentials));
    await untilCalled(mockInputValidator.validateCredentials(tCredentials));
    // Assert
    verify(mockInputValidator.validateCredentials(tCredentials));
  });

  group('login', () {
    const tUser = User(
        id: '1', name: 'Arya Singh', email: 'arya.singh@icicisecurities.com');

    test('should emit [LoginLoading, LoginSuccess] when login is successful',
        () async {
      // Arrange
      setUpMockInputValidatorSuccess();
      when(mockLoginUser.execute(tCredentials))
          .thenAnswer((_) async => const Right(tUser));
      // Assert Later - basically you are registering the expected output
      final expected = [
        LoginLoading(),
        LoginSuccess(user: tUser),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(const Submitted(credentials: tCredentials));
      await untilCalled(mockLoginUser.execute(tCredentials));
      verify(mockLoginUser.execute(tCredentials));
    });

    test('should emit [LoginLoading, LoginError] when login is unsuccessful',
        () async {
      // Arrange
      setUpMockInputValidatorSuccess();
      when(mockLoginUser.execute(tCredentials)).thenAnswer((_) async =>
          Left(ServerFailure(code: 401, message: 'Invalid credentials!')));
      // Assert Later
      final expected = [
        LoginLoading(),
        LoginError(message: 'Invalid credentials!'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(const Submitted(credentials: tCredentials));
    });
  });

  group('logout', () {
    test('should emit [LoginLoading, LoginSuccess] when logout is successful',
        () async {
      // Arrange
      when(mockLogoutUser.execute()).thenAnswer((_) async => const Right(true));
      // Assert Later
      final expected = [
        LoginLoading(),
        LogoutSuccess(),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(const Submitted());
    });

    test('should emit [LoginLoading, LoginError] when logout is unsuccessful',
        () async {
      // Arrange
      when(mockLogoutUser.execute()).thenAnswer((_) async =>
          Left(ServerFailure(code: 500, message: 'Server Error!')));
      // Assert Later
      final expected = [
        LoginLoading(),
        LogoutError(message: 'Server Error!'),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(const Submitted());
      await untilCalled(mockLogoutUser.execute());
      // Assert
      verify(mockLogoutUser.execute());
    });
  });
}
