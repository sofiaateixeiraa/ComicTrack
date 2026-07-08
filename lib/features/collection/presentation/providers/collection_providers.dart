import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/entities/comic_collection_entry.dart';
import '../../domain/entities/ownership_status.dart';
import '../../domain/entities/reading_status.dart';
import '../../domain/repositories/collection_repository.dart';
import '../../domain/usecases/update_ownership_status_usecase.dart';
import '../../domain/usecases/update_reading_status_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/remove_from_collection_usecase.dart';
import '../../domain/usecases/watch_user_collection_usecase.dart';
import '../../domain/usecases/get_collection_entry_usecase.dart';
part 'collection_providers.g.dart';

// --- Infra ---

@riverpod
CollectionRepository collectionRepository(Ref ref) =>
    CollectionRepositoryImpl(FirestoreCollectionDataSource());

// --- Use cases ---

@riverpod
UpdateOwnershipStatusUseCase updateOwnershipStatus(Ref ref) =>
    UpdateOwnershipStatusUseCase(ref.watch(collectionRepositoryProvider));

@riverpod
UpdateReadingStatusUseCase updateReadingStatus(Ref ref) =>
    UpdateReadingStatusUseCase(ref.watch(collectionRepositoryProvider));

@riverpod
ToggleFavoriteUseCase toggleFavorite(Ref ref) =>
    ToggleFavoriteUseCase(ref.watch(collectionRepositoryProvider));

@riverpod
RemoveFromCollectionUseCase removeFromCollection(Ref ref) =>
    RemoveFromCollectionUseCase(ref.watch(collectionRepositoryProvider));

// --- Estado da coleção (stream reativo) ---

/// Stream de toda a coleção do utilizador atual.
@riverpod
Stream<Either<Failure, List<ComicCollectionEntry>>> userCollection(
    Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const Right([]));
  final useCase = WatchUserCollectionUseCase(ref.watch(collectionRepositoryProvider));
  return useCase(user.uid);
}

/// Entrada individual de um issue na coleção (null = não está na coleção).
@riverpod
Future<ComicCollectionEntry?> collectionEntry(
    Ref ref, String issueId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final useCase = GetCollectionEntryUseCase(ref.watch(collectionRepositoryProvider));
  final result = await useCase(userId: user.uid, issueId: issueId);
  return result.fold((_) => null, (entry) => entry);
}