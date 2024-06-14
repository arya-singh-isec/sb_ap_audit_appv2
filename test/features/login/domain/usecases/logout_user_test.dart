import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/repositories/user_repository.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/usecases/logout_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late LogoutUser usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = LogoutUser(mockUserRepository);
  });

  test('should verify successful logout', () async {
    // Arrange
    when(mockUserRepository.logout())
        .thenAnswer((_) async => const Right(true));
    // Act
    final result = await usecase.execute();
    // Assert
    expect(result, const Right(true));
    verify(mockUserRepository.logout());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
