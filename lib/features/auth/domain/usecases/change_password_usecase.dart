import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// reautentica com a password atual antes de definir a nova.
class ChangePasswordUseCase {
  final AuthRepository _repository;
  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String currentPassword,
    required String newPassword,
  }) => _repository.changePassword(currentPassword: currentPassword, newPassword: newPassword);
}
