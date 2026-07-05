import 'package:freezed_annotation/freezed_annotation.dart';
part 'publisher.freezed.dart';

@freezed
abstract class Publisher with _$Publisher {
  const factory Publisher({
    required String id,
    required String name,
  }) = _Publisher;
}