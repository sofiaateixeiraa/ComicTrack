import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/user_profile.dart';
import 'package:comictrack/features/auth/domain/usecases/ensure_user_profile_usecase.dart';

import '../../../../helpers/mock_user_profile_repository.dart';

class _FakeUserProfile extends Fake implements UserProfile {}

void main() {
  late MockUserProfileRepository repository;
  late EnsureUserProfileUseCase usecase;

  final existingProfile = UserProfile(
    uid: 'u1',
    email: 'user@example.com',
    name: 'Nome Existente',
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(_FakeUserProfile());
  });

  setUp(() {
    repository = MockUserProfileRepository();
    usecase = EnsureUserProfileUseCase(repository);
  });

  group('EnsureUserProfileUseCase', () {
    test('getProfile falha propaga Left sem chamar createProfile/updateEmail/updateName', () async {
      const failure = Failure.repository(message: 'erro ao ler perfil');
      when(() => repository.getProfile(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', email: 'user@example.com', name: 'Nome');

      expect(result, const Left(failure));
      verifyNever(() => repository.createProfile(any()));
      verifyNever(() => repository.updateEmail(any(), any()));
      verifyNever(() => repository.updateName(any(), any()));
    });

    test('perfil null cria um perfil novo', () async {
      when(() => repository.getProfile(any())).thenAnswer((_) async => const Right(null));
      when(() => repository.createProfile(any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', email: 'user@example.com', name: 'Nome');

      expect(result, const Right(unit));
      final captured = verify(() => repository.createProfile(captureAny())).captured.single
          as UserProfile;
      expect(captured.uid, 'u1');
      expect(captured.email, 'user@example.com');
      expect(captured.name, 'Nome');
    });

    test('perfil existe com email igual e nome preenchido não altera nada', () async {
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(existingProfile));

      final result = await usecase(uid: 'u1', email: existingProfile.email, name: 'Nome Novo');

      expect(result, const Right(unit));
      verifyNever(() => repository.updateEmail(any(), any()));
      verifyNever(() => repository.updateName(any(), any()));
    });

    test('perfil existe com email diferente chama updateEmail', () async {
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(existingProfile));
      when(
        () => repository.updateEmail(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', email: 'novo@example.com', name: existingProfile.name);

      expect(result, const Right(unit));
      verify(() => repository.updateEmail('u1', 'novo@example.com')).called(1);
      verifyNever(() => repository.updateName(any(), any()));
    });

    test('updateEmail falha devolve Left e não chama updateName', () async {
      const failure = Failure.repository(message: 'falha ao atualizar email');
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(existingProfile));
      when(
        () => repository.updateEmail(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', email: 'novo@example.com', name: existingProfile.name);

      expect(result, const Left(failure));
      verifyNever(() => repository.updateName(any(), any()));
    });

    test('perfil existe com name vazio chama updateName', () async {
      final profileSemNome = existingProfile.copyWith(name: '');
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(profileSemNome));
      when(
        () => repository.updateName(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', email: existingProfile.email, name: 'Nome Preenchido');

      expect(result, const Right(unit));
      verify(() => repository.updateName('u1', 'Nome Preenchido')).called(1);
    });

    test('email diferente e nome vazio chama updateEmail e depois updateName', () async {
      final profileSemNome = existingProfile.copyWith(name: '');
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(profileSemNome));
      when(
        () => repository.updateEmail(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => repository.updateName(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', email: 'novo@example.com', name: 'Nome Preenchido');

      expect(result, const Right(unit));
      verifyInOrder([
        () => repository.updateEmail('u1', 'novo@example.com'),
        () => repository.updateName('u1', 'Nome Preenchido'),
      ]);
    });

    test('updateName falha após updateEmail ter sucesso devolve Left', () async {
      const failure = Failure.repository(message: 'falha ao atualizar nome');
      final profileSemNome = existingProfile.copyWith(name: '');
      when(() => repository.getProfile(any())).thenAnswer((_) async => Right(profileSemNome));
      when(
        () => repository.updateEmail(any(), any()),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => repository.updateName(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', email: 'novo@example.com', name: 'Nome Preenchido');

      expect(result, const Left(failure));
    });
  });
}