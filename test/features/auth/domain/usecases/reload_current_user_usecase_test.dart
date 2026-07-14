import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/reload_current_user_usecase.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late ReloadCurrentUserUseCase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = ReloadCurrentUserUseCase(repository);
  });

  group('ReloadCurrentUserUseCase', () {
    test('sucesso devolve Right(unit)', () async {
      when(() => repository.reloadCurrentUser()).thenAnswer((_) async => const Right(unit));

      final result = await usecase();

      expect(result, const Right(unit));
      verify(() => repository.reloadCurrentUser()).called(1);
    });

    test('utilizador sem sessão devolve o erro propagado', () async {
      const failure = Failure.auth(message: 'sem sessão ativa');
      when(
        () => repository.reloadCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}