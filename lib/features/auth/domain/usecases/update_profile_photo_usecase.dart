import 'dart:convert';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/image_compressor.dart';
import '../repositories/user_profile_repository.dart';

/// comprime a imagem escolhida para caber no limite de 1MB, converte para base64 e guarda no perfil do utilizador.
class UpdateProfilePhotoUseCase {
  final UserProfileRepository _repository;
  UpdateProfilePhotoUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String uid,
    required Uint8List imageBytes,
  }) async {
    try {
      final compressed = await ImageCompressor.compress(imageBytes);
      final photoBase64 = base64Encode(compressed);
      return _repository.updatePhoto(uid, photoBase64);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
