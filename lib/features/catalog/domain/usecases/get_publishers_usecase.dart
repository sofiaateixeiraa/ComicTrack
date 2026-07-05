import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/publisher.dart';
import '../repositories/catalog_repository.dart';

class GetPublishersUseCase {
  final CatalogRepository _repository;
  GetPublishersUseCase(this._repository);
  Future<Either<Failure, List<Publisher>>> call() =>
      _repository.getPublishers();
}
