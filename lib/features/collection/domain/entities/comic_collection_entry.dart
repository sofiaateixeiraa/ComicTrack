import 'package:freezed_annotation/freezed_annotation.dart';
import 'ownership_status.dart';
import 'reading_status.dart';
part 'comic_collection_entry.freezed.dart';

/// representa o estado de um issue na coleção do utilizador.
/// implementa as regras de negócio do domínio através dos getters de validação.
@freezed
abstract class ComicCollectionEntry with _$ComicCollectionEntry {
  const ComicCollectionEntry._(); // necessário para métodos personalizados.

  const factory ComicCollectionEntry({
    required String issueId,
    required String seriesName,
    required String issueNumber,
    String? coverUrl,
    required OwnershipStatus ownershipStatus,
    // null quando ownershipStatus == none ou wishlist.
    ReadingStatus? readingStatus,
    @Default(false) bool isFavorite,
  }) = _ComicCollectionEntry;

  /// readingStatus só existe se posse = online ou físico.
  bool get canHaveReadingStatus =>
      ownershipStatus == OwnershipStatus.online ||
      ownershipStatus == OwnershipStatus.physical;

  /// favorito só disponível se readingStatus = a ler ou lido.
  bool get canBeFavorite =>
      readingStatus == ReadingStatus.reading ||
      readingStatus == ReadingStatus.read;

  /// wishlist implica "quero ler" (mas não visível).
  ReadingStatus? get effectiveReadingStatus {
    if (ownershipStatus == OwnershipStatus.wishlist) return ReadingStatus.wantToRead;
    return readingStatus;
  }
}