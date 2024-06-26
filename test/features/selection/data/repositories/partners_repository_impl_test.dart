import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/exceptions.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/core/network/network_info.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/datasources/partners_remote_data_source.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/partner_model.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/repositories/partners_repository_impl.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/partner.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockPartnersRemoteDataSource extends Mock
    implements PartnersRemoteDataSource {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late PartnersRepositoryImpl repositoryImpl;
  late MockPartnersRemoteDataSource mockPartnersRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockPartnersRemoteDataSource = MockPartnersRemoteDataSource();
    repositoryImpl = PartnersRepositoryImpl(
        remoteDataSource: mockPartnersRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  const List<PartnerModel> tPartnerModels = [
    PartnerModel(id: '1', name: 'Partner A'),
    PartnerModel(id: '2', name: 'Partner B')
  ];

  const List<Partner> tPartners = tPartnerModels;

  group('when the device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return list of partners when the call to remote data source is successful',
        () async {
      // Arrange
      when(mockPartnersRemoteDataSource.getPartners())
          .thenAnswer((_) async => tPartnerModels);
      // Act
      final result = await repositoryImpl.getPartners();
      // Assert
      verify(mockPartnersRemoteDataSource.getPartners());
      expect(result, const Right(tPartners));
    });

    final tServerException = ServerException(code: 404, message: 'Not Found');
    final tServerFailure = ServerFailure(code: 404, message: 'Not Found');

    test(
        'should return a server failure when the call to remote data source is unsuccessful',
        () async {
      // Arrange
      when(mockPartnersRemoteDataSource.getPartners())
          .thenThrow(tServerException);
      // Act
      final result = await repositoryImpl.getPartners();
      // Assert
      expect(result, Left(tServerFailure));
    });
  });
}
