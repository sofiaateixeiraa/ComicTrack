import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/entities/reading_status.dart';
import 'package:comictrack/features/collection/domain/usecases/toggle_favorite_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

class _FakeComicCollectionEntry extends Fake implements ComicCollectionEntry {}

void main() {
  late MockCollectionRepository repository;
  late ToggleFavoriteUseCase usecase;

  setUpAll(() {
    registerFallbackValue(_FakeComicCollectionEntry());
  });

  setUp(() {
    repository = MockCollectionRepository();
    usecase = ToggleFavoriteUseCase(repository);
  });

  ComicCollectionEntry entryWith({
    ReadingStatus? readingStatus,
    bool isFavorite = false,
    OwnershipStatus ownershipStatus = OwnershipStatus.online,
  }) {
    return ComicCollectionEntry(
      issueId: 'i1',
      seriesName: 'Batman',
      issueNumber: '1',
      ownershipStatus: ownershipStatus,
      readingStatus: readingStatus,
      isFavorite: isFavorite,
    );
  }

  group('ToggleFavoriteUseCase', () {
    test('getEntry falha propaga Left sem chamar saveEntry', () async {
      const failure = Failure.repository(message: 'falha ao ler entrada');
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      expect(result, const Left(failure));
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('entrada inexistente devolve Failure.notFound sem chamar saveEntry', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      expect(result, const Left(Failure.notFound()));
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('marcar como favorito com readingStatus = reading tem sucesso', () async {
      final current = entryWith(readingStatus: ReadingStatus.reading);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      final expected = current.copyWith(isFavorite: true);
      expect(result, Right(expected));
      verify(() => repository.saveEntry('u1', expected)).called(1);
    });

    test('marcar como favorito com readingStatus = read tem sucesso', () async {
      final current = entryWith(readingStatus: ReadingStatus.read);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      final expected = current.copyWith(isFavorite: true);
      expect(result, Right(expected));
    });

    test('marcar como favorito com readingStatus = wantToRead devolve Failure.businessRule', () async {
      final current = entryWith(readingStatus: ReadingStatus.wantToRead);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      expect(result.isLeft(), isTrue);
      result.match((f) => expect(f, isA<BusinessRuleFailure>()), (_) => fail('esperado Left'));
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('marcar como favorito com readingStatus nulo (wishlist/none) devolve Failure.businessRule', () async {
      final current = entryWith(
        readingStatus: null,
        ownershipStatus: OwnershipStatus.wishlist,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      expect(result.isLeft(), isTrue);
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('desmarcar favorito é sempre permitido, mesmo com readingStatus = wantToRead', () async {
      final current = entryWith(readingStatus: ReadingStatus.wantToRead, isFavorite: false);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: false);

      expect(result, Right(current.copyWith(isFavorite: false)));
    });

    test('saveEntry falha propaga Left', () async {
      const failure = Failure.repository(message: 'falha ao gravar');
      final current = entryWith(readingStatus: ReadingStatus.reading);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      expect(result, const Left(failure));
    });

    test('valor devolvido tem isFavorite atualizado e restantes campos inalterados', () async {
      final current = entryWith(readingStatus: ReadingStatus.read, isFavorite: false);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', isFavorite: true);

      result.match((_) => fail('esperado Right'), (updated) {
        expect(updated.isFavorite, isTrue);
        expect(updated.issueId, current.issueId);
        expect(updated.seriesName, current.seriesName);
        expect(updated.readingStatus, current.readingStatus);
        expect(updated.ownershipStatus, current.ownershipStatus);
      });
    });
  });
}
