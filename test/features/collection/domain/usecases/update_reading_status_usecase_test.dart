import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/entities/reading_status.dart';
import 'package:comictrack/features/collection/domain/usecases/update_reading_status_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

class _FakeComicCollectionEntry extends Fake implements ComicCollectionEntry {}

void main() {
  late MockCollectionRepository repository;
  late UpdateReadingStatusUseCase usecase;

  setUpAll(() {
    registerFallbackValue(_FakeComicCollectionEntry());
  });

  setUp(() {
    repository = MockCollectionRepository();
    usecase = UpdateReadingStatusUseCase(repository);
  });

  ComicCollectionEntry entryWith({
    required OwnershipStatus ownershipStatus,
    ReadingStatus? readingStatus,
    bool isFavorite = false,
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

  group('UpdateReadingStatusUseCase', () {
    test('getEntry falha propaga Left sem chamar saveEntry', () async {
      const failure = Failure.repository(message: 'falha ao ler entrada');
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result, const Left(failure));
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('entrada inexistente devolve Failure.businessRule', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f, isA<BusinessRuleFailure>()),
        (_) => fail('esperado Left'),
      );
    });

    test('ownershipStatus = wishlist devolve Failure.businessRule', () async {
      final current = entryWith(ownershipStatus: OwnershipStatus.wishlist);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result.isLeft(), isTrue);
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('ownershipStatus = none devolve Failure.businessRule', () async {
      final current = entryWith(ownershipStatus: OwnershipStatus.none);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result.isLeft(), isTrue);
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('ownershipStatus = online permite mudar o readingStatus', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.wantToRead,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result, Right(current.copyWith(readingStatus: ReadingStatus.reading)));
      verify(() => repository.saveEntry('u1', current.copyWith(readingStatus: ReadingStatus.reading)))
          .called(1);
    });

    test('ownershipStatus = physical permite mudar o readingStatus', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.physical,
        readingStatus: ReadingStatus.wantToRead,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.read);

      expect(result, Right(current.copyWith(readingStatus: ReadingStatus.read)));
    });

    test('mudar para wantToRead remove automaticamente o favorito', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.reading,
        isFavorite: true,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: ReadingStatus.wantToRead,
      );

      final expected = current.copyWith(readingStatus: ReadingStatus.wantToRead, isFavorite: false);
      expect(result, Right(expected));
    });

    test('mudar para reading/read preserva o isFavorite atual', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.wantToRead,
        isFavorite: false,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      result.match(
        (_) => fail('esperado Right'),
        (updated) => expect(updated.isFavorite, isFalse),
      );
    });

    test('saveEntry falha propaga Left', () async {
      const failure = Failure.repository(message: 'falha ao gravar');
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.wantToRead,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: ReadingStatus.reading);

      expect(result, const Left(failure));
    });
  });
}