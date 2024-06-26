import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/core/error/failures.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/partner.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_partners.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_partners_bloc.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_partners_event.dart';
import 'package:sb_ap_audit_appv2/features/selection/presentation/blocs/get_partners_state.dart';

class MockGetPartners extends Mock implements GetPartners {}

void main() {
  late GetPartnersBloc bloc;
  late GetPartners mockGetPartners;

  setUp(() {
    mockGetPartners = MockGetPartners();
    bloc = GetPartnersBloc(getPartners: mockGetPartners);
  });

  test('initial state should be PartnersEmpty', () async {
    // Assert
    expect(bloc.state, equals(PartnersEmpty()));
  });

  const List<Partner> tPartners = [
    Partner(id: '1', name: 'Partner A'),
    Partner(id: '2', name: 'Partner B')
  ];

  test(
      'should return [PartnersLoading, PartnersLoaded] when fetch partners list is successful',
      () async {
    // Arrange
    when(mockGetPartners.execute())
        .thenAnswer((_) async => const Right(tPartners));
    // Assert Later
    final expected = [
      PartnersLoading(),
      const PartnersLoaded(partners: tPartners)
    ];
    expectLater(bloc.stream, emitsInOrder(expected));
    // Act
    bloc.add(FetchPartnersList());
    await untilCalled(mockGetPartners.execute());
  });

  test(
      'should return [PartnersLoading, PartnersError] when fetch partners list is unsuccessful',
      () async {
    // Arrange
    when(mockGetPartners.execute()).thenAnswer(
        (_) async => Left(ServerFailure(code: 404, message: 'Not Found!')));
    // Assert Later
    final expected = [
      PartnersLoading(),
      const PartnersError(message: 'Not Found!')
    ];
    expectLater(bloc.stream, emitsInOrder(expected));
    // Act
    bloc.add(FetchPartnersList());
  });
}
