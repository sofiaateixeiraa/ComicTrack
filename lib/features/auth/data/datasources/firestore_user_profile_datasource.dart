import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';

abstract interface class UserProfileDataSource {
  Future<Either<Failure, Unit>> createProfile(UserProfile profile);
  Future<Either<Failure, UserProfile?>> getProfile(String uid);
  Stream<Either<Failure, UserProfile?>> watchProfile(String uid);
  Future<Either<Failure, Unit>> updatePhoto(String uid, String photoBase64);
  Future<Either<Failure, Unit>> updateName(String uid, String name);
  Future<Either<Failure, Unit>> updateEmail(String uid, String email);
}

class FirestoreUserProfileDataSource implements UserProfileDataSource {
  final FirebaseFirestore _firestore;
  FirestoreUserProfileDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _docRef(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Future<Either<Failure, Unit>> createProfile(UserProfile profile) async {
    try {
      await _docRef(
        profile.uid,
      ).set(_toFirestore(profile), SetOptions(merge: true));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getProfile(String uid) async {
    try {
      final doc = await _docRef(uid).get();
      if (!doc.exists || doc.data() == null) return const Right(null);
      return Right(_fromFirestore(uid, doc.data()!));
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, UserProfile?>> watchProfile(String uid) {
    return _docRef(uid).snapshots().map((doc) {
      try {
        if (!doc.exists || doc.data() == null) return const Right(null);
        return Right(_fromFirestore(uid, doc.data()!));
      } catch (e) {
        return Left(Failure.repository(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePhoto(
    String uid,
    String photoBase64,
  ) async {
    try {
      await _docRef(
        uid,
      ).set({'photoBase64': photoBase64}, SetOptions(merge: true));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateName(String uid, String name) async {
    try {
      await _docRef(uid).set({'name': name}, SetOptions(merge: true));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmail(String uid, String email) async {
    try {
      await _docRef(uid).set({'email': email}, SetOptions(merge: true));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  Map<String, dynamic> _toFirestore(UserProfile profile) => {
    'email': profile.email,
    'name': profile.name,
    'photoBase64': profile.photoBase64,
    'createdAt': Timestamp.fromDate(profile.createdAt),
  };

  UserProfile _fromFirestore(String uid, Map<String, dynamic> data) =>
      UserProfile(
        uid: uid,
        email: data['email'] as String? ?? '',
        name: data['name'] as String? ?? '',
        photoBase64: data['photoBase64'] as String?,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}
