import 'package:freezed_annotation/freezed_annotation.dart';
part 'issue.freezed.dart';

@freezed
abstract class Issue with _$Issue {
  const factory Issue({
    required String id,
    required String seriesId,
    required String seriesName,
    required String number,
    String? coverDate,
    String? coverUrl,
    String? desc,
    @Default([]) List<String> creators,
  }) = _Issue;
}
