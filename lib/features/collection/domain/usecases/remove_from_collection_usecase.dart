import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/collection_repository.dart';

/// remoção limpa leitura + favorito.
/// este use case executa a remoção após confirmação do utilizador.
class RemoveFromCollectionUseCase {
  final CollectionRepository _repository;
  RemoveFromCollectionUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String userId,
    required String issueId,
  }) async {
    return _repository.deleteEntry(userId, issueId);
  }
}
