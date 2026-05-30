import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

/// Pure domain entity representing a Rick & Morty character (resident).
@freezed
class Character with _$Character {
  const factory Character({
    required int id,
    required String name,
    required String status,
    required String species,
    required String image,
  }) = _Character;
}
