import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/entities/reading_status.dart';
import 'package:comictrack/features/collection/domain/usecases/update_ownership_status_usecase.dart';
import 'package:comictrack/core/error/failures.dart';
import '../../../helpers/mock_collection_repository.dart';

void main() {
  late UpdateOwnershipStatusUseCase sut;
  late MockCollectionRepository mockRepo;

  const userId = 'user123';
  const issueId = 'issue456';
  const seriesName = 'Sandman';
  const issueNumber = '8';

  setUp(() {
    mockRepo = MockCollectionRepository();
    sut = UpdateOwnershipStatusUseCase(mockRepo);
  });

  group('UpdateOwnershipStatusUseCase', () {
    // Regra 6: remover da coleção apaga o documento
    test('ao mudar para none, deve apagar a entrada (Regra 6)', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => Right(const ComicCollectionEntry(
                issueId: issueId,
                seriesName: seriesName,
                issueNumber: issueNumber,
                ownershipStatus: OwnershipStatus.online,
                readingStatus: ReadingStatus.reading,
                isFavorite: true,
              )));
      when(() => mockRepo.deleteEntry(userId, issueId))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(
        userId: userId,
        issueId: issueId,
        newStatus: OwnershipStatus.none,
      );

      expect(result.isRight(), true);
      expect(result.getRight().toNullable(), null); // entrada removida
      verify(() => mockRepo.deleteEntry(userId, issueId)).called(1);
      verifyNever(() => mockRepo.saveEntry(any(), any()));
    });

    // Regra 2 + 5: wishlist limpa readingStatus e favorito
    test('ao mudar para wishlist, readingStatus fica null e isFavorite = false (Regras 2 e 5)', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => Right(const ComicCollectionEntry(
                issueId: issueId,
                seriesName: seriesName,
                issueNumber: issueNumber,
                ownershipStatus: OwnershipStatus.online,
                readingStatus: ReadingStatus.read,
                isFavorite: true,
              )));

      const expectedEntry = ComicCollectionEntry(
        issueId: issueId,
        seriesName: seriesName,
        issueNumber: issueNumber,
        ownershipStatus: OwnershipStatus.wishlist,
        readingStatus: null,
        isFavorite: false,
      );

      when(() => mockRepo.saveEntry(userId, expectedEntry))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(
        userId: userId,
        issueId: issueId,
        newStatus: OwnershipStatus.wishlist,
      );

      expect(result.isRight(), true);
      final entry = result.getRight().toNullable();
      expect(entry?.readingStatus, null);
      expect(entry?.isFavorite, false);
    });

    // Quando muda de online para físico, mantém leitura e favorito
    test('ao mudar de online para físico, mantém estado de leitura e favorito', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => Right(const ComicCollectionEntry(
                issueId: issueId,
                seriesName: seriesName,
                issueNumber: issueNumber,
                ownershipStatus: OwnershipStatus.online,
                readingStatus: ReadingStatus.reading,
                isFavorite: true,
              )));

      when(() => mockRepo.saveEntry(any(), any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(
        userId: userId,
        issueId: issueId,
        newStatus: OwnershipStatus.physical,
      );

      expect(result.isRight(), true);
      final entry = result.getRight().toNullable();
      expect(entry?.ownershipStatus, OwnershipStatus.physical);
      expect(entry?.readingStatus, ReadingStatus.reading); // mantido
      expect(entry?.isFavorite, true); // mantido
    });

    // Novo issue (não estava na coleção) → começa em wantToRead, favorito false
    test('novo issue adicionado como online começa em wantToRead e sem favorito', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => const Right(null));

      when(() => mockRepo.saveEntry(any(), any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(
        userId: userId,
        issueId: issueId,
        newStatus: OwnershipStatus.online,
        seriesName: seriesName,
        issueNumber: issueNumber,
      );

      expect(result.isRight(), true);
      final entry = result.getRight().toNullable();
      expect(entry?.readingStatus, ReadingStatus.wantToRead);
      expect(entry?.isFavorite, false);
      expect(entry?.seriesName, seriesName);
      expect(entry?.issueNumber, issueNumber);
    });

    // Regra de metadata: não é possível criar uma entrada nova sem seriesName/issueNumber
    test('rejeita criar entrada nova sem seriesName/issueNumber', () async {
      when(() => mockRepo.getEntry(userId, issueId)).thenAnswer((_) async => const Right(null));

      final result = await sut(userId: userId, issueId: issueId, newStatus: OwnershipStatus.wishlist);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<BusinessRuleFailure>()),
        (_) => fail('Devia ter falhado'),
      );
      verifyNever(() => mockRepo.saveEntry(any(), any()));
    });

    test('propaga falha do repositório', () async {
      when(() => mockRepo.getEntry(userId, issueId))
          .thenAnswer((_) async => Left(const Failure.repository(message: 'Firestore error')));

      final result = await sut(
        userId: userId,
        issueId: issueId,
        newStatus: OwnershipStatus.online,
        seriesName: seriesName,
        issueNumber: issueNumber,
      );

      expect(result.isLeft(), true);
    });
  });
}