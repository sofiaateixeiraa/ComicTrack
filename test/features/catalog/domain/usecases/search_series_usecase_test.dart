import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/paginated_result.dart';
import 'package:comictrack/features/catalog/domain/entities/series.dart';
import 'package:comictrack/features/catalog/domain/usecases/search_series_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late SearchSeriesUseCase usecase;

  const series = Series(id: 's1', title: 'Batman', publisher: 'DC Comics');

  setUp(() {
    repository = MockCatalogRepository();
    usecase = SearchSeriesUseCase(repository);
  });

  group('SearchSeriesUseCase', () {
    test('sucesso passa a query sem nextUrl', () async {
      when(
        () => repository.searchSeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer(
        (_) async => const Right(PaginatedResult(items: [series], total: 1)),
      );

      await usecase('batman');

      verify(() => repository.searchSeries('batman', nextUrl: null)).called(1);
    });

    test('pesquisa paginada passa o nextUrl fornecido', () async {
      when(
        () => repository.searchSeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer(
        (_) async => const Right(PaginatedResult(items: [series], total: 1)),
      );

      await usecase('batman', nextUrl: 'https://api/page2');

      verify(
        () => repository.searchSeries('batman', nextUrl: 'https://api/page2'),
      ).called(1);
    });

    test('devolve o PaginatedResult<Series> corretamente', () async {
      const paginated = PaginatedResult(items: [series], total: 1, nextUrl: 'https://api/page2');
      when(
        () => repository.searchSeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Right(paginated));

      final result = await usecase('batman');

      expect(result, const Right(paginated));
    });

    test('query sem resultados devolve resultado paginado vazio', () async {
      when(
        () => repository.searchSeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [], total: 0)));

      final result = await usecase('inexistente');

      expect(result, const Right(PaginatedResult<Series>(items: [], total: 0)));
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(
        () => repository.searchSeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase('batman');

      expect(result, const Left(failure));
    });
  });
}