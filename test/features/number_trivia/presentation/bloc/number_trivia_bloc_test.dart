import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
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

    void setupInputConverterSuccess() {
      when(mockConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      'should call InputConverter to validate and convert string to an unsigned integer',
      () async {
        setupInputConverterSuccess();
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

    test('should get data from concrete use case', () async {
      setupInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully.',
      () {
        setupInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data fetching fails.',
      () {
        setupInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with proper error message.',
      () {
        setupInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForConcreteNumber', () {
    final NumberTrivia tNumberTrivia =
        NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from random use case', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully.',
      () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          Empty(),
          Loading(),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when data fetching fails.',
      () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with proper error message.',
      () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInAnyOrder(expected));
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
