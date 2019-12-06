import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final NumberTriviaModel tNumberTrivia = NumberTriviaModel(
    number: 1,
    text: 'Test Text',
  );

  test(
    "Should be a sub-class of NumberTrivia entity",
    () async {
      expect(tNumberTrivia, isA<NumberTrivia>());
    },
  );
  group('fromJson', () {
    test(
      'Should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
        final result = NumberTriviaModel.fromJson(jsonMap);
        expect(result, tNumberTrivia);
      },
    );
  });
}
