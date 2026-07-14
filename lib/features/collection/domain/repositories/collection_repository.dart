import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/comic_collection_entry.dart';

abstract interface class CollectionRepository {
  /// stream reativo de toda a coleção do utilizador.
  Stream<Either<Failure, List<ComicCollectionEntry>>> watchUserCollection(
    String userId,
  );

  /// leitura pontual de uma entrada específica.
  Future<Either<Failure, ComicCollectionEntry?>> getEntry(
    String userId,
    String issueId,
  );

  /// cria ou atualiza uma entrada na coleção.
  Future<Either<Failure, Unit>> saveEntry(
    String userId,
    ComicCollectionEntry entry,
  );

  /// remove uma entrada.
  Future<Either<Failure, Unit>> deleteEntry(String userId, String issueId);
}
