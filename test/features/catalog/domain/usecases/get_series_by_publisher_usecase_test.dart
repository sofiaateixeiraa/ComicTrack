import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/paginated_result.dart';
import 'package:comictrack/features/catalog/domain/entities/series.dart';
import 'package:comictrack/features/catalog/domain/usecases/get_series_by_publisher_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late GetSeriesByPublisherUseCase usecase;

  const series = Series(id: 's1', title: 'Batman', publisher: 'DC Comics');

  setUp(() {
    repository = MockCatalogRepository();
    usecase = GetSeriesByPublisherUseCase(repository);
  });

  group('GetSeriesByPublisherUseCase', () {
    test('sucesso com apenas publisherId aplica os defaults (sort: name, restantes null)', () async {
      when(
        () => repository.getSeriesByPublisher(
          any(),
          publisherName: any(named: 'publisherName'),
          nameFilter: any(named: 'nameFilter'),
          sort: any(named: 'sort'),
          nextUrl: any(named: 'nextUrl'),
        ),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [series], total: 1)));

      await usecase(publisherId: 'p1');

      verify(
        () => repository.getSeriesByPublisher(
          'p1',
          publisherName: null,
          nameFilter: null,
          sort: 'name',
          nextUrl: null,
        ),
      ).called(1);
    });

    test('passa publisherName/nameFilter/sort/nextUrl explícitos', () async {
      when(
        () => repository.getSeriesByPublisher(
          any(),
          publisherName: any(named: 'publisherName'),
          nameFilter: any(named: 'nameFilter'),
          sort: any(named: 'sort'),
          nextUrl: any(named: 'nextUrl'),
        ),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [series], total: 1)));

      await usecase(
        publisherId: 'p1',
        publisherName: 'DC Comics',
        nameFilter: 'bat',
        sort: 'year',
        nextUrl: 'https://api/page2',
      );

      verify(
        () => repository.getSeriesByPublisher(
          'p1',
          publisherName: 'DC Comics',
          nameFilter: 'bat',
          sort: 'year',
          nextUrl: 'https://api/page2',
        ),
      ).called(1);
    });

    test('devolve o PaginatedResult<Series> corretamente', () async {
      const paginated = PaginatedResult(items: [series], total: 1);
      when(
        () => repository.getSeriesByPublisher(
          any(),
          publisherName: any(named: 'publisherName'),
          nameFilter: any(named: 'nameFilter'),
          sort: any(named: 'sort'),
          nextUrl: any(named: 'nextUrl'),
        ),
      ).thenAnswer((_) async => const Right(paginated));

      final result = await usecase(publisherId: 'p1');

      expect(result, const Right(paginated));
    });

    test('editora sem séries devolve lista vazia', () async {
      when(
        () => repository.getSeriesByPublisher(
          any(),
          publisherName: any(named: 'publisherName'),
          nameFilter: any(named: 'nameFilter'),
          sort: any(named: 'sort'),
          nextUrl: any(named: 'nextUrl'),
        ),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [], total: 0)));

      final result = await usecase(publisherId: 'p-vazia');

      expect(result, const Right(PaginatedResult<Series>(items: [], total: 0)));
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(
        () => repository.getSeriesByPublisher(
          any(),
          publisherName: any(named: 'publisherName'),
          nameFilter: any(named: 'nameFilter'),
          sort: any(named: 'sort'),
          nextUrl: any(named: 'nextUrl'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(publisherId: 'p1');

      expect(result, const Left(failure));
    });
  });
}