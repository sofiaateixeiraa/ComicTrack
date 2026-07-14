import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/reset_password_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late ResetPasswordUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = ResetPasswordUseCase(repository);
  });

  group('ResetPasswordUseCase', () {
    test('sucesso envia email de reset com o email correto', () async {
      when(
        () => repository.resetPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(email: 'user@example.com');

      expect(result, const Right(unit));
      verify(() => repository.resetPassword(email: 'user@example.com')).called(1);
    });

    test('email inexistente devolve o Failure do repositório', () async {
      const failure = Failure.notFound();
      when(
        () => repository.resetPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(email: 'inexistente@example.com');

      expect(result, const Left(failure));
    });
  });
}