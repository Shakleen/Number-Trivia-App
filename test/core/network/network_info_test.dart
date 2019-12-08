import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker checker;

  setUp(() {
    checker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(checker);
  });

  group('Is connected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);

        when(checker.hasConnection).thenAnswer((_) async => tHasConnectionFuture);

        final bool result = await networkInfo.isConnected;
        verify(checker.hasConnection);
        expect(result, await tHasConnectionFuture);
      },
    );
  });
}
