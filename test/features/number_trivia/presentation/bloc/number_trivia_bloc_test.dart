import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      converter: mockConverter,
    );
  });

  test(
    'initial state should be empty',
    () {
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final String tNumberString = '1';
    final int tNumberParsed = 1;
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should call InputConverter to validate and convert string to an unsigned integer',
      () async {
        when(mockConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockConverter.stringToUnsignedInteger(any));
        verify(mockConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] state when input is invalid',
      () async {
        when(mockConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        final List expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });
}
