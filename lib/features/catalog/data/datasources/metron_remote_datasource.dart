import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/metron_client.dart';
import '../models/series_dto.dart';
import '../models/issue_dto.dart';
import '../models/paginated_response_dto.dart';
import '../models/publisher_dto.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/issue.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/publisher.dart';

abstract interface class MetronRemoteDataSource {
  Future<Either<Failure, List<Publisher>>> getPublishers();
  Future<Either<Failure, PaginatedResult<Series>>> getSeriesByPublisher(
    String publisherId, {
    String? nameFilter,
    String? nextUrl,
  });
  Future<Either<Failure, PaginatedResult<Series>>> searchSeries(
    String query, {
    String? nextUrl,
  });
  Future<Either<Failure, Series>> getSeriesDetail(String seriesId);
  Future<Either<Failure, PaginatedResult<Issue>>> getIssuesBySeries(
    String seriesId, {
    String? nextUrl,
  });
  Future<Either<Failure, Issue>> getIssueDetail(String issueId);
}

class MetronRemoteDataSourceImpl implements MetronRemoteDataSource {
  final Dio _dio;
  final MetronCache _cache;

  MetronRemoteDataSourceImpl({required Dio dio, required MetronCache cache})
    : _dio = dio,
      _cache = cache;

  @override
  Future<Either<Failure, List<Publisher>>> getPublishers() async {
    const cacheKey = 'publishers';
    if (_cache.has(cacheKey)) {
      return Right(_cache.get<List<Publisher>>(cacheKey)!);
    }

    try {
      // metron devolve todos os publishers numa só página.
      final publishers = <Publisher>[];
      String? nextUrl = 'publisher/';

      while (nextUrl != null) {
        final response = await _dio.get(nextUrl);
        final dto = PaginatedResponseDto<PublisherDto>.fromJson(
          response.data as Map<String, dynamic>,
          (j) => PublisherDto.fromJson(j as Map<String, dynamic>),
        );

        publishers.addAll(dto.results.map((e) => e.toDomain()));
        nextUrl = dto.next;
      }

      _cache.set(cacheKey, publishers);
      return Right(publishers);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Series>>> getSeriesByPublisher(
    String publisherId, {
    String? nameFilter,
    String? nextUrl,
  }) async {
    try {
      Response response;
      if (nextUrl != null) {
        // usa a url completa de paginação.
        response = await _dio.get(nextUrl);
      } else if (nameFilter == null || nameFilter.isEmpty) {
        response = await _dio.get('publisher/$publisherId/series_list/');
      } else {
        response = await _dio.get(
          'series/',
          queryParameters: {
            'publisher_id': publisherId,
            'name': nameFilter,
          },
        );
      }
      return Right(_parsePaginatedSeries(response));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Series>>> searchSeries(
    String query, {
    String? nextUrl,
  }) async {
    try {
      Response response;
      if (nextUrl != null) {
        response = await _dio.get(nextUrl);
      } else {
        response = await _dio.get('series/', queryParameters: {'name': query});
      }
      return Right(_parsePaginatedSeries(response));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Series>> getSeriesDetail(String seriesId) async {
    final cacheKey = 'series_$seriesId';
    if (_cache.has(cacheKey)) {
      return Right(_cache.get<Series>(cacheKey)!);
    }
    try {
      final response = await _dio.get('series/$seriesId/');
      final series = SeriesDto.fromJson(
        response.data as Map<String, dynamic>,
      ).toDomain();
      _cache.set(cacheKey, series);
      return Right(series);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Issue>>> getIssuesBySeries(
    String seriesId, {
    String? nextUrl,
  }) async {
    try {
      final response = nextUrl != null
          ? await _dio.get(nextUrl)
          : await _dio.get('series/$seriesId/issue_list/');
      final dto = PaginatedResponseDto<IssueDto>.fromJson(
        response.data as Map<String, dynamic>,
        (j) => IssueDto.fromJson(j as Map<String, dynamic>),
      );
      return Right(
        PaginatedResult<Issue>(
          items: dto.results.map((e) => e.toDomain()).toList(),
          total: dto.count,
          nextUrl: dto.next,
          previousUrl: dto.previous,
        ),
      );
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Issue>> getIssueDetail(String issueId) async {
    final cacheKey = 'issue_$issueId';
    if (_cache.has(cacheKey)) {
      return Right(_cache.get<Issue>(cacheKey)!);
    }
    try {
      final response = await _dio.get('issue/$issueId/');
      final issue = IssueDto.fromJson(
        response.data as Map<String, dynamic>,
      ).toDomain();
      _cache.set(cacheKey, issue);
      return Right(issue);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  PaginatedResult<Series> _parsePaginatedSeries(Response response) {
    final dto = PaginatedResponseDto<SeriesDto>.fromJson(
      response.data as Map<String, dynamic>,
      (j) => SeriesDto.fromJson(j as Map<String, dynamic>),
    );
    return PaginatedResult<Series>(
      items: dto.results.map((e) => e.toDomain()).toList(),
      total: dto.count,
      nextUrl: dto.next,
      previousUrl: dto.previous,
    );
  }

  Failure _handleDioError(DioException e) {
    if (e.response?.statusCode == 429) {
      return const Failure.rateLimit();
    }
    if (e.response?.statusCode == 404) {
      return const Failure.notFound();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Failure.network(
        message: 'Sem ligação à internet. Verifica a tua conexão.',
      );
    }
    return Failure.network(message: e.message ?? 'Erro de rede desconhecido.');
  }
}
