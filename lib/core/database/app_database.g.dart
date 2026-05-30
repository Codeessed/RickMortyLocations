// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedLocationsTable extends CachedLocations
    with TableInfo<$CachedLocationsTable, CachedLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dimensionMeta = const VerificationMeta(
    'dimension',
  );
  @override
  late final GeneratedColumn<String> dimension = GeneratedColumn<String>(
    'dimension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _residentUrlsMeta = const VerificationMeta(
    'residentUrls',
  );
  @override
  late final GeneratedColumn<String> residentUrls = GeneratedColumn<String>(
    'resident_urls',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    dimension,
    residentUrls,
    url,
    created,
    cachedAt,
    page,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('dimension')) {
      context.handle(
        _dimensionMeta,
        dimension.isAcceptableOrUnknown(data['dimension']!, _dimensionMeta),
      );
    } else if (isInserting) {
      context.missing(_dimensionMeta);
    }
    if (data.containsKey('resident_urls')) {
      context.handle(
        _residentUrlsMeta,
        residentUrls.isAcceptableOrUnknown(
          data['resident_urls']!,
          _residentUrlsMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      dimension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dimension'],
      )!,
      residentUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resident_urls'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
    );
  }

  @override
  $CachedLocationsTable createAlias(String alias) {
    return $CachedLocationsTable(attachedDatabase, alias);
  }
}

class CachedLocation extends DataClass implements Insertable<CachedLocation> {
  final int id;
  final String name;
  final String type;
  final String dimension;

  /// Comma-separated list of resident URLs.
  final String residentUrls;
  final String url;
  final DateTime created;

  /// Tracks when this row was last fetched from the API.
  final DateTime cachedAt;

  /// The page number this location was fetched from (for pagination cache).
  final int page;
  const CachedLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residentUrls,
    required this.url,
    required this.created,
    required this.cachedAt,
    required this.page,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['dimension'] = Variable<String>(dimension);
    map['resident_urls'] = Variable<String>(residentUrls);
    map['url'] = Variable<String>(url);
    map['created'] = Variable<DateTime>(created);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['page'] = Variable<int>(page);
    return map;
  }

  CachedLocationsCompanion toCompanion(bool nullToAbsent) {
    return CachedLocationsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      dimension: Value(dimension),
      residentUrls: Value(residentUrls),
      url: Value(url),
      created: Value(created),
      cachedAt: Value(cachedAt),
      page: Value(page),
    );
  }

  factory CachedLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      dimension: serializer.fromJson<String>(json['dimension']),
      residentUrls: serializer.fromJson<String>(json['residentUrls']),
      url: serializer.fromJson<String>(json['url']),
      created: serializer.fromJson<DateTime>(json['created']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      page: serializer.fromJson<int>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'dimension': serializer.toJson<String>(dimension),
      'residentUrls': serializer.toJson<String>(residentUrls),
      'url': serializer.toJson<String>(url),
      'created': serializer.toJson<DateTime>(created),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'page': serializer.toJson<int>(page),
    };
  }

  CachedLocation copyWith({
    int? id,
    String? name,
    String? type,
    String? dimension,
    String? residentUrls,
    String? url,
    DateTime? created,
    DateTime? cachedAt,
    int? page,
  }) => CachedLocation(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    dimension: dimension ?? this.dimension,
    residentUrls: residentUrls ?? this.residentUrls,
    url: url ?? this.url,
    created: created ?? this.created,
    cachedAt: cachedAt ?? this.cachedAt,
    page: page ?? this.page,
  );
  CachedLocation copyWithCompanion(CachedLocationsCompanion data) {
    return CachedLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      dimension: data.dimension.present ? data.dimension.value : this.dimension,
      residentUrls: data.residentUrls.present
          ? data.residentUrls.value
          : this.residentUrls,
      url: data.url.present ? data.url.value : this.url,
      created: data.created.present ? data.created.value : this.created,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dimension: $dimension, ')
          ..write('residentUrls: $residentUrls, ')
          ..write('url: $url, ')
          ..write('created: $created, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    dimension,
    residentUrls,
    url,
    created,
    cachedAt,
    page,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.dimension == this.dimension &&
          other.residentUrls == this.residentUrls &&
          other.url == this.url &&
          other.created == this.created &&
          other.cachedAt == this.cachedAt &&
          other.page == this.page);
}

class CachedLocationsCompanion extends UpdateCompanion<CachedLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> dimension;
  final Value<String> residentUrls;
  final Value<String> url;
  final Value<DateTime> created;
  final Value<DateTime> cachedAt;
  final Value<int> page;
  const CachedLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.dimension = const Value.absent(),
    this.residentUrls = const Value.absent(),
    this.url = const Value.absent(),
    this.created = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.page = const Value.absent(),
  });
  CachedLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required String dimension,
    this.residentUrls = const Value.absent(),
    required String url,
    required DateTime created,
    required DateTime cachedAt,
    this.page = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       dimension = Value(dimension),
       url = Value(url),
       created = Value(created),
       cachedAt = Value(cachedAt);
  static Insertable<CachedLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? dimension,
    Expression<String>? residentUrls,
    Expression<String>? url,
    Expression<DateTime>? created,
    Expression<DateTime>? cachedAt,
    Expression<int>? page,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (dimension != null) 'dimension': dimension,
      if (residentUrls != null) 'resident_urls': residentUrls,
      if (url != null) 'url': url,
      if (created != null) 'created': created,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (page != null) 'page': page,
    });
  }

  CachedLocationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? dimension,
    Value<String>? residentUrls,
    Value<String>? url,
    Value<DateTime>? created,
    Value<DateTime>? cachedAt,
    Value<int>? page,
  }) {
    return CachedLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dimension: dimension ?? this.dimension,
      residentUrls: residentUrls ?? this.residentUrls,
      url: url ?? this.url,
      created: created ?? this.created,
      cachedAt: cachedAt ?? this.cachedAt,
      page: page ?? this.page,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (dimension.present) {
      map['dimension'] = Variable<String>(dimension.value);
    }
    if (residentUrls.present) {
      map['resident_urls'] = Variable<String>(residentUrls.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dimension: $dimension, ')
          ..write('residentUrls: $residentUrls, ')
          ..write('url: $url, ')
          ..write('created: $created, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }
}

class $CachedCharactersTable extends CachedCharacters
    with TableInfo<$CachedCharactersTable, CachedCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    species,
    image,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCharacter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCharacter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedCharactersTable createAlias(String alias) {
    return $CachedCharactersTable(attachedDatabase, alias);
  }
}

class CachedCharacter extends DataClass implements Insertable<CachedCharacter> {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  /// Tracks when this row was last fetched from the API.
  final DateTime cachedAt;
  const CachedCharacter({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['species'] = Variable<String>(species);
    map['image'] = Variable<String>(image);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedCharactersCompanion toCompanion(bool nullToAbsent) {
    return CachedCharactersCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      species: Value(species),
      image: Value(image),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedCharacter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCharacter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      species: serializer.fromJson<String>(json['species']),
      image: serializer.fromJson<String>(json['image']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'species': serializer.toJson<String>(species),
      'image': serializer.toJson<String>(image),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedCharacter copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? image,
    DateTime? cachedAt,
  }) => CachedCharacter(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    species: species ?? this.species,
    image: image ?? this.image,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedCharacter copyWithCompanion(CachedCharactersCompanion data) {
    return CachedCharacter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      species: data.species.present ? data.species.value : this.species,
      image: data.image.present ? data.image.value : this.image,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCharacter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('species: $species, ')
          ..write('image: $image, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, status, species, image, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCharacter &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.species == this.species &&
          other.image == this.image &&
          other.cachedAt == this.cachedAt);
}

class CachedCharactersCompanion extends UpdateCompanion<CachedCharacter> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<String> species;
  final Value<String> image;
  final Value<DateTime> cachedAt;
  const CachedCharactersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.species = const Value.absent(),
    this.image = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CachedCharactersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String status,
    required String species,
    required String image,
    required DateTime cachedAt,
  }) : name = Value(name),
       status = Value(status),
       species = Value(species),
       image = Value(image),
       cachedAt = Value(cachedAt);
  static Insertable<CachedCharacter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? species,
    Expression<String>? image,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (species != null) 'species': species,
      if (image != null) 'image': image,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CachedCharactersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? status,
    Value<String>? species,
    Value<String>? image,
    Value<DateTime>? cachedAt,
  }) {
    return CachedCharactersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCharactersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('species: $species, ')
          ..write('image: $image, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedLocationsTable cachedLocations = $CachedLocationsTable(
    this,
  );
  late final $CachedCharactersTable cachedCharacters = $CachedCharactersTable(
    this,
  );
  late final LocationDao locationDao = LocationDao(this as AppDatabase);
  late final CharacterDao characterDao = CharacterDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedLocations,
    cachedCharacters,
  ];
}

typedef $$CachedLocationsTableCreateCompanionBuilder =
    CachedLocationsCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      required String dimension,
      Value<String> residentUrls,
      required String url,
      required DateTime created,
      required DateTime cachedAt,
      Value<int> page,
    });
typedef $$CachedLocationsTableUpdateCompanionBuilder =
    CachedLocationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String> dimension,
      Value<String> residentUrls,
      Value<String> url,
      Value<DateTime> created,
      Value<DateTime> cachedAt,
      Value<int> page,
    });

class $$CachedLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedLocationsTable> {
  $$CachedLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get residentUrls => $composableBuilder(
    column: $table.residentUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedLocationsTable> {
  $$CachedLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dimension => $composableBuilder(
    column: $table.dimension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get residentUrls => $composableBuilder(
    column: $table.residentUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedLocationsTable> {
  $$CachedLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get dimension =>
      $composableBuilder(column: $table.dimension, builder: (column) => column);

  GeneratedColumn<String> get residentUrls => $composableBuilder(
    column: $table.residentUrls,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);
}

class $$CachedLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedLocationsTable,
          CachedLocation,
          $$CachedLocationsTableFilterComposer,
          $$CachedLocationsTableOrderingComposer,
          $$CachedLocationsTableAnnotationComposer,
          $$CachedLocationsTableCreateCompanionBuilder,
          $$CachedLocationsTableUpdateCompanionBuilder,
          (
            CachedLocation,
            BaseReferences<
              _$AppDatabase,
              $CachedLocationsTable,
              CachedLocation
            >,
          ),
          CachedLocation,
          PrefetchHooks Function()
        > {
  $$CachedLocationsTableTableManager(
    _$AppDatabase db,
    $CachedLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> dimension = const Value.absent(),
                Value<String> residentUrls = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> page = const Value.absent(),
              }) => CachedLocationsCompanion(
                id: id,
                name: name,
                type: type,
                dimension: dimension,
                residentUrls: residentUrls,
                url: url,
                created: created,
                cachedAt: cachedAt,
                page: page,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                required String dimension,
                Value<String> residentUrls = const Value.absent(),
                required String url,
                required DateTime created,
                required DateTime cachedAt,
                Value<int> page = const Value.absent(),
              }) => CachedLocationsCompanion.insert(
                id: id,
                name: name,
                type: type,
                dimension: dimension,
                residentUrls: residentUrls,
                url: url,
                created: created,
                cachedAt: cachedAt,
                page: page,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedLocationsTable,
      CachedLocation,
      $$CachedLocationsTableFilterComposer,
      $$CachedLocationsTableOrderingComposer,
      $$CachedLocationsTableAnnotationComposer,
      $$CachedLocationsTableCreateCompanionBuilder,
      $$CachedLocationsTableUpdateCompanionBuilder,
      (
        CachedLocation,
        BaseReferences<_$AppDatabase, $CachedLocationsTable, CachedLocation>,
      ),
      CachedLocation,
      PrefetchHooks Function()
    >;
typedef $$CachedCharactersTableCreateCompanionBuilder =
    CachedCharactersCompanion Function({
      Value<int> id,
      required String name,
      required String status,
      required String species,
      required String image,
      required DateTime cachedAt,
    });
typedef $$CachedCharactersTableUpdateCompanionBuilder =
    CachedCharactersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> status,
      Value<String> species,
      Value<String> image,
      Value<DateTime> cachedAt,
    });

class $$CachedCharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCharactersTable> {
  $$CachedCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCharactersTable> {
  $$CachedCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCharactersTable> {
  $$CachedCharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedCharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCharactersTable,
          CachedCharacter,
          $$CachedCharactersTableFilterComposer,
          $$CachedCharactersTableOrderingComposer,
          $$CachedCharactersTableAnnotationComposer,
          $$CachedCharactersTableCreateCompanionBuilder,
          $$CachedCharactersTableUpdateCompanionBuilder,
          (
            CachedCharacter,
            BaseReferences<
              _$AppDatabase,
              $CachedCharactersTable,
              CachedCharacter
            >,
          ),
          CachedCharacter,
          PrefetchHooks Function()
        > {
  $$CachedCharactersTableTableManager(
    _$AppDatabase db,
    $CachedCharactersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CachedCharactersCompanion(
                id: id,
                name: name,
                status: status,
                species: species,
                image: image,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String status,
                required String species,
                required String image,
                required DateTime cachedAt,
              }) => CachedCharactersCompanion.insert(
                id: id,
                name: name,
                status: status,
                species: species,
                image: image,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCharactersTable,
      CachedCharacter,
      $$CachedCharactersTableFilterComposer,
      $$CachedCharactersTableOrderingComposer,
      $$CachedCharactersTableAnnotationComposer,
      $$CachedCharactersTableCreateCompanionBuilder,
      $$CachedCharactersTableUpdateCompanionBuilder,
      (
        CachedCharacter,
        BaseReferences<_$AppDatabase, $CachedCharactersTable, CachedCharacter>,
      ),
      CachedCharacter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedLocationsTableTableManager get cachedLocations =>
      $$CachedLocationsTableTableManager(_db, _db.cachedLocations);
  $$CachedCharactersTableTableManager get cachedCharacters =>
      $$CachedCharactersTableTableManager(_db, _db.cachedCharacters);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

/// Riverpod provider that exposes the singleton [AppDatabase] instance.
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$locationDaoHash() => r'c7d0ab4cfdf55e858785d773b01b3c5c4fb60c77';

/// Provides the [LocationDao] from the database.
///
/// Copied from [locationDao].
@ProviderFor(locationDao)
final locationDaoProvider = Provider<LocationDao>.internal(
  locationDao,
  name: r'locationDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationDaoRef = ProviderRef<LocationDao>;
String _$characterDaoHash() => r'4840034955656635804cee6715d77a8982edeeae';

/// Provides the [CharacterDao] from the database.
///
/// Copied from [characterDao].
@ProviderFor(characterDao)
final characterDaoProvider = Provider<CharacterDao>.internal(
  characterDao,
  name: r'characterDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$characterDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CharacterDaoRef = ProviderRef<CharacterDao>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
