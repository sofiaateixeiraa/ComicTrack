import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/app_user.dart';
import 'package:comictrack/features/auth/domain/usecases/register_usecase.dart';

import '../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase usecase;

  const appUser = AppUser(uid: 'u1', email: 'novo@example.com');

  setUp(() {
    repository = MockAuthRepository();
    usecase = RegisterUseCase(repository);
  });

  group('RegisterUseCase', () {
    test('sucesso com name fornecido passa todos os parâmetros', () async {
      when(
        () => repository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Right(appUser));

      final result = await usecase(
        email: 'novo@example.com',
        password: '123456',
        name: 'Novo Utilizador',
      );

      expect(result, const Right(appUser));
      verify(
        () => repository.register(
          email: 'novo@example.com',
          password: '123456',
          name: 'Novo Utilizador',
        ),
      ).called(1);
    });

    test('sucesso com name nulo chama o repositório com name: null', () async {
      when(
        () => repository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Right(appUser));

      final result = await usecase(email: 'novo@example.com', password: '123456');

      expect(result, const Right(appUser));
      verify(
        () => repository.register(
          email: 'novo@example.com',
          password: '123456',
          name: null,
        ),
      ).called(1);
    });

    test('email já em uso devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'email já registado');
      when(
        () => repository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(email: 'existe@example.com', password: '123456');

      expect(result, const Left(failure));
    });

    test('password fraca devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'password demasiado fraca');
      when(
        () => repository.register(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(email: 'novo@example.com', password: '123');

      expect(result, const Left(failure));
    });
  });
}
