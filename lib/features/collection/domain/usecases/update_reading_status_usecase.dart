import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic_collection_entry.dart';
import '../entities/ownership_status.dart';
import '../entities/reading_status.dart';
import '../repositories/collection_repository.dart';

/// readingStatus só é editável quando posse = online/físico.
/// voltar a "Quero ler" remove automaticamente o favorito.
class UpdateReadingStatusUseCase {
  final CollectionRepository _repository;
  UpdateReadingStatusUseCase(this._repository);

  Future<Either<Failure, ComicCollectionEntry>> call({
    required String userId,
    required String issueId,
    required ReadingStatus newStatus,
  }) async {
    final currentResult = await _repository.getEntry(userId, issueId);
    return currentResult.fold((f) => Left(f), (current) async {
      if (current == null ||
          (current.ownershipStatus != OwnershipStatus.online &&
              current.ownershipStatus != OwnershipStatus.physical)) {
        return Left(
          const Failure.businessRule(
            message: 'Estado de leitura só disponível para Online/Físico.',
          ),
        );
      }

      // se voltar a "Quero ler", favorito é removido.
      final newFavorite = newStatus == ReadingStatus.wantToRead
          ? false
          : current.isFavorite;

      final updated = current.copyWith(
        readingStatus: newStatus,
        isFavorite: newFavorite,
      );

      final saveResult = await _repository.saveEntry(userId, updated);
      return saveResult.fold((f) => Left(f), (_) => Right(updated));
    });
  }
}
