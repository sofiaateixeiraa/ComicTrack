import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/catalog/domain/entities/series.dart';
import 'package:comictrack/features/catalog/domain/usecases/get_series_detail_usecase.dart';

import '../../../../helpers/mock_catalog_repository.dart';

void main() {
  late MockCatalogRepository repository;
  late GetSeriesDetailUseCase usecase;

  const series = Series(id: 's1', title: 'Batman', publisher: 'DC Comics');

  setUp(() {
    repository = MockCatalogRepository();
    usecase = GetSeriesDetailUseCase(repository);
  });

  group('GetSeriesDetailUseCase', () {
    test('sucesso devolve a Series pelo seriesId', () async {
      when(() => repository.getSeriesDetail(any())).thenAnswer((_) async => const Right(series));

      final result = await usecase('s1');

      expect(result, const Right(series));
      verify(() => repository.getSeriesDetail('s1')).called(1);
    });

    test('série inexistente devolve Failure.notFound', () async {
      const failure = Failure.notFound();
      when(() => repository.getSeriesDetail(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase('inexistente');

      expect(result, const Left(failure));
    });

    test('falha de rede é propagada', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(() => repository.getSeriesDetail(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase('s1');

      expect(result, const Left(failure));
    });
  });
}