import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/issue.dart';
part 'issue_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class IssueDto {
  final int id;
  final String number;
  @JsonKey(name: 'cover_date')
  final String? coverDate;
  final String? image;
  final String? desc;
  final SeriesRefDto series;
  final List<CreditDto>? credits;

  const IssueDto({
    required this.id,
    required this.number,
    this.coverDate,
    this.image,
    this.desc,
    required this.series,
    this.credits,
  });

  factory IssueDto.fromJson(Map<String, dynamic> json) =>
      _$IssueDtoFromJson(json);

  Issue toDomain() => Issue(
    id: id.toString(),
    seriesId: series.id.toString(),
    seriesName: series.name,
    number: number,
    coverDate: coverDate,
    coverUrl: image,
    desc: desc,
    creators: credits?.map((c) => c.creator.name).toSet().toList() ?? const [],
  );
}

@JsonSerializable()
class SeriesRefDto {
  final int id;
  final String name;
  const SeriesRefDto({required this.id, required this.name});
  factory SeriesRefDto.fromJson(Map<String, dynamic> json) =>
      _$SeriesRefDtoFromJson(json);
}

@JsonSerializable()
class CreditDto {
  final CreatorRefDto creator;
  const CreditDto({required this.creator});
  factory CreditDto.fromJson(Map<String, dynamic> json) =>
      _$CreditDtoFromJson(json);
}

@JsonSerializable()
class CreatorRefDto {
  final int id;
  final String name;
  const CreatorRefDto({required this.id, required this.name});
  factory CreatorRefDto.fromJson(Map<String, dynamic> json) =>
      _$CreatorRefDtoFromJson(json);
}
