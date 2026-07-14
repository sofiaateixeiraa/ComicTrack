import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// força a app a ir buscar o estado mais recente do utilizador ao firebase.
class ReloadCurrentUserUseCase {
  final AuthRepository _repository;
  ReloadCurrentUserUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.reloadCurrentUser();
}
