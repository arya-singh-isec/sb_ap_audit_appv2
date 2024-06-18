import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sb_ap_audit_appv2/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {
  @override
  Future<bool> get hasConnection => super.noSuchMethod(
        Invocation.getter(#hasConnection),
        returnValue: Future.value(true),
        returnValueForMissingStub: Future.value(true),
      );
}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  MockInternetConnectionChecker mockInternetConnectionChecker =
      MockInternetConnectionChecker();

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    // Understand Bad State: no method called for missing stub
    test('should invoke InternetConnectionChecker.hasConnection', () async {
      // Arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      // Act
      final result = await networkInfoImpl.isConnected;
      // Assert
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
