import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/issue.dart';
import 'package:comictrack/features/catalog/domain/entities/paginated_result.dart';
import 'package:comictrack/features/catalog/domain/usecases/get_issues_by_series_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late GetIssuesBySeriesUseCase usecase;

  const issue = Issue(id: 'i1', seriesId: 's1', seriesName: 'Batman', number: '1');

  setUp(() {
    repository = MockCatalogRepository();
    usecase = GetIssuesBySeriesUseCase(repository);
  });

  group('GetIssuesBySeriesUseCase', () {
    test('sucesso sem nextUrl (primeira página)', () async {
      when(
        () => repository.getIssuesBySeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [issue], total: 1)));

      await usecase('s1');

      verify(() => repository.getIssuesBySeries('s1', nextUrl: null)).called(1);
    });

    test('sucesso com nextUrl (página seguinte)', () async {
      when(
        () => repository.getIssuesBySeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Right(PaginatedResult(items: [issue], total: 1)));

      await usecase('s1', nextUrl: 'https://api/page2');

      verify(
        () => repository.getIssuesBySeries('s1', nextUrl: 'https://api/page2'),
      ).called(1);
    });

    test('devolve o PaginatedResult<Issue> corretamente', () async {
      const paginated = PaginatedResult(items: [issue], total: 1);
      when(
        () => repository.getIssuesBySeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Right(paginated));

      final result = await usecase('s1');

      expect(result, const Right(paginated));
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(
        () => repository.getIssuesBySeries(any(), nextUrl: any(named: 'nextUrl')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase('s1');

      expect(result, const Left(failure));
    });
  });
}