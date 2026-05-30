import 'package:freezed_annotation/freezed_annotation.dart';

import 'location_model.dart';

part 'location_response_model.freezed.dart';
part 'location_response_model.g.dart';

/// Wraps the paginated response from `GET /location?page=N`.
@freezed
class LocationResponseModel with _$LocationResponseModel {
  const factory LocationResponseModel({
    required PaginationInfo info,
    required List<LocationModel> results,
  }) = _LocationResponseModel;

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseModelFromJson(json);
}

/// Pagination metadata returned by the Rick & Morty API.
@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    required int count,
    required int pages,
    String? next,
    String? prev,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}
