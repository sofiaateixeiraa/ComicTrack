import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/app_user.dart';
import 'package:comictrack/features/auth/domain/usecases/sign_in_with_google_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late SignInWithGoogleUseCase usecase;

  const appUser = AppUser(uid: 'u1', email: 'user@gmail.com');

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignInWithGoogleUseCase(repository);
  });

  group('SignInWithGoogleUseCase', () {
    test('sucesso devolve o AppUser do repositório', () async {
      when(() => repository.signInWithGoogle()).thenAnswer((_) async => const Right(appUser));

      final result = await usecase();

      expect(result, const Right(appUser));
      verify(() => repository.signInWithGoogle()).called(1);
    });

    test('utilizador cancela o popup devolve Failure.auth', () async {
      const failure = Failure.auth(message: 'popup cancelado pelo utilizador');
      when(() => repository.signInWithGoogle()).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('falha de rede é propagada', () async {
      const failure = Failure.network(message: 'sem ligação');
      when(() => repository.signInWithGoogle()).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}