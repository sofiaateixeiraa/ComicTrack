import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _repository;
  SendEmailVerificationUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.sendEmailVerification();
}
