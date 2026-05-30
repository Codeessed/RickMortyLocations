import '../../domain/entities/character.dart';
import '../../domain/entities/location.dart';
import '../models/character_model.dart';
import '../models/location_model.dart';

/// Converts [LocationModel] (DTO) → [Location] (domain entity).
extension LocationModelMapper on LocationModel {
  Location toEntity() => Location(
        id: id,
        name: name,
        type: type,
        dimension: dimension,
        residentUrls: residents,
        url: url,
        created: created,
      );
}

/// Converts [CharacterModel] (DTO) → [Character] (domain entity).
extension CharacterModelMapper on CharacterModel {
  Character toEntity() => Character(
        id: id,
        name: name,
        status: status,
        species: species,
        image: image,
      );
}
