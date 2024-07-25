import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/repositories/user_repository.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/usecases/login_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

// TDD: Red->Green->Refactor
void main() {
  late LoginUser usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = LoginUser(mockUserRepository);
  });

  const tUsername = '739333';
  const tPassword = 'test1234';
  const Credentials tCredentials =
      Credentials(username: tUsername, password: tPassword);

  const User tUser = User(
    id: '739333',
    isLoggedIn: true,
    sessionToken: '<Session-Token>',
  );

  test('should verify successful login', () async {
    // Arrange
    when(mockUserRepository.login(tCredentials))
        .thenAnswer((_) async => const Right(tUser));
    // Act
    final result = await usecase.execute(tCredentials);
    // Assert
    expect(result, const Right(tUser));
    verify(mockUserRepository.login(tCredentials));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
