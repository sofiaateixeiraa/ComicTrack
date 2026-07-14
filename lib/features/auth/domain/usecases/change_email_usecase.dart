import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// reautentica com a password atual e envia um email de confirmação para o novo.
class ChangeEmailUseCase {
  final AuthRepository _repository;
  ChangeEmailUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String currentPassword,
    required String newEmail,
  }) => _repository.changeEmail(
    currentPassword: currentPassword,
    newEmail: newEmail,
  );
}
