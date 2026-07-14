import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart' as img;
import 'package:comictrack/core/error/failures.dart';
import 'package:comictrack/features/auth/domain/usecases/update_profile_photo_usecase.dart';

import '../../../../helpers/mock_user_profile_repository.dart';

Uint8List _tinyJpegBytes() {
  final image = img.Image(width: 4, height: 4);
  img.fill(image, color: img.ColorRgb8(255, 0, 0));
  return Uint8List.fromList(img.encodeJpg(image, quality: 90));
}

void main() {
  late MockUserProfileRepository repository;
  late UpdateProfilePhotoUseCase usecase;

  setUp(() {
    repository = MockUserProfileRepository();
    usecase = UpdateProfilePhotoUseCase(repository);
  });

  group('UpdateProfilePhotoUseCase', () {
    test('comprime uma imagem válida e guarda como base64 dentro do limite', () async {
      when(
        () => repository.updatePhoto(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', imageBytes: _tinyJpegBytes());

      expect(result, const Right(unit));
      final captured = verify(
        () => repository.updatePhoto('u1', captureAny()),
      ).captured.single as String;

      final decodedBytes = base64Decode(captured);
      expect(decodedBytes.lengthInBytes, lessThanOrEqualTo(700 * 1024));
    });

    test('sucesso devolve Right(unit)', () async {
      when(
        () => repository.updatePhoto(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(uid: 'u1', imageBytes: _tinyJpegBytes());

      expect(result, const Right(unit));
    });

    test('bytes que não são uma imagem válida não lançam exceção (decodeImage devolve null)', () async {
      when(
        () => repository.updatePhoto(any(), any()),
      ).thenAnswer((_) async => const Right(unit));

      final invalidBytes = Uint8List.fromList(List.filled(10, 0));
      final result = await usecase(uid: 'u1', imageBytes: invalidBytes);

      // comportamento atual: ImageCompressor devolve os bytes originais em vez
      // de lançar, por isso não existe caminho de Failure.unknown alcançável
      // com bytes inválidos — o repositório continua a ser chamado normalmente.
      expect(result, const Right(unit));
      verify(() => repository.updatePhoto('u1', base64Encode(invalidBytes))).called(1);
    });

    test('erro do repositório ao guardar é propagado', () async {
      const failure = Failure.repository(message: 'falha ao gravar foto');
      when(
        () => repository.updatePhoto(any(), any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(uid: 'u1', imageBytes: _tinyJpegBytes());

      expect(result, const Left(failure));
    });
  });
}