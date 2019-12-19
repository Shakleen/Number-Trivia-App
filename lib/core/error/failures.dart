import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  
  Failure({this.properties = const <dynamic>[]});
}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [properties];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [properties];
}