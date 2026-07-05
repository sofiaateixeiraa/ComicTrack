import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/series.dart';
part 'series_dto.g.dart';

/// mapeia um item da resposta de listagem de /api/series/ e de /api/publisher/{id}/series_list/.
@JsonSerializable(createToJson: false)
class SeriesListItemDto {
  final int id;
  @JsonKey(name: 'series')
  final String title;
  @JsonKey(name: 'year_began')
  final int? yearBegan;
  @JsonKey(name: 'year_end')
  final int? yearEnd;
  final int? volume;
  @JsonKey(name: 'issue_count')
  final int? issueCount;

  const SeriesListItemDto({
    required this.id,
    required this.title,
    this.yearBegan,
    this.yearEnd,
    this.volume,
    this.issueCount,
  });

  factory SeriesListItemDto.fromJson(Map<String, dynamic> json) =>
      _$SeriesListItemDtoFromJson(json);

  Series toDomain({String? publisherName}) => Series(
    id: id.toString(),
    title: title,
    publisher: publisherName ?? 'Desconhecida',
    yearBegan: yearBegan,
    synopsis: null,
  );
}

/// mapeia a resposta de detalhe de /api/series/{id}/.
@JsonSerializable(createToJson: false)
class SeriesDto {
  final int id;
  final String name;
  @JsonKey(name: 'year_began')
  final int? yearBegan;
  final String? desc;
  final PublisherRefDto? publisher;

  const SeriesDto({
    required this.id,
    required this.name,
    this.yearBegan,
    this.desc,
    this.publisher,
  });

  factory SeriesDto.fromJson(Map<String, dynamic> json) => _$SeriesDtoFromJson(json);

  Series toDomain() => Series(
    id: id.toString(),
    title: name,
    publisher: publisher?.name ?? 'Desconhecida',
    yearBegan: yearBegan,
    synopsis: desc,
  );
}

@JsonSerializable()
class PublisherRefDto {
  final int id;
  final String name;
  const PublisherRefDto({required this.id, required this.name});
  factory PublisherRefDto.fromJson(Map<String, dynamic> json) =>
      _$PublisherRefDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PublisherRefDtoToJson(this);
}
