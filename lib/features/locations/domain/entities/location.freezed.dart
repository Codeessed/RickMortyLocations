// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Location {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get dimension => throw _privateConstructorUsedError;
  List<String> get residentUrls => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationCopyWith<Location> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationCopyWith<$Res> {
  factory $LocationCopyWith(Location value, $Res Function(Location) then) =
      _$LocationCopyWithImpl<$Res, Location>;
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    String dimension,
    List<String> residentUrls,
    String url,
    DateTime created,
  });
}

/// @nodoc
class _$LocationCopyWithImpl<$Res, $Val extends Location>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dimension = null,
    Object? residentUrls = null,
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
            residentUrls: null == residentUrls
                ? _value.residentUrls
                : residentUrls // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LocationImplCopyWith<$Res>
    implements $LocationCopyWith<$Res> {
  factory _$$LocationImplCopyWith(
    _$LocationImpl value,
    $Res Function(_$LocationImpl) then,
  ) = __$$LocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String type,
    String dimension,
    List<String> residentUrls,
    String url,
    DateTime created,
  });
}

/// @nodoc
class __$$LocationImplCopyWithImpl<$Res>
    extends _$LocationCopyWithImpl<$Res, _$LocationImpl>
    implements _$$LocationImplCopyWith<$Res> {
  __$$LocationImplCopyWithImpl(
    _$LocationImpl _value,
    $Res Function(_$LocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? dimension = null,
    Object? residentUrls = null,
    Object? url = null,
    Object? created = null,
  }) {
    return _then(
      _$LocationImpl(
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
        residentUrls: null == residentUrls
            ? _value._residentUrls
            : residentUrls // ignore: cast_nullable_to_non_nullable
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

class _$LocationImpl implements _Location {
  const _$LocationImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required final List<String> residentUrls,
    required this.url,
    required this.created,
  }) : _residentUrls = residentUrls;

  @override
  final int id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String dimension;
  final List<String> _residentUrls;
  @override
  List<String> get residentUrls {
    if (_residentUrls is EqualUnmodifiableListView) return _residentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_residentUrls);
  }

  @override
  final String url;
  @override
  final DateTime created;

  @override
  String toString() {
    return 'Location(id: $id, name: $name, type: $type, dimension: $dimension, residentUrls: $residentUrls, url: $url, created: $created)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.dimension, dimension) ||
                other.dimension == dimension) &&
            const DeepCollectionEquality().equals(
              other._residentUrls,
              _residentUrls,
            ) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.created, created) || other.created == created));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    dimension,
    const DeepCollectionEquality().hash(_residentUrls),
    url,
    created,
  );

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      __$$LocationImplCopyWithImpl<_$LocationImpl>(this, _$identity);
}

abstract class _Location implements Location {
  const factory _Location({
    required final int id,
    required final String name,
    required final String type,
    required final String dimension,
    required final List<String> residentUrls,
    required final String url,
    required final DateTime created,
  }) = _$LocationImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get dimension;
  @override
  List<String> get residentUrls;
  @override
  String get url;
  @override
  DateTime get created;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
