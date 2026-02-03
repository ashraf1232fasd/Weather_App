import 'package:equatable/equatable.dart';

/// Abstract base class for all failures.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure from the remote data source.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure from the local data source.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}