import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/partner.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/repositories/partners_repository.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/usecases/get_partners.dart';

class MockPartnersRespository extends Mock implements PartnersRepository {}

void main() {
  late GetPartners usecase;
  late MockPartnersRespository mockPartnersRepository;

  setUp(() {
    mockPartnersRepository = MockPartnersRespository();
    usecase = GetPartners(repository: mockPartnersRepository);
  });

  const List<Partner> tPartners = [
    Partner(id: '1', name: 'Partner A'),
    Partner(id: '2', name: 'Partner B')
  ];

  test('should verify successful partners response', () async {
    // Arrange
    when(mockPartnersRepository.getPartners())
        .thenAnswer((_) async => const Right(tPartners));
    // Act
    final result = await usecase.execute();
    // Assert
    expect(result, const Right(tPartners));
    verify(mockPartnersRepository.getPartners());
    verifyNoMoreInteractions(mockPartnersRepository);
  });
}
