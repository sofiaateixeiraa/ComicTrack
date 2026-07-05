import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic_collection_entry.dart';
import '../entities/ownership_status.dart';
import '../entities/reading_status.dart';
import '../repositories/collection_repository.dart';

/// muda estado de posse e ajusta leitura/favorito em cascata.
/// remover da coleção limpa leitura e favorito.
class UpdateOwnershipStatusUseCase {
  final CollectionRepository _repository;
  UpdateOwnershipStatusUseCase(this._repository);

  Future<Either<Failure, ComicCollectionEntry?>> call({
    required String userId,
    required String issueId,
    required OwnershipStatus newStatus,
    // só usados quando o issue ainda não está na coleção.
    // obrigatórios nesse caso, ignorados se a entrada já existir.
    String? seriesName,
    String? issueNumber,
    String? coverUrl,
  }) async {
    // lê estado atual.
    final currentResult = await _repository.getEntry(userId, issueId);
    return currentResult.fold((failure) => Left(failure), (current) async {
      // remover da coleção limpa tudo.
      if (newStatus == OwnershipStatus.none) {
        final deleteResult = await _repository.deleteEntry(userId, issueId);
        return deleteResult.fold((f) => Left(f), (_) => const Right(null));
      }

      if (current == null && (seriesName == null || issueNumber == null)) {
        return Left(
          Failure.businessRule(
            message:
                'seriesName e issueNumber são obrigatórios ao adicionar um issue novo à coleção.',
          ),
        );
      }

      /* metadata desnormalizada: usa a fornecida se for uma entrada nova,
      ou preserva a já existente se o issue já estiver na coleção. */
      final effectiveSeriesName = current?.seriesName ?? seriesName!;
      final effectiveIssueNumber = current?.issueNumber ?? issueNumber!;
      final effectiveCoverUrl = current?.coverUrl ?? coverUrl;

      ComicCollectionEntry newEntry;

      if (newStatus == OwnershipStatus.wishlist) {
        // se na wishlist, readingStatus implícito (não vísivel).
        // favorito é removido se condição deixar de ser cumprida.
        newEntry = ComicCollectionEntry(
          issueId: issueId,
          seriesName: effectiveSeriesName,
          issueNumber: effectiveIssueNumber,
          coverUrl: effectiveCoverUrl,
          ownershipStatus: OwnershipStatus.wishlist,
          readingStatus: null,
          isFavorite: false,
        );
      } else {
        // online ou físico.
        final wasInCollection =
            current != null && current.ownershipStatus != OwnershipStatus.none;
        final wasReadable = current?.canHaveReadingStatus ?? false;

        ReadingStatus? newReading;
        bool newFavorite = false;

        if (wasInCollection && wasReadable) {
          // troca entre online e físico: mantém estado de leitura e favorito.
          newReading = current.readingStatus;
          newFavorite = current.isFavorite;
        } else {
          // vindo da wishlist ou none: começa em "Quero ler".
          newReading = ReadingStatus.wantToRead;
          newFavorite = false;
        }

        newEntry = ComicCollectionEntry(
          issueId: issueId,
          seriesName: effectiveSeriesName,
          issueNumber: effectiveIssueNumber,
          coverUrl: effectiveCoverUrl,
          ownershipStatus: newStatus,
          readingStatus: newReading,
          isFavorite: newFavorite,
        );
      }

      final saveResult = await _repository.saveEntry(userId, newEntry);
      return saveResult.fold((f) => Left(f), (_) => Right(newEntry));
    });
  }
}
