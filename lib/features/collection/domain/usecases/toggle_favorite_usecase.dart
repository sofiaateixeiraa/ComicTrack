import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic_collection_entry.dart';
import '../repositories/collection_repository.dart';

/// favorito só ativo se leitura = "A ler" ou "Lido".
class ToggleFavoriteUseCase {
  final CollectionRepository _repository;
  ToggleFavoriteUseCase(this._repository);

  Future<Either<Failure, ComicCollectionEntry>> call({
    required String userId,
    required String issueId,
    required bool isFavorite,
  }) async {
    final currentResult = await _repository.getEntry(userId, issueId);
    return currentResult.fold((f) => Left(f), (current) async {
      if (current == null) {
        return Left(const Failure.notFound());
      }
      // só pode ser favorito se readingStatus = reading ou read.
      if (isFavorite && !current.canBeFavorite) {
        return Left(
          const Failure.businessRule(
            message:
                'Só é possível adicionar aos favoritos com estado de leitura "A ler" ou "Lido".',
          ),
        );
      }

      final updated = current.copyWith(isFavorite: isFavorite);
      final saveResult = await _repository.saveEntry(userId, updated);
      return saveResult.fold((f) => Left(f), (_) => Right(updated));
    });
  }
}
