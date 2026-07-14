import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/app_user.dart';
import 'package:comictrack/features/auth/domain/usecases/sign_in_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late SignInUseCase usecase;

  const appUser = AppUser(uid: 'u1', email: 'user@example.com');

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignInUseCase(repository);
  });

  group('SignInUseCase', () {
    test('sucesso devolve o AppUser do repositório', () async {
      when(
        () => repository.signIn(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Right(appUser));

      final result = await usecase(email: 'user@example.com', password: '123456');

      expect(result, const Right(appUser));
    });

    test('passa email/password corretos ao repositório', () async {
      when(
        () => repository.signIn(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Right(appUser));

      await usecase(email: 'user@example.com', password: 's3nha');

      verify(
        () => repository.signIn(email: 'user@example.com', password: 's3nha'),
      ).called(1);
    });

    test('credenciais inválidas devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'credenciais inválidas');
      when(
        () => repository.signIn(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(email: 'user@example.com', password: 'errada');

      expect(result, const Left(failure));
    });

    test('falha de rede é propagada', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(
        () => repository.signIn(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(email: 'user@example.com', password: '123456');

      expect(result, const Left(failure));
    });
  });
}