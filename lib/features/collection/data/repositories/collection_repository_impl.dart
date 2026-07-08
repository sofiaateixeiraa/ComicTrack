import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/repositories/collection_repository.dart';
import '../datasources/firestore_datasource.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionDataSource _dataSource;
  CollectionRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<ComicCollectionEntry>>> watchUserCollection(
      String userId) =>
      _dataSource.watchCollection(userId);

  @override
  Future<Either<Failure, ComicCollectionEntry?>> getEntry(
      String userId, String issueId) =>
      _dataSource.getEntry(userId, issueId);

  @override
  Future<Either<Failure, Unit>> saveEntry(
      String userId, ComicCollectionEntry entry) =>
      _dataSource.saveEntry(userId, entry);

  @override
  Future<Either<Failure, Unit>> deleteEntry(
      String userId, String issueId) =>
      _dataSource.deleteEntry(userId, issueId);
}