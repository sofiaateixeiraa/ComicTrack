import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic_collection_entry.dart';
import '../repositories/collection_repository.dart';

class GetCollectionEntryUseCase {
  final CollectionRepository _repository;
  GetCollectionEntryUseCase(this._repository);

  Future<Either<Failure, ComicCollectionEntry?>> call({
    required String userId,
    required String issueId,
  }) => _repository.getEntry(userId, issueId);
}
