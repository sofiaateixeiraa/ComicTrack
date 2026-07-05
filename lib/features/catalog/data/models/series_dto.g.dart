// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesListItemDto _$SeriesListItemDtoFromJson(Map<String, dynamic> json) =>
    SeriesListItemDto(
      id: (json['id'] as num).toInt(),
      title: json['series'] as String,
      yearBegan: (json['year_began'] as num?)?.toInt(),
      yearEnd: (json['year_end'] as num?)?.toInt(),
      volume: (json['volume'] as num?)?.toInt(),
      issueCount: (json['issue_count'] as num?)?.toInt(),
    );

SeriesDto _$SeriesDtoFromJson(Map<String, dynamic> json) => SeriesDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  yearBegan: (json['year_began'] as num?)?.toInt(),
  desc: json['desc'] as String?,
  publisher: json['publisher'] == null
      ? null
      : PublisherRefDto.fromJson(json['publisher'] as Map<String, dynamic>),
);

PublisherRefDto _$PublisherRefDtoFromJson(Map<String, dynamic> json) =>
    PublisherRefDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PublisherRefDtoToJson(PublisherRefDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
