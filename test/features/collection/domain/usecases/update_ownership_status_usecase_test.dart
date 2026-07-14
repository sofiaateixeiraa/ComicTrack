import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/entities/reading_status.dart';
import 'package:comictrack/features/collection/domain/usecases/update_ownership_status_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

class _FakeComicCollectionEntry extends Fake implements ComicCollectionEntry {}

void main() {
  late MockCollectionRepository repository;
  late UpdateOwnershipStatusUseCase usecase;

  setUpAll(() {
    registerFallbackValue(_FakeComicCollectionEntry());
  });

  setUp(() {
    repository = MockCollectionRepository();
    usecase = UpdateOwnershipStatusUseCase(repository);
  });

  ComicCollectionEntry entryWith({
    required OwnershipStatus ownershipStatus,
    ReadingStatus? readingStatus,
    bool isFavorite = false,
    String? coverUrl,
  }) {
    return ComicCollectionEntry(
      issueId: 'i1',
      seriesName: 'Batman',
      issueNumber: '1',
      coverUrl: coverUrl,
      ownershipStatus: ownershipStatus,
      readingStatus: readingStatus,
      isFavorite: isFavorite,
    );
  }

  group('UpdateOwnershipStatusUseCase', () {
    test('getEntry falha propaga Left sem chamar deleteEntry/saveEntry', () async {
      const failure = Failure.repository(message: 'falha ao ler entrada');
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: OwnershipStatus.online,
        seriesName: 'Batman',
        issueNumber: '1',
      );

      expect(result, const Left(failure));
      verifyNever(() => repository.deleteEntry(any(), any()));
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('newStatus = none com entrada existente chama deleteEntry e devolve Right(null)', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.reading,
        isFavorite: true,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.deleteEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.none);

      expect(result, const Right(null));
      verify(() => repository.deleteEntry('u1', 'i1')).called(1);
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('newStatus = none e deleteEntry falha propaga Left', () async {
      const failure = Failure.repository(message: 'falha ao remover');
      final current = entryWith(ownershipStatus: OwnershipStatus.online);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.deleteEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.none);

      expect(result, const Left(failure));
    });

    test('newStatus = none sem entrada prévia ainda assim chama deleteEntry (idempotente)', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));
      when(() => repository.deleteEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.none);

      expect(result, const Right(null));
      verify(() => repository.deleteEntry('u1', 'i1')).called(1);
    });

    test('issue novo sem seriesName/issueNumber devolve Failure.businessRule', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.online);

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f, isA<BusinessRuleFailure>()),
        (_) => fail('esperado Left'),
      );
      verifyNever(() => repository.saveEntry(any(), any()));
    });

    test('issue novo com newStatus = wishlist cria entrada sem readingStatus e sem favorito', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: OwnershipStatus.wishlist,
        seriesName: 'Batman',
        issueNumber: '1',
      );

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.ownershipStatus, OwnershipStatus.wishlist);
        expect(entry.readingStatus, isNull);
        expect(entry.isFavorite, isFalse);
      });
    });

    test('issue novo com newStatus = online começa em "Quero ler" e sem favorito', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: OwnershipStatus.online,
        seriesName: 'Batman',
        issueNumber: '1',
      );

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.ownershipStatus, OwnershipStatus.online);
        expect(entry.readingStatus, ReadingStatus.wantToRead);
        expect(entry.isFavorite, isFalse);
      });
    });

    test('issue já existente preserva seriesName/issueNumber/coverUrl mesmo com novos valores passados', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.reading,
        coverUrl: 'https://cover/antiga.jpg',
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: OwnershipStatus.physical,
        seriesName: 'Nome Diferente',
        issueNumber: '99',
        coverUrl: 'https://cover/nova.jpg',
      );

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.seriesName, current.seriesName);
        expect(entry.issueNumber, current.issueNumber);
        expect(entry.coverUrl, current.coverUrl);
      });
    });

    test('transição wishlist -> online reinicia readingStatus para "Quero ler" e remove favorito', () async {
      final current = entryWith(ownershipStatus: OwnershipStatus.wishlist);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.online);

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.readingStatus, ReadingStatus.wantToRead);
        expect(entry.isFavorite, isFalse);
      });
    });

    test('transição online -> físico preserva readingStatus e isFavorite atuais', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.read,
        isFavorite: true,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.physical);

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.readingStatus, ReadingStatus.read);
        expect(entry.isFavorite, isTrue);
      });
    });

    test('transição online/físico -> wishlist limpa readingStatus e força isFavorite a false', () async {
      final current = entryWith(
        ownershipStatus: OwnershipStatus.online,
        readingStatus: ReadingStatus.reading,
        isFavorite: true,
      );
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.wishlist);

      result.match((_) => fail('esperado Right'), (entry) {
        expect(entry!.readingStatus, isNull);
        expect(entry.isFavorite, isFalse);
      });
    });

    test('saveEntry falha em qualquer transição válida propaga Left', () async {
      const failure = Failure.repository(message: 'falha ao gravar');
      final current = entryWith(ownershipStatus: OwnershipStatus.online);
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => Right(current));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1', newStatus: OwnershipStatus.physical);

      expect(result, const Left(failure));
    });

    test('coverUrl novo só é usado quando não existe entrada prévia', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));
      when(() => repository.saveEntry(any(), any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(
        userId: 'u1',
        issueId: 'i1',
        newStatus: OwnershipStatus.online,
        seriesName: 'Batman',
        issueNumber: '1',
        coverUrl: 'https://cover/nova.jpg',
      );

      result.match(
        (_) => fail('esperado Right'),
        (entry) => expect(entry!.coverUrl, 'https://cover/nova.jpg'),
      );
    });
  });
}