import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/core/network/network_info.dart';
import 'package:sb_ap_audit_appv2/features/login/data/datasources/user_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/login/data/models/user_model.dart';
import 'package:sb_ap_audit_appv2/features/login/data/repositories/user_repository_impl.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/credentials.dart';
import 'package:sb_ap_audit_appv2/features/login/domain/entities/user.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late UserRepositoryImpl repositoryImpl;
  late MockUserRemoteDataSource mockUserRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockUserRemoteDataSource = MockUserRemoteDataSource();
    repositoryImpl = UserRepositoryImpl(
      remoteDataSource: mockUserRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('login', () {
    const tCredentials = Credentials(username: '739333', password: 'test1234');

    const UserModel tUserModel = UserModel(
      id: '739333',
      isLoggedIn: true,
      sessionToken: '<Session-Token>',
    );
    const User tUser = tUserModel;

    test('should check if the device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      await repositoryImpl.login(tCredentials);
      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockUserRemoteDataSource.login(tCredentials))
            .thenAnswer((_) async => tUserModel);
        // Act
        final result = await repositoryImpl.login(tCredentials);
        // Assert
        verify(mockUserRemoteDataSource.login(tCredentials));
        expect(result, const Right(tUser));
      });

      final tServerException = ServerException(code: 404, message: 'Not Found');
      final tServerFailure = ServerFailure(code: 404, message: 'Not Found');

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(mockUserRemoteDataSource.login(tCredentials))
            .thenThrow(tServerException);
        // Act
        final result = await repositoryImpl.login(tCredentials);
        // Assert
        verify(mockUserRemoteDataSource.login(tCredentials));
        expect(result, Left(tServerFailure));
      });
    });

    // write tests for when device is offline
  });

  group('logout', () {
    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should return true when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockUserRemoteDataSource.logout()).thenAnswer((_) async => true);
        // Act
        final result = await repositoryImpl.logout();
        // Assert
        expect(result, const Right(true));
      });

      final ServerFailure tServerFailure =
          ServerFailure(code: 404, message: 'Not Found');

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(mockUserRemoteDataSource.logout())
            .thenThrow(ServerException(code: 404, message: 'Not Found'));
        // Act
        final result = await repositoryImpl.logout();
        // Assert
        expect(result, Left(tServerFailure));
      });
    });
  });
}
