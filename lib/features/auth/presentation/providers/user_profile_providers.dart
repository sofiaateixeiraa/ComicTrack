import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/firestore_user_profile_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/usecases/create_user_profile_usecase.dart';
import '../../domain/usecases/ensure_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_name_usecase.dart';
import '../../domain/usecases/update_profile_photo_usecase.dart';
import '../../domain/usecases/watch_user_profile_usecase.dart';
import 'auth_providers.dart';
part 'user_profile_providers.g.dart';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) =>
    UserProfileRepositoryImpl(FirestoreUserProfileDataSource());

@riverpod
CreateUserProfileUseCase createUserProfile(Ref ref) =>
    CreateUserProfileUseCase(ref.watch(userProfileRepositoryProvider));

@riverpod
EnsureUserProfileUseCase ensureUserProfile(Ref ref) =>
    EnsureUserProfileUseCase(ref.watch(userProfileRepositoryProvider));

@riverpod
UpdateProfilePhotoUseCase updateProfilePhoto(Ref ref) =>
    UpdateProfilePhotoUseCase(ref.watch(userProfileRepositoryProvider));

@riverpod
UpdateProfileNameUseCase updateProfileName(Ref ref) =>
    UpdateProfileNameUseCase(ref.watch(userProfileRepositoryProvider));

/// stream reativo do perfil do utilizador atual.
@riverpod
Stream<Either<Failure, UserProfile?>> userProfile(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const Right(null));
  final useCase = WatchUserProfileUseCase(
    ref.watch(userProfileRepositoryProvider),
  );
  return useCase(user.uid);
}
