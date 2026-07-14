import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/sign_out_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late SignOutUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignOutUseCase(repository);
  });

  group('SignOutUseCase', () {
    test('sucesso devolve Right(unit) e chama o repositório uma vez', () async {
      when(() => repository.signOut()).thenAnswer((_) async => const Right(unit));

      final result = await usecase();

      expect(result, const Right(unit));
      verify(() => repository.signOut()).called(1);
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.unknown(message: 'erro inesperado');
      when(() => repository.signOut()).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}