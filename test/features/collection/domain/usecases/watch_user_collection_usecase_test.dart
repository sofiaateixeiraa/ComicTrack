import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/usecases/watch_user_collection_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

void main() {
  late MockCollectionRepository repository;
  late WatchUserCollectionUseCase usecase;

  const entry = ComicCollectionEntry(
    issueId: 'i1',
    seriesName: 'Batman',
    issueNumber: '1',
    ownershipStatus: OwnershipStatus.online,
  );

  setUp(() {
    repository = MockCollectionRepository();
    usecase = WatchUserCollectionUseCase(repository);
  });

  group('WatchUserCollectionUseCase', () {
    test('emite Right(List<ComicCollectionEntry>) inicial', () {
      final entries = [entry];
      when(
        () => repository.watchUserCollection(any()),
      ).thenAnswer((_) => Stream.value(Right(entries)));

      expect(usecase('u1'), emits(Right(entries)));
    });

    test('emite lista vazia quando a coleção está vazia', () {
      final entries = <ComicCollectionEntry>[];
      when(
        () => repository.watchUserCollection(any()),
      ).thenAnswer((_) => Stream.value(Right(entries)));

      expect(usecase('u1'), emits(Right(entries)));
    });

    test('emite novo valor quando a coleção muda (tempo real)', () {
      final updated = entry.copyWith(isFavorite: false);
      final initialList = [entry];
      final updatedList = [updated];
      when(() => repository.watchUserCollection(any())).thenAnswer(
        (_) => Stream.fromIterable([Right(initialList), Right(updatedList)]),
      );

      expect(
        usecase('u1'),
        emitsInOrder([Right(initialList), Right(updatedList)]),
      );
    });

    test('emite Left(Failure) em caso de erro na stream', () {
      const failure = Failure.repository(message: 'erro ao observar coleção');
      when(
        () => repository.watchUserCollection(any()),
      ).thenAnswer((_) => Stream.value(const Left(failure)));

      expect(usecase('u1'), emits(const Left(failure)));
    });
  });
}