import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/entities/user_profile.dart';
import 'package:comictrack/features/auth/domain/usecases/create_user_profile_usecase.dart';

import '../../../../helpers/mock_user_profile_repository.dart';

class _FakeUserProfile extends Fake implements UserProfile {}

void main() {
  late MockUserProfileRepository repository;
  late CreateUserProfileUseCase usecase;

  setUpAll(() {
    registerFallbackValue(_FakeUserProfile());
  });

  setUp(() {
    repository = MockUserProfileRepository();
    usecase = CreateUserProfileUseCase(repository);
  });

  group('CreateUserProfileUseCase', () {
    test('constrói o UserProfile com uid/email/name e createdAt próximo de agora', () async {
      when(() => repository.createProfile(any())).thenAnswer((_) async => const Right(unit));

      final before = DateTime.now();
      await usecase(uid: 'u1', email: 'user@example.com', name: 'Utilizador');
      final after = DateTime.now();

      final captured = verify(() => repository.createProfile(captureAny())).captured.single
          as UserProfile;

      expect(captured.uid, 'u1');
      expect(captured.email, 'user@example.com');
      expect(captured.name, 'Utilizador');
      expect(
        captured.createdAt.isAfter(before.subtract(const Duration(seconds: 1))) &&
            captured.createdAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('sucesso devolve Right(unit)', () async {
      when(() => repository.createProfile(any())).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', email: 'user@example.com', name: 'Utilizador');

      expect(result, const Right(unit));
    });

    test('erro do repositório é propagado', () async {
      const failure = Failure.repository(message: 'falha ao gravar no firestore');
      when(() => repository.createProfile(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', email: 'user@example.com', name: 'Utilizador');

      expect(result, const Left(failure));
    });
  });
}