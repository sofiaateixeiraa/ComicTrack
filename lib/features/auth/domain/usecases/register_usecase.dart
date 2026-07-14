import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    String? name,
  }) => _repository.register(email: email, password: password, name: name);
}
