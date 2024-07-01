import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sb_ap_audit_appv2/features/selection/data/models/team_member_model.dart';
import 'package:sb_ap_audit_appv2/features/selection/domain/entities/team_member.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const List<TeamMemberModel> tTeamMemberModels = [
    TeamMemberModel(id: '1', name: 'TeamMember A', supervisorId: '23'),
    TeamMemberModel(id: '2', name: 'TeamMember B', supervisorId: '54')
  ];

  test('should be a subclass of TeamMember entity', () async {
    // Assert
    expect(tTeamMemberModels.first, isA<TeamMember>());
  });

  group('fromJson', () {
    test('should return a valid model upon successful response', () async {
      // Arrange
      final Map<String, dynamic> jsonMapOnSuccess =
          json.decode(fixture('get_team_members_success.json'));
      // Act
      final result = (jsonMapOnSuccess['data'] as List)
          .map((jsonMap) => TeamMemberModel.fromJson(jsonMap))
          .toList();
      // Assert
      expect(result.length, equals(tTeamMemberModels.length));
      for (int i = 0; i < result.length; i++) {
        expect(result[i], tTeamMemberModels[i]);
      }
    });
  });

  group('toJson', () {
    test('should return a valid conversion to json map', () async {
      // Act
      final result = tTeamMemberModels.first.toJson();
      // Assert
      expect(result, {"id": '1', "name": 'TeamMember A', "supervisorId": '23'});
    });
  });
}
