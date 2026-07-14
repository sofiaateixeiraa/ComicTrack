import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/publisher.dart';
import 'package:comictrack/features/catalog/domain/usecases/get_publishers_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late GetPublishersUseCase usecase;

  const publishers = [
    Publisher(id: 'p1', name: 'Marvel'),
    Publisher(id: 'p2', name: 'DC Comics'),
  ];

  setUp(() {
    repository = MockCatalogRepository();
    usecase = GetPublishersUseCase(repository);
  });

  group('GetPublishersUseCase', () {
    test('sucesso devolve a lista de editoras', () async {
      when(() => repository.getPublishers()).thenAnswer((_) async => const Right(publishers));

      final result = await usecase();

      expect(result, const Right(publishers));
      verify(() => repository.getPublishers()).called(1);
    });

    test('lista vazia é devolvida tal e qual', () async {
      when(() => repository.getPublishers()).thenAnswer((_) async => const Right([]));

      final result = await usecase();

      result.match(
        (_) => fail('esperado Right'),
        (list) => expect(list, isEmpty),
      );
    });

    test('falha de rede é propagada', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(() => repository.getPublishers()).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('Failure.rateLimit da API externa é propagada', () async {
      const failure = Failure.rateLimit(retryAfterSeconds: 30);
      when(() => repository.getPublishers()).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}