import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/publisher.dart';
part 'publisher_dto.g.dart';

@JsonSerializable()
class PublisherDto {
  final int id;
  final String name;

  const PublisherDto({required this.id, required this.name});

  factory PublisherDto.fromJson(Map<String, dynamic> json) =>
      _$PublisherDtoFromJson(json);

  Publisher toDomain() => Publisher(id: id.toString(), name: name);
}
