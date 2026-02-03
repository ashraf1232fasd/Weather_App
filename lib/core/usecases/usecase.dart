import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Base interface for all business logic use cases.
abstract class UseCase<Type, Params> {
  /// Executes the use case logic.
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case requires no parameters.
class NoParams {}