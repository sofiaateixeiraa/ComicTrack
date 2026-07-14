import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/entities/comic_collection_entry.dart';
import 'package:comictrack/features/collection/domain/entities/ownership_status.dart';
import 'package:comictrack/features/collection/domain/usecases/get_collection_entry_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

void main() {
  late MockCollectionRepository repository;
  late GetCollectionEntryUseCase usecase;

  const entry = ComicCollectionEntry(
    issueId: 'i1',
    seriesName: 'Batman',
    issueNumber: '1',
    ownershipStatus: OwnershipStatus.online,
  );

  setUp(() {
    repository = MockCollectionRepository();
    usecase = GetCollectionEntryUseCase(repository);
  });

  group('GetCollectionEntryUseCase', () {
    test('sucesso devolve a entrada existente', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(entry));

      final result = await usecase(userId: 'u1', issueId: 'i1');

      expect(result, const Right(entry));
      verify(() => repository.getEntry('u1', 'i1')).called(1);
    });

    test('issue ainda não está na coleção devolve Right(null)', () async {
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Right(null));

      final result = await usecase(userId: 'u1', issueId: 'i1');

      expect(result, const Right(null));
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.repository(message: 'falha ao ler entrada');
      when(() => repository.getEntry(any(), any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1');

      expect(result, const Left(failure));
    });
  });
}