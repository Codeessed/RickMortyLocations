import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';

/// Pure domain entity representing a Rick & Morty location.
///
/// No JSON serialization here — that belongs in the Data layer models.
@freezed
class Location with _$Location {
  const factory Location({
    required int id,
    required String name,
    required String type,
    required String dimension,
    required List<String> residentUrls,
    required String url,
    required DateTime created,
  }) = _Location;
}
