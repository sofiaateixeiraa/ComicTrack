// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesDto _$SeriesDtoFromJson(Map<String, dynamic> json) => SeriesDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  yearBegan: (json['year_began'] as num?)?.toInt(),
  image: json['image'] as String?,
  desc: json['desc'] as String?,
  publisher: json['publisher'] == null
      ? null
      : PublisherRefDto.fromJson(json['publisher'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SeriesDtoToJson(SeriesDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'year_began': instance.yearBegan,
  'image': instance.image,
  'desc': instance.desc,
  'publisher': instance.publisher?.toJson(),
};

PublisherRefDto _$PublisherRefDtoFromJson(Map<String, dynamic> json) =>
    PublisherRefDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PublisherRefDtoToJson(PublisherRefDto instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
