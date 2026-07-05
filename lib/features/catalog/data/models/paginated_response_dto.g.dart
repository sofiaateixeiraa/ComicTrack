// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResponseDto<T> _$PaginatedResponseDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedResponseDto<T>(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
);
