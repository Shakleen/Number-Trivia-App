import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when string represents an unsigned integer',
      () async {
        // Arrange
        final String str = "123";
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, Right(123));
      },
    );

    test(
      'should return failure when string is not an integer',
      () async {
        // Arrange
        final String str = "abc";
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  
    test(
      'should return failure when string is a negative integer',
      () async {
        // Arrange
        final String str = "-123";
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
