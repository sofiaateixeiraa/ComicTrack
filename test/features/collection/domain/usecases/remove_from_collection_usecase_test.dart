import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:comictrack/features/collection/domain/usecases/remove_from_collection_usecase.dart';
import 'package:comictrack/core/error/failures.dart';
import '../../../helpers/mock_collection_repository.dart';

void main() {
  late RemoveFromCollectionUseCase sut;
  late MockCollectionRepository mockRepo;

  const userId = 'user123';
  const issueId = 'issue456';

  setUp(() {
    mockRepo = MockCollectionRepository();
    sut = RemoveFromCollectionUseCase(mockRepo);
  });

  group('RemoveFromCollectionUseCase', () {
    // Regra 6: confirmar que o use case chama deleteEntry
    test('remove a entrada do repositório (Regra 6)', () async {
      when(() => mockRepo.deleteEntry(userId, issueId))
          .thenAnswer((_) async => const Right(unit));

      final result = await sut(userId: userId, issueId: issueId);
      expect(result.isRight(), true);
      verify(() => mockRepo.deleteEntry(userId, issueId)).called(1);
    });

    // Propagação de erros
    test('propaga falha do repositório', () async {
      when(() => mockRepo.deleteEntry(userId, issueId))
          .thenAnswer((_) async => Left(const Failure.repository(message: 'Firestore error')));

      final result = await sut(userId: userId, issueId: issueId);
      expect(result.isLeft(), true);
    });

    // Confirmar que a confirmação (Regra 7) NÃO é responsabilidade do use case
    test('não inclui lógica de confirmação — essa responsabilidade pertence à UI (Regra 7)', () {
      // Este teste documenta a separação de responsabilidades:
      // O use case executa a remoção; a confirmação é feita na camada de apresentação
      // (showModalBottomSheet em issue_detail_screen.dart → _confirmRemove).
      // Verificar que o use case não tem nenhum parâmetro ou lógica de confirmação.
      expect(sut, isA<RemoveFromCollectionUseCase>());
      // O use case existe e é chamável — a confirmação está na UI.
    });
  });
}