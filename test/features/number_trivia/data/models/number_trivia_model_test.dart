import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

void main() {
  final NumberTriviaModel tNumberTrivia = NumberTriviaModel(
    number: 1,
    text: 'test',
  );

  test(
    "Should be a sub-class of NumberTrivia entity",
    () async {
      expect(tNumberTrivia, isA<NumberTrivia>());
    },
  );
}
