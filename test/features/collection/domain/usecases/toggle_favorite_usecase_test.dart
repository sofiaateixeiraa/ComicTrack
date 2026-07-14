import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/entities/reading_status.dart';
import 'package:comictrack/features/collection/domain/usecases/toggle_favorite_usecase.dart';
import 'package:comictrack/core/error/failures.dart';
import '../../../helpers/mock_collection_repository.dart';

void main() {
  late ToggleFavoriteUseCase sut;
  late MockCollectionRepository mockRepo;

  const userId = 'user123';
  const issueId = 'issue456';
  const seriesName = 'Sandman';
  const issueNumber = '8';

  setUp(() {
    mockRepo = MockCollectionRepository();
    sut = ToggleFavoriteUseCase(mockRepo);
  });

  group('ToggleFavoriteUseCase', () {
    // Regra 4: favorito permitido quando leitura = "A ler" ou "Lido"
    test('permite favoritar quando leitura = reading (Regra 4)', () async {
      const entry = ComicCollectionEntry(
        issueId: issueId,
        seriesName: seriesName,
        issueNumber: issueNumber,
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.reading,
        isFavorite: false,
      );
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(entry));
      when(() => mockRepo.saveEntry(userId, entry.copyWith(isFavorite: true)))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(userId: userId, issueId: issueId, isFavorite: true);
      expect(result.isRight(), true);
      expect(result.getRight().toNullable()?.isFavorite, true);
    });

    test('permite favoritar quando leitura = read (Regra 4)', () async {
      const entry = ComicCollectionEntry(
        issueId: issueId,
        seriesName: seriesName,
        issueNumber: issueNumber,
        ownershipStatus: OwnershipStatus.physical,
        readingStatus: ReadingStatus.read,
        isFavorite: false,
      );
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(entry));
      when(() => mockRepo.saveEntry(userId, entry.copyWith(isFavorite: true)))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(userId: userId, issueId: issueId, isFavorite: true);
      expect(result.isRight(), true);
    });

    // Regra 4: NÃO pode favoritar quando leitura = wantToRead
    test('rejeita favoritar quando leitura = wantToRead (Regra 4)', () async {
      const entry = ComicCollectionEntry(
        issueId: issueId,
        seriesName: seriesName,
        issueNumber: issueNumber,
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.wantToRead,
        isFavorite: false,
      );
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(entry));

      final result = await sut(userId: userId, issueId: issueId, isFavorite: true);
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<BusinessRuleFailure>()),
        (_) => fail('Devia ter falhado'),
      );
      verifyNever(() => mockRepo.saveEntry(any(), any()));
    });

    // Rejeita quando issue não está na coleção
    test('rejeita quando issue não existe na coleção', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(null));

      final result = await sut(userId: userId, issueId: issueId, isFavorite: true);
      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<NotFoundFailure>()),
        (_) => fail('Devia ter falhado'),
      );
    });

    // Permite desfavoritar mesmo quando leitura = wantToRead (isFavorite = false → sem condição)
    test('permite desfavoritar em qualquer estado', () async {
      const entry = ComicCollectionEntry(
        issueId: issueId,
        seriesName: seriesName,
        issueNumber: issueNumber,
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.wantToRead,
        isFavorite: true, // estado inconsistente a resolver
      );
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(entry));
      when(() => mockRepo.saveEntry(userId, entry.copyWith(isFavorite: false)))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(userId: userId, issueId: issueId, isFavorite: false);
      expect(result.isRight(), true);
    });
  });
}