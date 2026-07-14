import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/collection/domain/usecases/remove_from_collection_usecase.dart';

import '../../../../helpers/mock_collection_repository.dart';

void main() {
  late MockCollectionRepository repository;
  late RemoveFromCollectionUseCase usecase;

  setUp(() {
    repository = MockCollectionRepository();
    usecase = RemoveFromCollectionUseCase(repository);
  });

  group('RemoveFromCollectionUseCase', () {
    test('sucesso chama deleteEntry(userId, issueId) e devolve Right(unit)', () async {
      when(
        () => repository.deleteEntry(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(userId: 'u1', issueId: 'i1');

      expect(result, const Right(unit));
      verify(() => repository.deleteEntry('u1', 'i1')).called(1);
    });

    test('erro do repositório é propagado tal e qual', () async {
      const failure = Failure.repository(message: 'falha ao remover entrada');
      when(
        () => repository.deleteEntry(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(userId: 'u1', issueId: 'i1');

      expect(result, const Left(failure));
    });
  });
}
