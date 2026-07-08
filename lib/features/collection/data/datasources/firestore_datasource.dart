import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/entities/ownership_status.dart';
import '../../domain/entities/reading_status.dart';

abstract interface class CollectionDataSource {
  Stream<Either<Failure, List<ComicCollectionEntry>>> watchCollection(String userId);
  Future<Either<Failure, ComicCollectionEntry?>> getEntry(String userId, String issueId);
  Future<Either<Failure, Unit>> saveEntry(String userId, ComicCollectionEntry entry);
  Future<Either<Failure, Unit>> deleteEntry(String userId, String issueId);
}

class FirestoreCollectionDataSource implements CollectionDataSource {
  final FirebaseFirestore _firestore;
  FirestoreCollectionDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collectionRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('collection');

  @override
  Stream<Either<Failure, List<ComicCollectionEntry>>> watchCollection(
      String userId) {
    return _collectionRef(userId).snapshots().map((snapshot) {
      try {
        final entries = snapshot.docs
            .map((doc) => _fromFirestore(doc.data()))
            .toList();
        return Right(entries);
      } catch (e) {
        return Left(Failure.repository(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, ComicCollectionEntry?>> getEntry(
      String userId, String issueId) async {
    try {
      final doc = await _collectionRef(userId).doc(issueId).get();
      if (!doc.exists || doc.data() == null) return const Right(null);
      return Right(_fromFirestore(doc.data()!));
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveEntry(
      String userId, ComicCollectionEntry entry) async {
    try {
      await _collectionRef(userId).doc(entry.issueId).set(
        _toFirestore(entry),
        SetOptions(merge: true),
      );
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEntry(
      String userId, String issueId) async {
    try {
      await _collectionRef(userId).doc(issueId).delete();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.repository(message: e.toString()));
    }
  }

  // --- Serialização ---

  Map<String, dynamic> _toFirestore(ComicCollectionEntry entry) => {
        'issueId': entry.issueId,
        'seriesName': entry.seriesName,
        'issueNumber': entry.issueNumber,
        'coverUrl': entry.coverUrl,
        'ownershipStatus': entry.ownershipStatus.name,
        'readingStatus': entry.readingStatus?.name,
        'isFavorite': entry.isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  ComicCollectionEntry _fromFirestore(Map<String, dynamic> data) =>
      ComicCollectionEntry(
        issueId: data['issueId'] as String,
        seriesName: data['seriesName'] as String,
        issueNumber: data['issueNumber'] as String,
        coverUrl: data['coverUrl'] as String?,
        ownershipStatus: OwnershipStatus.values.byName(
          data['ownershipStatus'] as String,
        ),
        readingStatus: data['readingStatus'] != null
            ? ReadingStatus.values.byName(data['readingStatus'] as String)
            : null,
        isFavorite: data['isFavorite'] as bool? ?? false,
      );
}