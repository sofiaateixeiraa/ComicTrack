import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class WatchUserProfileUseCase {
  final UserProfileRepository _repository;
  WatchUserProfileUseCase(this._repository);

  Stream<Either<Failure, UserProfile?>> call(String uid) =>
      _repository.watchProfile(uid);
}
