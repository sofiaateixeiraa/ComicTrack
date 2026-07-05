import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.notFound() = NotFoundFailure;
  const factory Failure.rateLimit({int? retryAfterSeconds}) = RateLimitFailure;
  const factory Failure.auth({required String message}) = AuthFailure;
  const factory Failure.repository({required String message}) = RepositoryFailure;
  const factory Failure.businessRule({required String message}) = BusinessRuleFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}