import 'package:json_annotation/json_annotation.dart';
part 'paginated_response_dto.g.dart';

/// estrutura de paginação da API Metron: {"count": N, "next": "url|null", "previous": "url|null", "results": [...]}.
@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class PaginatedResponseDto<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  const PaginatedResponseDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseDtoFromJson(json, fromJsonT);
}
