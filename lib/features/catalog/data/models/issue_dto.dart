import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/issue.dart';
part 'issue_dto.g.dart';

/// mapeia /api/issue/{id}/ (detalhe).
@JsonSerializable(explicitToJson: true)
class IssueDto {
  final int id;
  final String number;
  final String? title;
  @JsonKey(name: 'cover_date')
  final String? coverDate;
  final String? image;
  final String? desc;
  final SeriesRefDto series;
  final List<CreditDto>? credits;

  const IssueDto({
    required this.id,
    required this.number,
    this.title,
    this.coverDate,
    this.image,
    this.desc,
    required this.series,
    this.credits,
  });

  factory IssueDto.fromJson(Map<String, dynamic> json) =>
      _$IssueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IssueDtoToJson(this);

  Issue toDomain() => Issue(
    id: id.toString(),
    seriesId: series.id.toString(),
    seriesName: series.name,
    number: number,
    coverDate: coverDate,
    coverUrl: image,
    desc: desc,
    creators: credits?.map((c) => c.creator).toSet().toList() ?? const [],
  );
}

@JsonSerializable()
class SeriesRefDto {
  final int id;
  final String name;
  const SeriesRefDto({required this.id, required this.name});
  factory SeriesRefDto.fromJson(Map<String, dynamic> json) =>
      _$SeriesRefDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesRefDtoToJson(this);
}

@JsonSerializable()
class CreditDto {
  final String creator;
  final List<RoleDto>? role;
  const CreditDto({required this.creator, this.role});
  factory CreditDto.fromJson(Map<String, dynamic> json) =>
      _$CreditDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreditDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class RoleDto {
  final int id;
  final String name;
  const RoleDto({required this.id, required this.name});
  factory RoleDto.fromJson(Map<String, dynamic> json) =>
      _$RoleDtoFromJson(json);
}
