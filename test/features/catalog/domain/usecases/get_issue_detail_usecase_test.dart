import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/issue.dart';
import 'package:comictrack/features/catalog/domain/usecases/get_issue_detail_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late GetIssueDetailUseCase usecase;

  const issue = Issue(id: 'i1', seriesId: 's1', seriesName: 'Batman', number: '1');

  setUp(() {
    repository = MockCatalogRepository();
    usecase = GetIssueDetailUseCase(repository);
  });

  group('GetIssueDetailUseCase', () {
    test('sucesso devolve o Issue pelo issueId', () async {
      when(() => repository.getIssueDetail(any())).thenAnswer((_) async => const Right(issue));

      final result = await usecase('i1');

      expect(result, const Right(issue));
      verify(() => repository.getIssueDetail('i1')).called(1);
    });

    test('issue inexistente devolve Failure.notFound', () async {
      const failure = Failure.notFound();
      when(() => repository.getIssueDetail(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase('inexistente');

      expect(result, const Left(failure));
    });

    test('erro de rede/rate limit é propagado', () async {
      const failure = Failure.rateLimit(retryAfterSeconds: 10);
      when(() => repository.getIssueDetail(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase('i1');

      expect(result, const Left(failure));
    });
  });
}