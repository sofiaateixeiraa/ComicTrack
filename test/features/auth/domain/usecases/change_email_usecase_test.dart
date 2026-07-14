import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/change_email_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late ChangeEmailUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = ChangeEmailUseCase(repository);
  });

  group('ChangeEmailUseCase', () {
    test('sucesso reautentica e envia confirmação para o novo email', () async {
      when(
        () => repository.changeEmail(
          currentPassword: any(named: 'currentPassword'),
          newEmail: any(named: 'newEmail'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(currentPassword: 'atual123', newEmail: 'novo@example.com');

      expect(result, const Right(unit));
      verify(
        () => repository.changeEmail(currentPassword: 'atual123', newEmail: 'novo@example.com'),
      ).called(1);
    });

    test('password atual errada devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'password incorreta');
      when(
        () => repository.changeEmail(
          currentPassword: any(named: 'currentPassword'),
          newEmail: any(named: 'newEmail'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(currentPassword: 'errada', newEmail: 'novo@example.com');

      expect(result, const Left(failure));
    });

    test('novo email já em uso devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'email já em uso');
      when(
        () => repository.changeEmail(
          currentPassword: any(named: 'currentPassword'),
          newEmail: any(named: 'newEmail'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(currentPassword: 'atual123', newEmail: 'existente@example.com');

      expect(result, const Left(failure));
    });
  });
}