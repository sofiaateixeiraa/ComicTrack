import '../entities/comic_collection_entry.dart';
import '../repositories/collection_repository.dart';
import '../../../../core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

class WatchUserCollectionUseCase {
  final CollectionRepository _repository;
  WatchUserCollectionUseCase(this._repository);

  Stream<Either<Failure, List<ComicCollectionEntry>>> call(String userId) =>
      _repository.watchUserCollection(userId);
}
