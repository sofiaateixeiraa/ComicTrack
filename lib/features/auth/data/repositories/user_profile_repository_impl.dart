import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/firestore_user_profile_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource _dataSource;
  UserProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Unit>> createProfile(UserProfile profile) =>
      _dataSource.createProfile(profile);

  @override
  Future<Either<Failure, UserProfile?>> getProfile(String uid) =>
      _dataSource.getProfile(uid);

  @override
  Stream<Either<Failure, UserProfile?>> watchProfile(String uid) =>
      _dataSource.watchProfile(uid);

  @override
  Future<Either<Failure, Unit>> updatePhoto(String uid, String photoBase64) =>
      _dataSource.updatePhoto(uid, photoBase64);

  @override
  Future<Either<Failure, Unit>> updateName(String uid, String name) =>
      _dataSource.updateName(uid, name);

  @override
  Future<Either<Failure, Unit>> updateEmail(String uid, String email) =>
      _dataSource.updateEmail(uid, email);
}
