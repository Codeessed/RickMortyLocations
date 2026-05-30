// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return _LocationModel.fromJson(json);
}

/// @nodoc
mixin _$LocationModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get dimension => throw _privateConstructorUsedError;
  List<String> get residents => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;

  /// Serializes this LocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationModelCopyWith<LocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationModelCopyWith<$Res> {
  factory $LocationModelCopyWith(
    LocationModel value,
    $Res Function(LocationModel) then,
  ) = _$LocationModelCopyWithImpl<$Res, LocationModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    String dimension,
    List<String> residents,
    String url,
    DateTime created,
  });
}

/// @nodoc
class _$LocationModelCopyWithImpl<$Res, $Val extends LocationModel>
    implements $LocationModelCopyWith<$Res> {
  _$LocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dimension = null,
    Object? residents = null,
    Object? url = null,
    Object? created = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            dimension: null == dimension
                ? _value.dimension
                : dimension // ignore: cast_nullable_to_non_nullable
                      as String,
            residents: null == residents
                ? _value.residents
                : residents // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            created: null == created
                ? _value.created
                : created // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationModelImplCopyWith<$Res>
    implements $LocationModelCopyWith<$Res> {
  factory _$$LocationModelImplCopyWith(
    _$LocationModelImpl value,
    $Res Function(_$LocationModelImpl) then,
  ) = __$$LocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    String dimension,
    List<String> residents,
    String url,
    DateTime created,
  });
}

/// @nodoc
class __$$LocationModelImplCopyWithImpl<$Res>
    extends _$LocationModelCopyWithImpl<$Res, _$LocationModelImpl>
    implements _$$LocationModelImplCopyWith<$Res> {
  __$$LocationModelImplCopyWithImpl(
    _$LocationModelImpl _value,
    $Res Function(_$LocationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dimension = null,
    Object? residents = null,
    Object? url = null,
    Object? created = null,
  }) {
    return _then(
      _$LocationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        dimension: null == dimension
            ? _value.dimension
            : dimension // ignore: cast_nullable_to_non_nullable
                  as String,
        residents: null == residents
            ? _value._residents
            : residents // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        created: null == created
            ? _value.created
            : created // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationModelImpl implements _LocationModel {
  const _$LocationModelImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required final List<String> residents,
    required this.url,
    required this.created,
  }) : _residents = residents;

  factory _$LocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String dimension;
  final List<String> _residents;
  @override
  List<String> get residents {
    if (_residents is EqualUnmodifiableListView) return _residents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_residents);
  }

  @override
  final String url;
  @override
  final DateTime created;

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, type: $type, dimension: $dimension, residents: $residents, url: $url, created: $created)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.dimension, dimension) ||
                other.dimension == dimension) &&
            const DeepCollectionEquality().equals(
              other._residents,
              _residents,
            ) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.created, created) || other.created == created));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    dimension,
    const DeepCollectionEquality().hash(_residents),
    url,
    created,
  );

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      __$$LocationModelImplCopyWithImpl<_$LocationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationModelImplToJson(this);
  }
}

abstract class _LocationModel implements LocationModel {
  const factory _LocationModel({
    required final int id,
    required final String name,
    required final String type,
    required final String dimension,
    required final List<String> residents,
    required final String url,
    required final DateTime created,
  }) = _$LocationModelImpl;

  factory _LocationModel.fromJson(Map<String, dynamic> json) =
      _$LocationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get dimension;
  @override
  List<String> get residents;
  @override
  String get url;
  @override
  DateTime get created;

  /// Create a copy of LocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationModelImplCopyWith<_$LocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
