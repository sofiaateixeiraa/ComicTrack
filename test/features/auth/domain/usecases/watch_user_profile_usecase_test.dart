import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/user_profile.dart';
import 'package:comictrack/features/auth/domain/usecases/watch_user_profile_usecase.dart';

import '../../../../helpers/mock_user_profile_repository.dart';

void main() {
  late MockUserProfileRepository repository;
  late WatchUserProfileUseCase usecase;

  final profile = UserProfile(
    uid: 'u1',
    email: 'user@example.com',
    name: 'Utilizador',
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    repository = MockUserProfileRepository();
    usecase = WatchUserProfileUseCase(repository);
  });

  group('WatchUserProfileUseCase', () {
    test('emite Right(UserProfile) quando o repositório emite o perfil', () {
      when(
        () => repository.watchProfile(any()),
      ).thenAnswer((_) => Stream.value(Right(profile)));

      expect(usecase('u1'), emits(Right(profile)));
    });

    test('emite Right(null) quando o perfil ainda não existe', () {
      when(
        () => repository.watchProfile(any()),
      ).thenAnswer((_) => Stream.value(const Right(null)));

      expect(usecase('u1'), emits(const Right(null)));
    });

    test('emite Left(Failure) em caso de erro na stream', () {
      const failure = Failure.repository(message: 'erro ao observar perfil');
      when(
        () => repository.watchProfile(any()),
      ).thenAnswer((_) => Stream.value(const Left(failure)));

      expect(usecase('u1'), emits(const Left(failure)));
    });

    test('emite múltiplos valores ao longo do tempo, pela ordem correta', () {
      final updated = profile.copyWith(name: 'Nome Atualizado');
      when(
        () => repository.watchProfile(any()),
      ).thenAnswer((_) => Stream.fromIterable([Right(profile), Right(updated)]));

      expect(usecase('u1'), emitsInOrder([Right(profile), Right(updated)]));
    });
  });
}