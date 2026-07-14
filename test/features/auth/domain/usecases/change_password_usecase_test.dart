import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/change_password_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late ChangePasswordUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = ChangePasswordUseCase(repository);
  });

  group('ChangePasswordUseCase', () {
    test('sucesso reautentica e altera a password', () async {
      when(
        () => repository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(currentPassword: 'atual123', newPassword: 'novaSenha456');

      expect(result, const Right(unit));
      verify(
        () => repository.changePassword(
          currentPassword: 'atual123',
          newPassword: 'novaSenha456',
        ),
      ).called(1);
    });

    test('password atual incorreta devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'password atual incorreta');
      when(
        () => repository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(currentPassword: 'errada', newPassword: 'novaSenha456');

      expect(result, const Left(failure));
    });

    test('nova password não cumpre requisitos devolve Failure.businessRule', () async {
      const failure = Failure.businessRule(message: 'password demasiado curta');
      when(
        () => repository.changePassword(
          currentPassword: any(named: 'currentPassword'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(currentPassword: 'atual123', newPassword: '123');

      expect(result, const Left(failure));
    });
  });
}