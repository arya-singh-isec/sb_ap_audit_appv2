import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/partner_model.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/partner.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tPartnerModels = [
    PartnerModel(id: '1', name: 'Partner A'),
    PartnerModel(id: '2', name: 'Partner B')
  ];

  test('should be a subclass of Partner entity', () async {
    // Assert
    expect(tPartnerModels.first, isA<Partner>());
  });

  group('fromJson', () {
    test('should return a valid model upon successful response', () async {
      // Arrange
      final Map<String, dynamic> jsonMapOnSuccess =
          json.decode(fixture('get_partners_success.json'));
      // Act
      final result = (jsonMapOnSuccess['data'] as List)
          .map((jsonMap) => PartnerModel.fromJson(jsonMap))
          .toList();
      // Assert
      expect(result.length, equals(tPartnerModels.length));
      for (int i = 0; i < result.length; i++) {
        expect(result[i], tPartnerModels[i]);
      }
    });
  });
}
