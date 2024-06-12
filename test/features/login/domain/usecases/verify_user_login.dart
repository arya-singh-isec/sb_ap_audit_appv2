import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/repositories/login_user_repository.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/usecases/verify_user_login.dart';

class MockLoginUserRepository extends Mock implements LoginUserRepository {}

// TDD: Red -> Green -> Refactor
// You always test your logic with the worst case scenario first.
void main() {
  VerifyUserLogin usecase;
  late MockLoginUserRepository mockLoginUserRepository;

  setUp(() {
    mockLoginUserRepository = MockLoginUserRepository();
    usecase = VerifyUserLogin(mockLoginUserRepository);
  });

  const tUsername = 'aryasingh';
  const tPassword = 'test1234';
  const tUser = User(username: tUsername, password: tPassword);

  test('should verify successful login', () async {
    // arrange
    // when(mockLoginUserRepository.verifyUserLogin(any,any))
    // .thenAnswer((_) async => User())
    // act
    // assert
  });
}
