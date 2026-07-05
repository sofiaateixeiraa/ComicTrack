import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/issue.dart';
import '../repositories/catalog_repository.dart';

class GetIssueDetailUseCase {
  final CatalogRepository _repository;
  GetIssueDetailUseCase(this._repository);
  Future<Either<Failure, Issue>> call(String issueId) =>
      _repository.getIssueDetail(issueId);
}
