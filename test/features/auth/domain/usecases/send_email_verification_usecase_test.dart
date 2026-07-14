import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/send_email_verification_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late SendEmailVerificationUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SendEmailVerificationUseCase(repository);
  });

  group('SendEmailVerificationUseCase', () {
    test('sucesso devolve Right(unit)', () async {
      when(() => repository.sendEmailVerification()).thenAnswer((_) async => const Right(unit));

      final result = await usecase();

      expect(result, const Right(unit));
      verify(() => repository.sendEmailVerification()).called(1);
    });

    test('demasiados pedidos devolve Failure.rateLimit', () async {
      const failure = Failure.rateLimit(retryAfterSeconds: 60);
      when(
        () => repository.sendEmailVerification(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}