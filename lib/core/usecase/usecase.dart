import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SucessType, Parameter> {
  // call function from fpdart
  Future<Either<Failure, SucessType>> call(Parameter parameter);
}
//use case are supposed to do only one task.
