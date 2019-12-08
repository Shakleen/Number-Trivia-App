import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource source;
  MockSharedPreference mockSharedPreference;

  setUp(() {
    mockSharedPreference = MockSharedPreference();
    source = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreference,
    );
  });

  group('getLastNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_cached.json')),
    );

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        when(mockSharedPreference.getString(any))
            .thenReturn(fixture('trivia_cached.json'));

        final result = await source.getLastNumberTrivia();
        verify(mockSharedPreference.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        when(mockSharedPreference.getString(any)).thenReturn(null);
        final call = source.getLastNumberTrivia;
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });
}
