import 'package:freezed_annotation/freezed_annotation.dart';
part 'series.freezed.dart';

@freezed
abstract class Series with _$Series {
  const factory Series({
    required String id,
    required String title,
    required String publisher,
    int? yearBegan,
    String? coverUrl,
    String? synopsis,
  }) = _Series;
}
