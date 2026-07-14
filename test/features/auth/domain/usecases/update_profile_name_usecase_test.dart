
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/update_profile_name_usecase.dart';

import '../../../../helpers/mock_user_profile_repository.dart';

void main() {
  late MockUserProfileRepository repository;
  late UpdateProfileNameUseCase usecase;

  setUp(() {
    repository = MockUserProfileRepository();
    usecase = UpdateProfileNameUseCase(repository);
  });

  group('UpdateProfileNameUseCase', () {
    test('sucesso passa uid/name ao repositório', () async {
      when(
        () => repository.updateName(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', name: 'Nome Novo');

      expect(result, const Right(unit));
      verify(() => repository.updateName('u1', 'Nome Novo')).called(1);
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.repository(message: 'falha ao atualizar nome');
      when(
        () => repository.updateName(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', name: 'Nome Novo');

      expect(result, const Left(failure));
    });
  });
}