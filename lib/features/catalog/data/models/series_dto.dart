import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/series.dart';
part 'series_dto.g.dart';

/// mapeia a resposta de /series/ da API Metron.
@JsonSerializable(explicitToJson: true)
class SeriesDto {
  final int id;
  final String name; // título da série.
  @JsonKey(name: 'year_began')
  final int? yearBegan;
  final String? image; // URL da capa.
  final String? desc; // sinopse.
  final PublisherRefDto? publisher;

  const SeriesDto({
    required this.id,
    required this.name,
    this.yearBegan,
    this.image,
    this.desc,
    this.publisher,
  });

  factory SeriesDto.fromJson(Map<String, dynamic> json) =>
      _$SeriesDtoFromJson(json);

  Series toDomain() => Series(
    id: id.toString(),
    title: name,
    publisher: publisher?.name ?? 'Desconhecida',
    yearBegan: yearBegan,
    coverUrl: image,
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
}
