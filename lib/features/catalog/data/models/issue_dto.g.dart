// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueDto _$IssueDtoFromJson(Map<String, dynamic> json) => IssueDto(
  id: (json['id'] as num).toInt(),
  number: json['number'] as String,
  title: json['title'] as String?,
  coverDate: json['cover_date'] as String?,
  image: json['image'] as String?,
  desc: json['desc'] as String?,
  series: SeriesRefDto.fromJson(json['series'] as Map<String, dynamic>),
  credits: (json['credits'] as List<dynamic>?)
      ?.map((e) => CreditDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IssueDtoToJson(IssueDto instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'title': instance.title,
  'cover_date': instance.coverDate,
  'image': instance.image,
  'desc': instance.desc,
  'series': instance.series.toJson(),
  'credits': instance.credits?.map((e) => e.toJson()).toList(),
};

SeriesRefDto _$SeriesRefDtoFromJson(Map<String, dynamic> json) =>
    SeriesRefDto(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$SeriesRefDtoToJson(SeriesRefDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CreditDto _$CreditDtoFromJson(Map<String, dynamic> json) => CreditDto(
  creator: json['creator'] as String,
  role: (json['role'] as List<dynamic>?)
      ?.map((e) => RoleDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CreditDtoToJson(CreditDto instance) => <String, dynamic>{
  'creator': instance.creator,
  'role': instance.role,
};

RoleDto _$RoleDtoFromJson(Map<String, dynamic> json) =>
    RoleDto(id: (json['id'] as num).toInt(), name: json['name'] as String);
