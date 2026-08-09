// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dendro_database.dart';

// ignore_for_file: type=lint
class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, PropertyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _municipalityMeta = const VerificationMeta(
    'municipality',
  );
  @override
  late final GeneratedColumn<String> municipality = GeneratedColumn<String>(
    'municipality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('RS'),
  );
  static const VerificationMeta _totalAreaHaMeta = const VerificationMeta(
    'totalAreaHa',
  );
  @override
  late final GeneratedColumn<double> totalAreaHa = GeneratedColumn<double>(
    'total_area_ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    municipality,
    state,
    totalAreaHa,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertyRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('municipality')) {
      context.handle(
        _municipalityMeta,
        municipality.isAcceptableOrUnknown(
          data['municipality']!,
          _municipalityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_municipalityMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('total_area_ha')) {
      context.handle(
        _totalAreaHaMeta,
        totalAreaHa.isAcceptableOrUnknown(
          data['total_area_ha']!,
          _totalAreaHaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAreaHaMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      municipality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}municipality'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      totalAreaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_area_ha'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }
}

class PropertyRecord extends DataClass implements Insertable<PropertyRecord> {
  final String id;
  final String name;
  final String municipality;
  final String state;
  final double totalAreaHa;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PropertyRecord({
    required this.id,
    required this.name,
    required this.municipality,
    required this.state,
    required this.totalAreaHa,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['municipality'] = Variable<String>(municipality);
    map['state'] = Variable<String>(state);
    map['total_area_ha'] = Variable<double>(totalAreaHa);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      name: Value(name),
      municipality: Value(municipality),
      state: Value(state),
      totalAreaHa: Value(totalAreaHa),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PropertyRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      municipality: serializer.fromJson<String>(json['municipality']),
      state: serializer.fromJson<String>(json['state']),
      totalAreaHa: serializer.fromJson<double>(json['totalAreaHa']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'municipality': serializer.toJson<String>(municipality),
      'state': serializer.toJson<String>(state),
      'totalAreaHa': serializer.toJson<double>(totalAreaHa),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PropertyRecord copyWith({
    String? id,
    String? name,
    String? municipality,
    String? state,
    double? totalAreaHa,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PropertyRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    municipality: municipality ?? this.municipality,
    state: state ?? this.state,
    totalAreaHa: totalAreaHa ?? this.totalAreaHa,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PropertyRecord copyWithCompanion(PropertiesCompanion data) {
    return PropertyRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      municipality: data.municipality.present
          ? data.municipality.value
          : this.municipality,
      state: data.state.present ? data.state.value : this.state,
      totalAreaHa: data.totalAreaHa.present
          ? data.totalAreaHa.value
          : this.totalAreaHa,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('municipality: $municipality, ')
          ..write('state: $state, ')
          ..write('totalAreaHa: $totalAreaHa, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    municipality,
    state,
    totalAreaHa,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.municipality == this.municipality &&
          other.state == this.state &&
          other.totalAreaHa == this.totalAreaHa &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PropertiesCompanion extends UpdateCompanion<PropertyRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> municipality;
  final Value<String> state;
  final Value<double> totalAreaHa;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.municipality = const Value.absent(),
    this.state = const Value.absent(),
    this.totalAreaHa = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PropertiesCompanion.insert({
    required String id,
    required String name,
    required String municipality,
    this.state = const Value.absent(),
    required double totalAreaHa,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       municipality = Value(municipality),
       totalAreaHa = Value(totalAreaHa),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PropertyRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? municipality,
    Expression<String>? state,
    Expression<double>? totalAreaHa,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (municipality != null) 'municipality': municipality,
      if (state != null) 'state': state,
      if (totalAreaHa != null) 'total_area_ha': totalAreaHa,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PropertiesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? municipality,
    Value<String>? state,
    Value<double>? totalAreaHa,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      municipality: municipality ?? this.municipality,
      state: state ?? this.state,
      totalAreaHa: totalAreaHa ?? this.totalAreaHa,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (municipality.present) {
      map['municipality'] = Variable<String>(municipality.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (totalAreaHa.present) {
      map['total_area_ha'] = Variable<double>(totalAreaHa.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('municipality: $municipality, ')
          ..write('state: $state, ')
          ..write('totalAreaHa: $totalAreaHa, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeciesTable extends Species
    with TableInfo<$SpeciesTable, SpeciesRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _scientificNameMeta = const VerificationMeta(
    'scientificName',
  );
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
    'scientific_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    scientificName,
    description,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(
          data['scientific_name']!,
          _scientificNameMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      scientificName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SpeciesTable createAlias(String alias) {
    return $SpeciesTable(attachedDatabase, alias);
  }
}

class SpeciesRecord extends DataClass implements Insertable<SpeciesRecord> {
  final String id;
  final String name;
  final String? scientificName;
  final String? description;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SpeciesRecord({
    required this.id,
    required this.name,
    this.scientificName,
    this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || scientificName != null) {
      map['scientific_name'] = Variable<String>(scientificName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SpeciesCompanion toCompanion(bool nullToAbsent) {
    return SpeciesCompanion(
      id: Value(id),
      name: Value(name),
      scientificName: scientificName == null && nullToAbsent
          ? const Value.absent()
          : Value(scientificName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SpeciesRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scientificName: serializer.fromJson<String?>(json['scientificName']),
      description: serializer.fromJson<String?>(json['description']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'scientificName': serializer.toJson<String?>(scientificName),
      'description': serializer.toJson<String?>(description),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SpeciesRecord copyWith({
    String? id,
    String? name,
    Value<String?> scientificName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SpeciesRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    scientificName: scientificName.present
        ? scientificName.value
        : this.scientificName,
    description: description.present ? description.value : this.description,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SpeciesRecord copyWithCompanion(SpeciesCompanion data) {
    return SpeciesRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      description: data.description.present
          ? data.description.value
          : this.description,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scientificName: $scientificName, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    scientificName,
    description,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.scientificName == this.scientificName &&
          other.description == this.description &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SpeciesCompanion extends UpdateCompanion<SpeciesRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> scientificName;
  final Value<String?> description;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SpeciesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesCompanion.insert({
    required String id,
    required String name,
    this.scientificName = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SpeciesRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? scientificName,
    Expression<String>? description,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scientificName != null) 'scientific_name': scientificName,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? scientificName,
    Value<String?>? description,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SpeciesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      description: description ?? this.description,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scientificName: $scientificName, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormulasTable extends Formulas
    with TableInfo<$FormulasTable, FormulaRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormulasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expressionMeta = const VerificationMeta(
    'expression',
  );
  @override
  late final GeneratedColumn<String> expression = GeneratedColumn<String>(
    'expression',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    expression,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formulas';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormulaRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('expression')) {
      context.handle(
        _expressionMeta,
        expression.isAcceptableOrUnknown(data['expression']!, _expressionMeta),
      );
    } else if (isInserting) {
      context.missing(_expressionMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormulaRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormulaRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      expression: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expression'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FormulasTable createAlias(String alias) {
    return $FormulasTable(attachedDatabase, alias);
  }
}

class FormulaRecord extends DataClass implements Insertable<FormulaRecord> {
  final String id;
  final String name;
  final String? description;
  final String expression;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FormulaRecord({
    required this.id,
    required this.name,
    this.description,
    required this.expression,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['expression'] = Variable<String>(expression);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FormulasCompanion toCompanion(bool nullToAbsent) {
    return FormulasCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      expression: Value(expression),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FormulaRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormulaRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      expression: serializer.fromJson<String>(json['expression']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'expression': serializer.toJson<String>(expression),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FormulaRecord copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? expression,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FormulaRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    expression: expression ?? this.expression,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FormulaRecord copyWithCompanion(FormulasCompanion data) {
    return FormulaRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      expression: data.expression.present
          ? data.expression.value
          : this.expression,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormulaRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('expression: $expression, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    expression,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormulaRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.expression == this.expression &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FormulasCompanion extends UpdateCompanion<FormulaRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> expression;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FormulasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.expression = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormulasCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String expression,
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       expression = Value(expression),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FormulaRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? expression,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (expression != null) 'expression': expression,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormulasCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? expression,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FormulasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      expression: expression ?? this.expression,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expression.present) {
      map['expression'] = Variable<String>(expression.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormulasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('expression: $expression, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormulaVariablesTable extends FormulaVariables
    with TableInfo<$FormulaVariablesTable, FormulaVariableRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormulaVariablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formulaIdMeta = const VerificationMeta(
    'formulaId',
  );
  @override
  late final GeneratedColumn<String> formulaId = GeneratedColumn<String>(
    'formula_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES formulas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueSourceMeta = const VerificationMeta(
    'valueSource',
  );
  @override
  late final GeneratedColumn<String> valueSource = GeneratedColumn<String>(
    'value_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FormulaVariableKey, String>
  variableKey =
      GeneratedColumn<String>(
        'variable_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FormulaVariableKey>(
        $FormulaVariablesTable.$convertervariableKey,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    formulaId,
    symbol,
    label,
    unit,
    valueSource,
    variableKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formula_variables';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormulaVariableRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('formula_id')) {
      context.handle(
        _formulaIdMeta,
        formulaId.isAcceptableOrUnknown(data['formula_id']!, _formulaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('value_source')) {
      context.handle(
        _valueSourceMeta,
        valueSource.isAcceptableOrUnknown(
          data['value_source']!,
          _valueSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valueSourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormulaVariableRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormulaVariableRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      formulaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      valueSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_source'],
      )!,
      variableKey: $FormulaVariablesTable.$convertervariableKey.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}variable_key'],
        )!,
      ),
    );
  }

  @override
  $FormulaVariablesTable createAlias(String alias) {
    return $FormulaVariablesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FormulaVariableKey, String, String>
  $convertervariableKey = const EnumNameConverter<FormulaVariableKey>(
    FormulaVariableKey.values,
  );
}

class FormulaVariableRecord extends DataClass
    implements Insertable<FormulaVariableRecord> {
  final String id;
  final String formulaId;
  final String symbol;
  final String label;
  final String unit;
  final String valueSource;
  final FormulaVariableKey variableKey;
  const FormulaVariableRecord({
    required this.id,
    required this.formulaId,
    required this.symbol,
    required this.label,
    required this.unit,
    required this.valueSource,
    required this.variableKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['formula_id'] = Variable<String>(formulaId);
    map['symbol'] = Variable<String>(symbol);
    map['label'] = Variable<String>(label);
    map['unit'] = Variable<String>(unit);
    map['value_source'] = Variable<String>(valueSource);
    {
      map['variable_key'] = Variable<String>(
        $FormulaVariablesTable.$convertervariableKey.toSql(variableKey),
      );
    }
    return map;
  }

  FormulaVariablesCompanion toCompanion(bool nullToAbsent) {
    return FormulaVariablesCompanion(
      id: Value(id),
      formulaId: Value(formulaId),
      symbol: Value(symbol),
      label: Value(label),
      unit: Value(unit),
      valueSource: Value(valueSource),
      variableKey: Value(variableKey),
    );
  }

  factory FormulaVariableRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormulaVariableRecord(
      id: serializer.fromJson<String>(json['id']),
      formulaId: serializer.fromJson<String>(json['formulaId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      label: serializer.fromJson<String>(json['label']),
      unit: serializer.fromJson<String>(json['unit']),
      valueSource: serializer.fromJson<String>(json['valueSource']),
      variableKey: $FormulaVariablesTable.$convertervariableKey.fromJson(
        serializer.fromJson<String>(json['variableKey']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formulaId': serializer.toJson<String>(formulaId),
      'symbol': serializer.toJson<String>(symbol),
      'label': serializer.toJson<String>(label),
      'unit': serializer.toJson<String>(unit),
      'valueSource': serializer.toJson<String>(valueSource),
      'variableKey': serializer.toJson<String>(
        $FormulaVariablesTable.$convertervariableKey.toJson(variableKey),
      ),
    };
  }

  FormulaVariableRecord copyWith({
    String? id,
    String? formulaId,
    String? symbol,
    String? label,
    String? unit,
    String? valueSource,
    FormulaVariableKey? variableKey,
  }) => FormulaVariableRecord(
    id: id ?? this.id,
    formulaId: formulaId ?? this.formulaId,
    symbol: symbol ?? this.symbol,
    label: label ?? this.label,
    unit: unit ?? this.unit,
    valueSource: valueSource ?? this.valueSource,
    variableKey: variableKey ?? this.variableKey,
  );
  FormulaVariableRecord copyWithCompanion(FormulaVariablesCompanion data) {
    return FormulaVariableRecord(
      id: data.id.present ? data.id.value : this.id,
      formulaId: data.formulaId.present ? data.formulaId.value : this.formulaId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      label: data.label.present ? data.label.value : this.label,
      unit: data.unit.present ? data.unit.value : this.unit,
      valueSource: data.valueSource.present
          ? data.valueSource.value
          : this.valueSource,
      variableKey: data.variableKey.present
          ? data.variableKey.value
          : this.variableKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormulaVariableRecord(')
          ..write('id: $id, ')
          ..write('formulaId: $formulaId, ')
          ..write('symbol: $symbol, ')
          ..write('label: $label, ')
          ..write('unit: $unit, ')
          ..write('valueSource: $valueSource, ')
          ..write('variableKey: $variableKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, formulaId, symbol, label, unit, valueSource, variableKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormulaVariableRecord &&
          other.id == this.id &&
          other.formulaId == this.formulaId &&
          other.symbol == this.symbol &&
          other.label == this.label &&
          other.unit == this.unit &&
          other.valueSource == this.valueSource &&
          other.variableKey == this.variableKey);
}

class FormulaVariablesCompanion extends UpdateCompanion<FormulaVariableRecord> {
  final Value<String> id;
  final Value<String> formulaId;
  final Value<String> symbol;
  final Value<String> label;
  final Value<String> unit;
  final Value<String> valueSource;
  final Value<FormulaVariableKey> variableKey;
  final Value<int> rowid;
  const FormulaVariablesCompanion({
    this.id = const Value.absent(),
    this.formulaId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.label = const Value.absent(),
    this.unit = const Value.absent(),
    this.valueSource = const Value.absent(),
    this.variableKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormulaVariablesCompanion.insert({
    required String id,
    required String formulaId,
    required String symbol,
    required String label,
    required String unit,
    required String valueSource,
    required FormulaVariableKey variableKey,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       formulaId = Value(formulaId),
       symbol = Value(symbol),
       label = Value(label),
       unit = Value(unit),
       valueSource = Value(valueSource),
       variableKey = Value(variableKey);
  static Insertable<FormulaVariableRecord> custom({
    Expression<String>? id,
    Expression<String>? formulaId,
    Expression<String>? symbol,
    Expression<String>? label,
    Expression<String>? unit,
    Expression<String>? valueSource,
    Expression<String>? variableKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formulaId != null) 'formula_id': formulaId,
      if (symbol != null) 'symbol': symbol,
      if (label != null) 'label': label,
      if (unit != null) 'unit': unit,
      if (valueSource != null) 'value_source': valueSource,
      if (variableKey != null) 'variable_key': variableKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormulaVariablesCompanion copyWith({
    Value<String>? id,
    Value<String>? formulaId,
    Value<String>? symbol,
    Value<String>? label,
    Value<String>? unit,
    Value<String>? valueSource,
    Value<FormulaVariableKey>? variableKey,
    Value<int>? rowid,
  }) {
    return FormulaVariablesCompanion(
      id: id ?? this.id,
      formulaId: formulaId ?? this.formulaId,
      symbol: symbol ?? this.symbol,
      label: label ?? this.label,
      unit: unit ?? this.unit,
      valueSource: valueSource ?? this.valueSource,
      variableKey: variableKey ?? this.variableKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formulaId.present) {
      map['formula_id'] = Variable<String>(formulaId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (valueSource.present) {
      map['value_source'] = Variable<String>(valueSource.value);
    }
    if (variableKey.present) {
      map['variable_key'] = Variable<String>(
        $FormulaVariablesTable.$convertervariableKey.toSql(variableKey.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormulaVariablesCompanion(')
          ..write('id: $id, ')
          ..write('formulaId: $formulaId, ')
          ..write('symbol: $symbol, ')
          ..write('label: $label, ')
          ..write('unit: $unit, ')
          ..write('valueSource: $valueSource, ')
          ..write('variableKey: $variableKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FormulaCoefficientsTable extends FormulaCoefficients
    with TableInfo<$FormulaCoefficientsTable, FormulaCoefficientRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FormulaCoefficientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formulaIdMeta = const VerificationMeta(
    'formulaId',
  );
  @override
  late final GeneratedColumn<String> formulaId = GeneratedColumn<String>(
    'formula_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES formulas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, formulaId, symbol, label, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'formula_coefficients';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormulaCoefficientRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('formula_id')) {
      context.handle(
        _formulaIdMeta,
        formulaId.isAcceptableOrUnknown(data['formula_id']!, _formulaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FormulaCoefficientRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormulaCoefficientRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      formulaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $FormulaCoefficientsTable createAlias(String alias) {
    return $FormulaCoefficientsTable(attachedDatabase, alias);
  }
}

class FormulaCoefficientRecord extends DataClass
    implements Insertable<FormulaCoefficientRecord> {
  final String id;
  final String formulaId;
  final String symbol;
  final String label;
  final double? value;
  const FormulaCoefficientRecord({
    required this.id,
    required this.formulaId,
    required this.symbol,
    required this.label,
    this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['formula_id'] = Variable<String>(formulaId);
    map['symbol'] = Variable<String>(symbol);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    return map;
  }

  FormulaCoefficientsCompanion toCompanion(bool nullToAbsent) {
    return FormulaCoefficientsCompanion(
      id: Value(id),
      formulaId: Value(formulaId),
      symbol: Value(symbol),
      label: Value(label),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory FormulaCoefficientRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormulaCoefficientRecord(
      id: serializer.fromJson<String>(json['id']),
      formulaId: serializer.fromJson<String>(json['formulaId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<double?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'formulaId': serializer.toJson<String>(formulaId),
      'symbol': serializer.toJson<String>(symbol),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<double?>(value),
    };
  }

  FormulaCoefficientRecord copyWith({
    String? id,
    String? formulaId,
    String? symbol,
    String? label,
    Value<double?> value = const Value.absent(),
  }) => FormulaCoefficientRecord(
    id: id ?? this.id,
    formulaId: formulaId ?? this.formulaId,
    symbol: symbol ?? this.symbol,
    label: label ?? this.label,
    value: value.present ? value.value : this.value,
  );
  FormulaCoefficientRecord copyWithCompanion(
    FormulaCoefficientsCompanion data,
  ) {
    return FormulaCoefficientRecord(
      id: data.id.present ? data.id.value : this.id,
      formulaId: data.formulaId.present ? data.formulaId.value : this.formulaId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormulaCoefficientRecord(')
          ..write('id: $id, ')
          ..write('formulaId: $formulaId, ')
          ..write('symbol: $symbol, ')
          ..write('label: $label, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, formulaId, symbol, label, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormulaCoefficientRecord &&
          other.id == this.id &&
          other.formulaId == this.formulaId &&
          other.symbol == this.symbol &&
          other.label == this.label &&
          other.value == this.value);
}

class FormulaCoefficientsCompanion
    extends UpdateCompanion<FormulaCoefficientRecord> {
  final Value<String> id;
  final Value<String> formulaId;
  final Value<String> symbol;
  final Value<String> label;
  final Value<double?> value;
  final Value<int> rowid;
  const FormulaCoefficientsCompanion({
    this.id = const Value.absent(),
    this.formulaId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormulaCoefficientsCompanion.insert({
    required String id,
    required String formulaId,
    required String symbol,
    required String label,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       formulaId = Value(formulaId),
       symbol = Value(symbol),
       label = Value(label);
  static Insertable<FormulaCoefficientRecord> custom({
    Expression<String>? id,
    Expression<String>? formulaId,
    Expression<String>? symbol,
    Expression<String>? label,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (formulaId != null) 'formula_id': formulaId,
      if (symbol != null) 'symbol': symbol,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormulaCoefficientsCompanion copyWith({
    Value<String>? id,
    Value<String>? formulaId,
    Value<String>? symbol,
    Value<String>? label,
    Value<double?>? value,
    Value<int>? rowid,
  }) {
    return FormulaCoefficientsCompanion(
      id: id ?? this.id,
      formulaId: formulaId ?? this.formulaId,
      symbol: symbol ?? this.symbol,
      label: label ?? this.label,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (formulaId.present) {
      map['formula_id'] = Variable<String>(formulaId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormulaCoefficientsCompanion(')
          ..write('id: $id, ')
          ..write('formulaId: $formulaId, ')
          ..write('symbol: $symbol, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeciesFormulasTable extends SpeciesFormulas
    with TableInfo<$SpeciesFormulasTable, SpeciesFormulaRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesFormulasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES species (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _formulaIdMeta = const VerificationMeta(
    'formulaId',
  );
  @override
  late final GeneratedColumn<String> formulaId = GeneratedColumn<String>(
    'formula_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES formulas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    speciesId,
    formulaId,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species_formulas';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesFormulaRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('formula_id')) {
      context.handle(
        _formulaIdMeta,
        formulaId.isAcceptableOrUnknown(data['formula_id']!, _formulaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaIdMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {speciesId, formulaId};
  @override
  SpeciesFormulaRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesFormulaRecord(
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      formulaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_id'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SpeciesFormulasTable createAlias(String alias) {
    return $SpeciesFormulasTable(attachedDatabase, alias);
  }
}

class SpeciesFormulaRecord extends DataClass
    implements Insertable<SpeciesFormulaRecord> {
  final String speciesId;
  final String formulaId;
  final bool isDefault;
  final DateTime createdAt;
  const SpeciesFormulaRecord({
    required this.speciesId,
    required this.formulaId,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['species_id'] = Variable<String>(speciesId);
    map['formula_id'] = Variable<String>(formulaId);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SpeciesFormulasCompanion toCompanion(bool nullToAbsent) {
    return SpeciesFormulasCompanion(
      speciesId: Value(speciesId),
      formulaId: Value(formulaId),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory SpeciesFormulaRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesFormulaRecord(
      speciesId: serializer.fromJson<String>(json['speciesId']),
      formulaId: serializer.fromJson<String>(json['formulaId']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'speciesId': serializer.toJson<String>(speciesId),
      'formulaId': serializer.toJson<String>(formulaId),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SpeciesFormulaRecord copyWith({
    String? speciesId,
    String? formulaId,
    bool? isDefault,
    DateTime? createdAt,
  }) => SpeciesFormulaRecord(
    speciesId: speciesId ?? this.speciesId,
    formulaId: formulaId ?? this.formulaId,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  SpeciesFormulaRecord copyWithCompanion(SpeciesFormulasCompanion data) {
    return SpeciesFormulaRecord(
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      formulaId: data.formulaId.present ? data.formulaId.value : this.formulaId,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesFormulaRecord(')
          ..write('speciesId: $speciesId, ')
          ..write('formulaId: $formulaId, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(speciesId, formulaId, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesFormulaRecord &&
          other.speciesId == this.speciesId &&
          other.formulaId == this.formulaId &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class SpeciesFormulasCompanion extends UpdateCompanion<SpeciesFormulaRecord> {
  final Value<String> speciesId;
  final Value<String> formulaId;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SpeciesFormulasCompanion({
    this.speciesId = const Value.absent(),
    this.formulaId = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesFormulasCompanion.insert({
    required String speciesId,
    required String formulaId,
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : speciesId = Value(speciesId),
       formulaId = Value(formulaId),
       createdAt = Value(createdAt);
  static Insertable<SpeciesFormulaRecord> custom({
    Expression<String>? speciesId,
    Expression<String>? formulaId,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (speciesId != null) 'species_id': speciesId,
      if (formulaId != null) 'formula_id': formulaId,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesFormulasCompanion copyWith({
    Value<String>? speciesId,
    Value<String>? formulaId,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SpeciesFormulasCompanion(
      speciesId: speciesId ?? this.speciesId,
      formulaId: formulaId ?? this.formulaId,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (formulaId.present) {
      map['formula_id'] = Variable<String>(formulaId.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesFormulasCompanion(')
          ..write('speciesId: $speciesId, ')
          ..write('formulaId: $formulaId, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StandsTable extends Stands with TableInfo<$StandsTable, StandRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _identificationMeta = const VerificationMeta(
    'identification',
  );
  @override
  late final GeneratedColumn<String> identification = GeneratedColumn<String>(
    'identification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES species (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _areaHaMeta = const VerificationMeta('areaHa');
  @override
  late final GeneratedColumn<double> areaHa = GeneratedColumn<double>(
    'area_ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantingYearMeta = const VerificationMeta(
    'plantingYear',
  );
  @override
  late final GeneratedColumn<int> plantingYear = GeneratedColumn<int>(
    'planting_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spacingMeta = const VerificationMeta(
    'spacing',
  );
  @override
  late final GeneratedColumn<String> spacing = GeneratedColumn<String>(
    'spacing',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _managementRegimeMeta = const VerificationMeta(
    'managementRegime',
  );
  @override
  late final GeneratedColumn<String> managementRegime = GeneratedColumn<String>(
    'management_regime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    identification,
    speciesId,
    areaHa,
    plantingYear,
    spacing,
    managementRegime,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stands';
  @override
  VerificationContext validateIntegrity(
    Insertable<StandRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('identification')) {
      context.handle(
        _identificationMeta,
        identification.isAcceptableOrUnknown(
          data['identification']!,
          _identificationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identificationMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('area_ha')) {
      context.handle(
        _areaHaMeta,
        areaHa.isAcceptableOrUnknown(data['area_ha']!, _areaHaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaHaMeta);
    }
    if (data.containsKey('planting_year')) {
      context.handle(
        _plantingYearMeta,
        plantingYear.isAcceptableOrUnknown(
          data['planting_year']!,
          _plantingYearMeta,
        ),
      );
    }
    if (data.containsKey('spacing')) {
      context.handle(
        _spacingMeta,
        spacing.isAcceptableOrUnknown(data['spacing']!, _spacingMeta),
      );
    }
    if (data.containsKey('management_regime')) {
      context.handle(
        _managementRegimeMeta,
        managementRegime.isAcceptableOrUnknown(
          data['management_regime']!,
          _managementRegimeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StandRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StandRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      identification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identification'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      areaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_ha'],
      )!,
      plantingYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planting_year'],
      ),
      spacing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spacing'],
      ),
      managementRegime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}management_regime'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StandsTable createAlias(String alias) {
    return $StandsTable(attachedDatabase, alias);
  }
}

class StandRecord extends DataClass implements Insertable<StandRecord> {
  final String id;
  final String propertyId;
  final String identification;
  final String speciesId;
  final double areaHa;
  final int? plantingYear;
  final String? spacing;
  final String? managementRegime;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StandRecord({
    required this.id,
    required this.propertyId,
    required this.identification,
    required this.speciesId,
    required this.areaHa,
    this.plantingYear,
    this.spacing,
    this.managementRegime,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['property_id'] = Variable<String>(propertyId);
    map['identification'] = Variable<String>(identification);
    map['species_id'] = Variable<String>(speciesId);
    map['area_ha'] = Variable<double>(areaHa);
    if (!nullToAbsent || plantingYear != null) {
      map['planting_year'] = Variable<int>(plantingYear);
    }
    if (!nullToAbsent || spacing != null) {
      map['spacing'] = Variable<String>(spacing);
    }
    if (!nullToAbsent || managementRegime != null) {
      map['management_regime'] = Variable<String>(managementRegime);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StandsCompanion toCompanion(bool nullToAbsent) {
    return StandsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      identification: Value(identification),
      speciesId: Value(speciesId),
      areaHa: Value(areaHa),
      plantingYear: plantingYear == null && nullToAbsent
          ? const Value.absent()
          : Value(plantingYear),
      spacing: spacing == null && nullToAbsent
          ? const Value.absent()
          : Value(spacing),
      managementRegime: managementRegime == null && nullToAbsent
          ? const Value.absent()
          : Value(managementRegime),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StandRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StandRecord(
      id: serializer.fromJson<String>(json['id']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      identification: serializer.fromJson<String>(json['identification']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      areaHa: serializer.fromJson<double>(json['areaHa']),
      plantingYear: serializer.fromJson<int?>(json['plantingYear']),
      spacing: serializer.fromJson<String?>(json['spacing']),
      managementRegime: serializer.fromJson<String?>(json['managementRegime']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'propertyId': serializer.toJson<String>(propertyId),
      'identification': serializer.toJson<String>(identification),
      'speciesId': serializer.toJson<String>(speciesId),
      'areaHa': serializer.toJson<double>(areaHa),
      'plantingYear': serializer.toJson<int?>(plantingYear),
      'spacing': serializer.toJson<String?>(spacing),
      'managementRegime': serializer.toJson<String?>(managementRegime),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StandRecord copyWith({
    String? id,
    String? propertyId,
    String? identification,
    String? speciesId,
    double? areaHa,
    Value<int?> plantingYear = const Value.absent(),
    Value<String?> spacing = const Value.absent(),
    Value<String?> managementRegime = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StandRecord(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    identification: identification ?? this.identification,
    speciesId: speciesId ?? this.speciesId,
    areaHa: areaHa ?? this.areaHa,
    plantingYear: plantingYear.present ? plantingYear.value : this.plantingYear,
    spacing: spacing.present ? spacing.value : this.spacing,
    managementRegime: managementRegime.present
        ? managementRegime.value
        : this.managementRegime,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StandRecord copyWithCompanion(StandsCompanion data) {
    return StandRecord(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      identification: data.identification.present
          ? data.identification.value
          : this.identification,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      areaHa: data.areaHa.present ? data.areaHa.value : this.areaHa,
      plantingYear: data.plantingYear.present
          ? data.plantingYear.value
          : this.plantingYear,
      spacing: data.spacing.present ? data.spacing.value : this.spacing,
      managementRegime: data.managementRegime.present
          ? data.managementRegime.value
          : this.managementRegime,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StandRecord(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('identification: $identification, ')
          ..write('speciesId: $speciesId, ')
          ..write('areaHa: $areaHa, ')
          ..write('plantingYear: $plantingYear, ')
          ..write('spacing: $spacing, ')
          ..write('managementRegime: $managementRegime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propertyId,
    identification,
    speciesId,
    areaHa,
    plantingYear,
    spacing,
    managementRegime,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StandRecord &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.identification == this.identification &&
          other.speciesId == this.speciesId &&
          other.areaHa == this.areaHa &&
          other.plantingYear == this.plantingYear &&
          other.spacing == this.spacing &&
          other.managementRegime == this.managementRegime &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StandsCompanion extends UpdateCompanion<StandRecord> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<String> identification;
  final Value<String> speciesId;
  final Value<double> areaHa;
  final Value<int?> plantingYear;
  final Value<String?> spacing;
  final Value<String?> managementRegime;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StandsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.identification = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.plantingYear = const Value.absent(),
    this.spacing = const Value.absent(),
    this.managementRegime = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StandsCompanion.insert({
    required String id,
    required String propertyId,
    required String identification,
    required String speciesId,
    required double areaHa,
    this.plantingYear = const Value.absent(),
    this.spacing = const Value.absent(),
    this.managementRegime = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       identification = Value(identification),
       speciesId = Value(speciesId),
       areaHa = Value(areaHa),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StandRecord> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? identification,
    Expression<String>? speciesId,
    Expression<double>? areaHa,
    Expression<int>? plantingYear,
    Expression<String>? spacing,
    Expression<String>? managementRegime,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (identification != null) 'identification': identification,
      if (speciesId != null) 'species_id': speciesId,
      if (areaHa != null) 'area_ha': areaHa,
      if (plantingYear != null) 'planting_year': plantingYear,
      if (spacing != null) 'spacing': spacing,
      if (managementRegime != null) 'management_regime': managementRegime,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StandsCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<String>? identification,
    Value<String>? speciesId,
    Value<double>? areaHa,
    Value<int?>? plantingYear,
    Value<String?>? spacing,
    Value<String?>? managementRegime,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StandsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      identification: identification ?? this.identification,
      speciesId: speciesId ?? this.speciesId,
      areaHa: areaHa ?? this.areaHa,
      plantingYear: plantingYear ?? this.plantingYear,
      spacing: spacing ?? this.spacing,
      managementRegime: managementRegime ?? this.managementRegime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (identification.present) {
      map['identification'] = Variable<String>(identification.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (areaHa.present) {
      map['area_ha'] = Variable<double>(areaHa.value);
    }
    if (plantingYear.present) {
      map['planting_year'] = Variable<int>(plantingYear.value);
    }
    if (spacing.present) {
      map['spacing'] = Variable<String>(spacing.value);
    }
    if (managementRegime.present) {
      map['management_regime'] = Variable<String>(managementRegime.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StandsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('identification: $identification, ')
          ..write('speciesId: $speciesId, ')
          ..write('areaHa: $areaHa, ')
          ..write('plantingYear: $plantingYear, ')
          ..write('spacing: $spacing, ')
          ..write('managementRegime: $managementRegime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryRunsTable extends InventoryRuns
    with TableInfo<$InventoryRunsTable, InventoryRunRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<String> propertyId = GeneratedColumn<String>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InventoryRunStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<InventoryRunStatus>($InventoryRunsTable.$converterstatus);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    status,
    startedAt,
    updatedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryRunRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryRunRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryRunRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}property_id'],
      )!,
      status: $InventoryRunsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $InventoryRunsTable createAlias(String alias) {
    return $InventoryRunsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InventoryRunStatus, String, String>
  $converterstatus = const EnumNameConverter<InventoryRunStatus>(
    InventoryRunStatus.values,
  );
}

class InventoryRunRecord extends DataClass
    implements Insertable<InventoryRunRecord> {
  final String id;
  final String propertyId;
  final InventoryRunStatus status;
  final DateTime startedAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  const InventoryRunRecord({
    required this.id,
    required this.propertyId,
    required this.status,
    required this.startedAt,
    required this.updatedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['property_id'] = Variable<String>(propertyId);
    {
      map['status'] = Variable<String>(
        $InventoryRunsTable.$converterstatus.toSql(status),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  InventoryRunsCompanion toCompanion(bool nullToAbsent) {
    return InventoryRunsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      status: Value(status),
      startedAt: Value(startedAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory InventoryRunRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryRunRecord(
      id: serializer.fromJson<String>(json['id']),
      propertyId: serializer.fromJson<String>(json['propertyId']),
      status: $InventoryRunsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'propertyId': serializer.toJson<String>(propertyId),
      'status': serializer.toJson<String>(
        $InventoryRunsTable.$converterstatus.toJson(status),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  InventoryRunRecord copyWith({
    String? id,
    String? propertyId,
    InventoryRunStatus? status,
    DateTime? startedAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => InventoryRunRecord(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  InventoryRunRecord copyWithCompanion(InventoryRunsCompanion data) {
    return InventoryRunRecord(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryRunRecord(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, propertyId, status, startedAt, updatedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryRunRecord &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class InventoryRunsCompanion extends UpdateCompanion<InventoryRunRecord> {
  final Value<String> id;
  final Value<String> propertyId;
  final Value<InventoryRunStatus> status;
  final Value<DateTime> startedAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const InventoryRunsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryRunsCompanion.insert({
    required String id,
    required String propertyId,
    required InventoryRunStatus status,
    required DateTime startedAt,
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       propertyId = Value(propertyId),
       status = Value(status),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<InventoryRunRecord> custom({
    Expression<String>? id,
    Expression<String>? propertyId,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryRunsCompanion copyWith({
    Value<String>? id,
    Value<String>? propertyId,
    Value<InventoryRunStatus>? status,
    Value<DateTime>? startedAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return InventoryRunsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<String>(propertyId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InventoryRunsTable.$converterstatus.toSql(status.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryRunsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TalhaoLevantamentosTable extends TalhaoLevantamentos
    with TableInfo<$TalhaoLevantamentosTable, TalhaoLevantamentoRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalhaoLevantamentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inventoryRunIdMeta = const VerificationMeta(
    'inventoryRunId',
  );
  @override
  late final GeneratedColumn<String> inventoryRunId = GeneratedColumn<String>(
    'inventory_run_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inventory_runs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _standIdMeta = const VerificationMeta(
    'standId',
  );
  @override
  late final GeneratedColumn<String> standId = GeneratedColumn<String>(
    'stand_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stands (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES species (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _formulaIdMeta = const VerificationMeta(
    'formulaId',
  );
  @override
  late final GeneratedColumn<String> formulaId = GeneratedColumn<String>(
    'formula_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES formulas (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _defaultPlotAreaHaMeta = const VerificationMeta(
    'defaultPlotAreaHa',
  );
  @override
  late final GeneratedColumn<double> defaultPlotAreaHa =
      GeneratedColumn<double>(
        'default_plot_area_ha',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inventoryRunId,
    standId,
    speciesId,
    formulaId,
    defaultPlotAreaHa,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talhao_levantamentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<TalhaoLevantamentoRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('inventory_run_id')) {
      context.handle(
        _inventoryRunIdMeta,
        inventoryRunId.isAcceptableOrUnknown(
          data['inventory_run_id']!,
          _inventoryRunIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inventoryRunIdMeta);
    }
    if (data.containsKey('stand_id')) {
      context.handle(
        _standIdMeta,
        standId.isAcceptableOrUnknown(data['stand_id']!, _standIdMeta),
      );
    } else if (isInserting) {
      context.missing(_standIdMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('formula_id')) {
      context.handle(
        _formulaIdMeta,
        formulaId.isAcceptableOrUnknown(data['formula_id']!, _formulaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaIdMeta);
    }
    if (data.containsKey('default_plot_area_ha')) {
      context.handle(
        _defaultPlotAreaHaMeta,
        defaultPlotAreaHa.isAcceptableOrUnknown(
          data['default_plot_area_ha']!,
          _defaultPlotAreaHaMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TalhaoLevantamentoRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TalhaoLevantamentoRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      inventoryRunId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventory_run_id'],
      )!,
      standId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stand_id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      )!,
      formulaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_id'],
      )!,
      defaultPlotAreaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_plot_area_ha'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TalhaoLevantamentosTable createAlias(String alias) {
    return $TalhaoLevantamentosTable(attachedDatabase, alias);
  }
}

class TalhaoLevantamentoRecord extends DataClass
    implements Insertable<TalhaoLevantamentoRecord> {
  final String id;
  final String inventoryRunId;
  final String standId;
  final String speciesId;
  final String formulaId;
  final double? defaultPlotAreaHa;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TalhaoLevantamentoRecord({
    required this.id,
    required this.inventoryRunId,
    required this.standId,
    required this.speciesId,
    required this.formulaId,
    this.defaultPlotAreaHa,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['inventory_run_id'] = Variable<String>(inventoryRunId);
    map['stand_id'] = Variable<String>(standId);
    map['species_id'] = Variable<String>(speciesId);
    map['formula_id'] = Variable<String>(formulaId);
    if (!nullToAbsent || defaultPlotAreaHa != null) {
      map['default_plot_area_ha'] = Variable<double>(defaultPlotAreaHa);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TalhaoLevantamentosCompanion toCompanion(bool nullToAbsent) {
    return TalhaoLevantamentosCompanion(
      id: Value(id),
      inventoryRunId: Value(inventoryRunId),
      standId: Value(standId),
      speciesId: Value(speciesId),
      formulaId: Value(formulaId),
      defaultPlotAreaHa: defaultPlotAreaHa == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPlotAreaHa),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TalhaoLevantamentoRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TalhaoLevantamentoRecord(
      id: serializer.fromJson<String>(json['id']),
      inventoryRunId: serializer.fromJson<String>(json['inventoryRunId']),
      standId: serializer.fromJson<String>(json['standId']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      formulaId: serializer.fromJson<String>(json['formulaId']),
      defaultPlotAreaHa: serializer.fromJson<double?>(
        json['defaultPlotAreaHa'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'inventoryRunId': serializer.toJson<String>(inventoryRunId),
      'standId': serializer.toJson<String>(standId),
      'speciesId': serializer.toJson<String>(speciesId),
      'formulaId': serializer.toJson<String>(formulaId),
      'defaultPlotAreaHa': serializer.toJson<double?>(defaultPlotAreaHa),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TalhaoLevantamentoRecord copyWith({
    String? id,
    String? inventoryRunId,
    String? standId,
    String? speciesId,
    String? formulaId,
    Value<double?> defaultPlotAreaHa = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TalhaoLevantamentoRecord(
    id: id ?? this.id,
    inventoryRunId: inventoryRunId ?? this.inventoryRunId,
    standId: standId ?? this.standId,
    speciesId: speciesId ?? this.speciesId,
    formulaId: formulaId ?? this.formulaId,
    defaultPlotAreaHa: defaultPlotAreaHa.present
        ? defaultPlotAreaHa.value
        : this.defaultPlotAreaHa,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TalhaoLevantamentoRecord copyWithCompanion(
    TalhaoLevantamentosCompanion data,
  ) {
    return TalhaoLevantamentoRecord(
      id: data.id.present ? data.id.value : this.id,
      inventoryRunId: data.inventoryRunId.present
          ? data.inventoryRunId.value
          : this.inventoryRunId,
      standId: data.standId.present ? data.standId.value : this.standId,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      formulaId: data.formulaId.present ? data.formulaId.value : this.formulaId,
      defaultPlotAreaHa: data.defaultPlotAreaHa.present
          ? data.defaultPlotAreaHa.value
          : this.defaultPlotAreaHa,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TalhaoLevantamentoRecord(')
          ..write('id: $id, ')
          ..write('inventoryRunId: $inventoryRunId, ')
          ..write('standId: $standId, ')
          ..write('speciesId: $speciesId, ')
          ..write('formulaId: $formulaId, ')
          ..write('defaultPlotAreaHa: $defaultPlotAreaHa, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inventoryRunId,
    standId,
    speciesId,
    formulaId,
    defaultPlotAreaHa,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TalhaoLevantamentoRecord &&
          other.id == this.id &&
          other.inventoryRunId == this.inventoryRunId &&
          other.standId == this.standId &&
          other.speciesId == this.speciesId &&
          other.formulaId == this.formulaId &&
          other.defaultPlotAreaHa == this.defaultPlotAreaHa &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TalhaoLevantamentosCompanion
    extends UpdateCompanion<TalhaoLevantamentoRecord> {
  final Value<String> id;
  final Value<String> inventoryRunId;
  final Value<String> standId;
  final Value<String> speciesId;
  final Value<String> formulaId;
  final Value<double?> defaultPlotAreaHa;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TalhaoLevantamentosCompanion({
    this.id = const Value.absent(),
    this.inventoryRunId = const Value.absent(),
    this.standId = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.formulaId = const Value.absent(),
    this.defaultPlotAreaHa = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TalhaoLevantamentosCompanion.insert({
    required String id,
    required String inventoryRunId,
    required String standId,
    required String speciesId,
    required String formulaId,
    this.defaultPlotAreaHa = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       inventoryRunId = Value(inventoryRunId),
       standId = Value(standId),
       speciesId = Value(speciesId),
       formulaId = Value(formulaId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TalhaoLevantamentoRecord> custom({
    Expression<String>? id,
    Expression<String>? inventoryRunId,
    Expression<String>? standId,
    Expression<String>? speciesId,
    Expression<String>? formulaId,
    Expression<double>? defaultPlotAreaHa,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inventoryRunId != null) 'inventory_run_id': inventoryRunId,
      if (standId != null) 'stand_id': standId,
      if (speciesId != null) 'species_id': speciesId,
      if (formulaId != null) 'formula_id': formulaId,
      if (defaultPlotAreaHa != null) 'default_plot_area_ha': defaultPlotAreaHa,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TalhaoLevantamentosCompanion copyWith({
    Value<String>? id,
    Value<String>? inventoryRunId,
    Value<String>? standId,
    Value<String>? speciesId,
    Value<String>? formulaId,
    Value<double?>? defaultPlotAreaHa,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TalhaoLevantamentosCompanion(
      id: id ?? this.id,
      inventoryRunId: inventoryRunId ?? this.inventoryRunId,
      standId: standId ?? this.standId,
      speciesId: speciesId ?? this.speciesId,
      formulaId: formulaId ?? this.formulaId,
      defaultPlotAreaHa: defaultPlotAreaHa ?? this.defaultPlotAreaHa,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (inventoryRunId.present) {
      map['inventory_run_id'] = Variable<String>(inventoryRunId.value);
    }
    if (standId.present) {
      map['stand_id'] = Variable<String>(standId.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (formulaId.present) {
      map['formula_id'] = Variable<String>(formulaId.value);
    }
    if (defaultPlotAreaHa.present) {
      map['default_plot_area_ha'] = Variable<double>(defaultPlotAreaHa.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalhaoLevantamentosCompanion(')
          ..write('id: $id, ')
          ..write('inventoryRunId: $inventoryRunId, ')
          ..write('standId: $standId, ')
          ..write('speciesId: $speciesId, ')
          ..write('formulaId: $formulaId, ')
          ..write('defaultPlotAreaHa: $defaultPlotAreaHa, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlotsTable extends Plots with TableInfo<$PlotsTable, PlotRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _talhaoLevantamentoIdMeta =
      const VerificationMeta('talhaoLevantamentoId');
  @override
  late final GeneratedColumn<String> talhaoLevantamentoId =
      GeneratedColumn<String>(
        'talhao_levantamento_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES talhao_levantamentos (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _identificationMeta = const VerificationMeta(
    'identification',
  );
  @override
  late final GeneratedColumn<String> identification = GeneratedColumn<String>(
    'identification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlotStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlotStatus>($PlotsTable.$converterstatus);
  static const VerificationMeta _areaHaMeta = const VerificationMeta('areaHa');
  @override
  late final GeneratedColumn<double> areaHa = GeneratedColumn<double>(
    'area_ha',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  referencePosition =
      GeneratedColumn<String>(
        'reference_position',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PlotReferencePosition?>(
        $PlotsTable.$converterreferencePositionn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    talhaoLevantamentoId,
    identification,
    status,
    areaHa,
    referencePosition,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plots';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlotRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('talhao_levantamento_id')) {
      context.handle(
        _talhaoLevantamentoIdMeta,
        talhaoLevantamentoId.isAcceptableOrUnknown(
          data['talhao_levantamento_id']!,
          _talhaoLevantamentoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_talhaoLevantamentoIdMeta);
    }
    if (data.containsKey('identification')) {
      context.handle(
        _identificationMeta,
        identification.isAcceptableOrUnknown(
          data['identification']!,
          _identificationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identificationMeta);
    }
    if (data.containsKey('area_ha')) {
      context.handle(
        _areaHaMeta,
        areaHa.isAcceptableOrUnknown(data['area_ha']!, _areaHaMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlotRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlotRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      talhaoLevantamentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}talhao_levantamento_id'],
      )!,
      identification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identification'],
      )!,
      status: $PlotsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      areaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_ha'],
      ),
      referencePosition: $PlotsTable.$converterreferencePositionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reference_position'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlotsTable createAlias(String alias) {
    return $PlotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlotStatus, String, String> $converterstatus =
      const EnumNameConverter<PlotStatus>(PlotStatus.values);
  static JsonTypeConverter2<PlotReferencePosition, String, String>
  $converterreferencePosition = const EnumNameConverter<PlotReferencePosition>(
    PlotReferencePosition.values,
  );
  static JsonTypeConverter2<PlotReferencePosition?, String?, String?>
  $converterreferencePositionn = JsonTypeConverter2.asNullable(
    $converterreferencePosition,
  );
}

class PlotRecord extends DataClass implements Insertable<PlotRecord> {
  final String id;
  final String talhaoLevantamentoId;
  final String identification;
  final PlotStatus status;
  final double? areaHa;
  final PlotReferencePosition? referencePosition;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlotRecord({
    required this.id,
    required this.talhaoLevantamentoId,
    required this.identification,
    required this.status,
    this.areaHa,
    this.referencePosition,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['talhao_levantamento_id'] = Variable<String>(talhaoLevantamentoId);
    map['identification'] = Variable<String>(identification);
    {
      map['status'] = Variable<String>(
        $PlotsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || areaHa != null) {
      map['area_ha'] = Variable<double>(areaHa);
    }
    if (!nullToAbsent || referencePosition != null) {
      map['reference_position'] = Variable<String>(
        $PlotsTable.$converterreferencePositionn.toSql(referencePosition),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlotsCompanion toCompanion(bool nullToAbsent) {
    return PlotsCompanion(
      id: Value(id),
      talhaoLevantamentoId: Value(talhaoLevantamentoId),
      identification: Value(identification),
      status: Value(status),
      areaHa: areaHa == null && nullToAbsent
          ? const Value.absent()
          : Value(areaHa),
      referencePosition: referencePosition == null && nullToAbsent
          ? const Value.absent()
          : Value(referencePosition),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlotRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlotRecord(
      id: serializer.fromJson<String>(json['id']),
      talhaoLevantamentoId: serializer.fromJson<String>(
        json['talhaoLevantamentoId'],
      ),
      identification: serializer.fromJson<String>(json['identification']),
      status: $PlotsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      areaHa: serializer.fromJson<double?>(json['areaHa']),
      referencePosition: $PlotsTable.$converterreferencePositionn.fromJson(
        serializer.fromJson<String?>(json['referencePosition']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'talhaoLevantamentoId': serializer.toJson<String>(talhaoLevantamentoId),
      'identification': serializer.toJson<String>(identification),
      'status': serializer.toJson<String>(
        $PlotsTable.$converterstatus.toJson(status),
      ),
      'areaHa': serializer.toJson<double?>(areaHa),
      'referencePosition': serializer.toJson<String?>(
        $PlotsTable.$converterreferencePositionn.toJson(referencePosition),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlotRecord copyWith({
    String? id,
    String? talhaoLevantamentoId,
    String? identification,
    PlotStatus? status,
    Value<double?> areaHa = const Value.absent(),
    Value<PlotReferencePosition?> referencePosition = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlotRecord(
    id: id ?? this.id,
    talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
    identification: identification ?? this.identification,
    status: status ?? this.status,
    areaHa: areaHa.present ? areaHa.value : this.areaHa,
    referencePosition: referencePosition.present
        ? referencePosition.value
        : this.referencePosition,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlotRecord copyWithCompanion(PlotsCompanion data) {
    return PlotRecord(
      id: data.id.present ? data.id.value : this.id,
      talhaoLevantamentoId: data.talhaoLevantamentoId.present
          ? data.talhaoLevantamentoId.value
          : this.talhaoLevantamentoId,
      identification: data.identification.present
          ? data.identification.value
          : this.identification,
      status: data.status.present ? data.status.value : this.status,
      areaHa: data.areaHa.present ? data.areaHa.value : this.areaHa,
      referencePosition: data.referencePosition.present
          ? data.referencePosition.value
          : this.referencePosition,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlotRecord(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('identification: $identification, ')
          ..write('status: $status, ')
          ..write('areaHa: $areaHa, ')
          ..write('referencePosition: $referencePosition, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    talhaoLevantamentoId,
    identification,
    status,
    areaHa,
    referencePosition,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlotRecord &&
          other.id == this.id &&
          other.talhaoLevantamentoId == this.talhaoLevantamentoId &&
          other.identification == this.identification &&
          other.status == this.status &&
          other.areaHa == this.areaHa &&
          other.referencePosition == this.referencePosition &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlotsCompanion extends UpdateCompanion<PlotRecord> {
  final Value<String> id;
  final Value<String> talhaoLevantamentoId;
  final Value<String> identification;
  final Value<PlotStatus> status;
  final Value<double?> areaHa;
  final Value<PlotReferencePosition?> referencePosition;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlotsCompanion({
    this.id = const Value.absent(),
    this.talhaoLevantamentoId = const Value.absent(),
    this.identification = const Value.absent(),
    this.status = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.referencePosition = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlotsCompanion.insert({
    required String id,
    required String talhaoLevantamentoId,
    required String identification,
    required PlotStatus status,
    this.areaHa = const Value.absent(),
    this.referencePosition = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       talhaoLevantamentoId = Value(talhaoLevantamentoId),
       identification = Value(identification),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlotRecord> custom({
    Expression<String>? id,
    Expression<String>? talhaoLevantamentoId,
    Expression<String>? identification,
    Expression<String>? status,
    Expression<double>? areaHa,
    Expression<String>? referencePosition,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (talhaoLevantamentoId != null)
        'talhao_levantamento_id': talhaoLevantamentoId,
      if (identification != null) 'identification': identification,
      if (status != null) 'status': status,
      if (areaHa != null) 'area_ha': areaHa,
      if (referencePosition != null) 'reference_position': referencePosition,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlotsCompanion copyWith({
    Value<String>? id,
    Value<String>? talhaoLevantamentoId,
    Value<String>? identification,
    Value<PlotStatus>? status,
    Value<double?>? areaHa,
    Value<PlotReferencePosition?>? referencePosition,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlotsCompanion(
      id: id ?? this.id,
      talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
      identification: identification ?? this.identification,
      status: status ?? this.status,
      areaHa: areaHa ?? this.areaHa,
      referencePosition: referencePosition ?? this.referencePosition,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (talhaoLevantamentoId.present) {
      map['talhao_levantamento_id'] = Variable<String>(
        talhaoLevantamentoId.value,
      );
    }
    if (identification.present) {
      map['identification'] = Variable<String>(identification.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PlotsTable.$converterstatus.toSql(status.value),
      );
    }
    if (areaHa.present) {
      map['area_ha'] = Variable<double>(areaHa.value);
    }
    if (referencePosition.present) {
      map['reference_position'] = Variable<String>(
        $PlotsTable.$converterreferencePositionn.toSql(referencePosition.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlotsCompanion(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('identification: $identification, ')
          ..write('status: $status, ')
          ..write('areaHa: $areaHa, ')
          ..write('referencePosition: $referencePosition, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlotGeoPointsTable extends PlotGeoPoints
    with TableInfo<$PlotGeoPointsTable, PlotGeoPointRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlotGeoPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plotIdMeta = const VerificationMeta('plotId');
  @override
  late final GeneratedColumn<String> plotId = GeneratedColumn<String>(
    'plot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pointOrderMeta = const VerificationMeta(
    'pointOrder',
  );
  @override
  late final GeneratedColumn<int> pointOrder = GeneratedColumn<int>(
    'point_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  referencePosition =
      GeneratedColumn<String>(
        'reference_position',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PlotReferencePosition?>(
        $PlotGeoPointsTable.$converterreferencePositionn,
      );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plotId,
    pointOrder,
    referencePosition,
    latitude,
    longitude,
    accuracyMeters,
    capturedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plot_geo_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlotGeoPointRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plot_id')) {
      context.handle(
        _plotIdMeta,
        plotId.isAcceptableOrUnknown(data['plot_id']!, _plotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plotIdMeta);
    }
    if (data.containsKey('point_order')) {
      context.handle(
        _pointOrderMeta,
        pointOrder.isAcceptableOrUnknown(data['point_order']!, _pointOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_pointOrderMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlotGeoPointRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlotGeoPointRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      plotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plot_id'],
      )!,
      pointOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_order'],
      )!,
      referencePosition: $PlotGeoPointsTable.$converterreferencePositionn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}reference_position'],
            ),
          ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
    );
  }

  @override
  $PlotGeoPointsTable createAlias(String alias) {
    return $PlotGeoPointsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlotReferencePosition, String, String>
  $converterreferencePosition = const EnumNameConverter<PlotReferencePosition>(
    PlotReferencePosition.values,
  );
  static JsonTypeConverter2<PlotReferencePosition?, String?, String?>
  $converterreferencePositionn = JsonTypeConverter2.asNullable(
    $converterreferencePosition,
  );
}

class PlotGeoPointRecord extends DataClass
    implements Insertable<PlotGeoPointRecord> {
  final String id;
  final String plotId;
  final int pointOrder;
  final PlotReferencePosition? referencePosition;
  final double latitude;
  final double longitude;
  final double? accuracyMeters;
  final DateTime capturedAt;
  const PlotGeoPointRecord({
    required this.id,
    required this.plotId,
    required this.pointOrder,
    this.referencePosition,
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
    required this.capturedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plot_id'] = Variable<String>(plotId);
    map['point_order'] = Variable<int>(pointOrder);
    if (!nullToAbsent || referencePosition != null) {
      map['reference_position'] = Variable<String>(
        $PlotGeoPointsTable.$converterreferencePositionn.toSql(
          referencePosition,
        ),
      );
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    return map;
  }

  PlotGeoPointsCompanion toCompanion(bool nullToAbsent) {
    return PlotGeoPointsCompanion(
      id: Value(id),
      plotId: Value(plotId),
      pointOrder: Value(pointOrder),
      referencePosition: referencePosition == null && nullToAbsent
          ? const Value.absent()
          : Value(referencePosition),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracyMeters: accuracyMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMeters),
      capturedAt: Value(capturedAt),
    );
  }

  factory PlotGeoPointRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlotGeoPointRecord(
      id: serializer.fromJson<String>(json['id']),
      plotId: serializer.fromJson<String>(json['plotId']),
      pointOrder: serializer.fromJson<int>(json['pointOrder']),
      referencePosition: $PlotGeoPointsTable.$converterreferencePositionn
          .fromJson(serializer.fromJson<String?>(json['referencePosition'])),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracyMeters: serializer.fromJson<double?>(json['accuracyMeters']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'plotId': serializer.toJson<String>(plotId),
      'pointOrder': serializer.toJson<int>(pointOrder),
      'referencePosition': serializer.toJson<String?>(
        $PlotGeoPointsTable.$converterreferencePositionn.toJson(
          referencePosition,
        ),
      ),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracyMeters': serializer.toJson<double?>(accuracyMeters),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
    };
  }

  PlotGeoPointRecord copyWith({
    String? id,
    String? plotId,
    int? pointOrder,
    Value<PlotReferencePosition?> referencePosition = const Value.absent(),
    double? latitude,
    double? longitude,
    Value<double?> accuracyMeters = const Value.absent(),
    DateTime? capturedAt,
  }) => PlotGeoPointRecord(
    id: id ?? this.id,
    plotId: plotId ?? this.plotId,
    pointOrder: pointOrder ?? this.pointOrder,
    referencePosition: referencePosition.present
        ? referencePosition.value
        : this.referencePosition,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracyMeters: accuracyMeters.present
        ? accuracyMeters.value
        : this.accuracyMeters,
    capturedAt: capturedAt ?? this.capturedAt,
  );
  PlotGeoPointRecord copyWithCompanion(PlotGeoPointsCompanion data) {
    return PlotGeoPointRecord(
      id: data.id.present ? data.id.value : this.id,
      plotId: data.plotId.present ? data.plotId.value : this.plotId,
      pointOrder: data.pointOrder.present
          ? data.pointOrder.value
          : this.pointOrder,
      referencePosition: data.referencePosition.present
          ? data.referencePosition.value
          : this.referencePosition,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlotGeoPointRecord(')
          ..write('id: $id, ')
          ..write('plotId: $plotId, ')
          ..write('pointOrder: $pointOrder, ')
          ..write('referencePosition: $referencePosition, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('capturedAt: $capturedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plotId,
    pointOrder,
    referencePosition,
    latitude,
    longitude,
    accuracyMeters,
    capturedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlotGeoPointRecord &&
          other.id == this.id &&
          other.plotId == this.plotId &&
          other.pointOrder == this.pointOrder &&
          other.referencePosition == this.referencePosition &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.capturedAt == this.capturedAt);
}

class PlotGeoPointsCompanion extends UpdateCompanion<PlotGeoPointRecord> {
  final Value<String> id;
  final Value<String> plotId;
  final Value<int> pointOrder;
  final Value<PlotReferencePosition?> referencePosition;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> accuracyMeters;
  final Value<DateTime> capturedAt;
  final Value<int> rowid;
  const PlotGeoPointsCompanion({
    this.id = const Value.absent(),
    this.plotId = const Value.absent(),
    this.pointOrder = const Value.absent(),
    this.referencePosition = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlotGeoPointsCompanion.insert({
    required String id,
    required String plotId,
    required int pointOrder,
    this.referencePosition = const Value.absent(),
    required double latitude,
    required double longitude,
    this.accuracyMeters = const Value.absent(),
    required DateTime capturedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plotId = Value(plotId),
       pointOrder = Value(pointOrder),
       latitude = Value(latitude),
       longitude = Value(longitude),
       capturedAt = Value(capturedAt);
  static Insertable<PlotGeoPointRecord> custom({
    Expression<String>? id,
    Expression<String>? plotId,
    Expression<int>? pointOrder,
    Expression<String>? referencePosition,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? capturedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plotId != null) 'plot_id': plotId,
      if (pointOrder != null) 'point_order': pointOrder,
      if (referencePosition != null) 'reference_position': referencePosition,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlotGeoPointsCompanion copyWith({
    Value<String>? id,
    Value<String>? plotId,
    Value<int>? pointOrder,
    Value<PlotReferencePosition?>? referencePosition,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? accuracyMeters,
    Value<DateTime>? capturedAt,
    Value<int>? rowid,
  }) {
    return PlotGeoPointsCompanion(
      id: id ?? this.id,
      plotId: plotId ?? this.plotId,
      pointOrder: pointOrder ?? this.pointOrder,
      referencePosition: referencePosition ?? this.referencePosition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      capturedAt: capturedAt ?? this.capturedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (plotId.present) {
      map['plot_id'] = Variable<String>(plotId.value);
    }
    if (pointOrder.present) {
      map['point_order'] = Variable<int>(pointOrder.value);
    }
    if (referencePosition.present) {
      map['reference_position'] = Variable<String>(
        $PlotGeoPointsTable.$converterreferencePositionn.toSql(
          referencePosition.value,
        ),
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlotGeoPointsCompanion(')
          ..write('id: $id, ')
          ..write('plotId: $plotId, ')
          ..write('pointOrder: $pointOrder, ')
          ..write('referencePosition: $referencePosition, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreesTable extends Trees with TableInfo<$TreesTable, TreeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plotIdMeta = const VerificationMeta('plotId');
  @override
  late final GeneratedColumn<String> plotId = GeneratedColumn<String>(
    'plot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dapCmMeta = const VerificationMeta('dapCm');
  @override
  late final GeneratedColumn<double> dapCm = GeneratedColumn<double>(
    'dap_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMMeta = const VerificationMeta(
    'heightM',
  );
  @override
  late final GeneratedColumn<double> heightM = GeneratedColumn<double>(
    'height_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasTortuousStemMeta = const VerificationMeta(
    'hasTortuousStem',
  );
  @override
  late final GeneratedColumn<bool> hasTortuousStem = GeneratedColumn<bool>(
    'has_tortuous_stem',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_tortuous_stem" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationCapturedAtMeta =
      const VerificationMeta('locationCapturedAt');
  @override
  late final GeneratedColumn<DateTime> locationCapturedAt =
      GeneratedColumn<DateTime>(
        'location_captured_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  plotReferencePosition =
      GeneratedColumn<String>(
        'plot_reference_position',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PlotReferencePosition?>(
        $TreesTable.$converterplotReferencePositionn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plotId,
    number,
    dapCm,
    heightM,
    hasTortuousStem,
    latitude,
    longitude,
    accuracyMeters,
    locationCapturedAt,
    plotReferencePosition,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trees';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plot_id')) {
      context.handle(
        _plotIdMeta,
        plotId.isAcceptableOrUnknown(data['plot_id']!, _plotIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plotIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('dap_cm')) {
      context.handle(
        _dapCmMeta,
        dapCm.isAcceptableOrUnknown(data['dap_cm']!, _dapCmMeta),
      );
    } else if (isInserting) {
      context.missing(_dapCmMeta);
    }
    if (data.containsKey('height_m')) {
      context.handle(
        _heightMMeta,
        heightM.isAcceptableOrUnknown(data['height_m']!, _heightMMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMMeta);
    }
    if (data.containsKey('has_tortuous_stem')) {
      context.handle(
        _hasTortuousStemMeta,
        hasTortuousStem.isAcceptableOrUnknown(
          data['has_tortuous_stem']!,
          _hasTortuousStemMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    }
    if (data.containsKey('location_captured_at')) {
      context.handle(
        _locationCapturedAtMeta,
        locationCapturedAt.isAcceptableOrUnknown(
          data['location_captured_at']!,
          _locationCapturedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      plotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plot_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      dapCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dap_cm'],
      )!,
      heightM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_m'],
      )!,
      hasTortuousStem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_tortuous_stem'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      ),
      locationCapturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}location_captured_at'],
      ),
      plotReferencePosition: $TreesTable.$converterplotReferencePositionn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}plot_reference_position'],
            ),
          ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TreesTable createAlias(String alias) {
    return $TreesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlotReferencePosition, String, String>
  $converterplotReferencePosition =
      const EnumNameConverter<PlotReferencePosition>(
        PlotReferencePosition.values,
      );
  static JsonTypeConverter2<PlotReferencePosition?, String?, String?>
  $converterplotReferencePositionn = JsonTypeConverter2.asNullable(
    $converterplotReferencePosition,
  );
}

class TreeRecord extends DataClass implements Insertable<TreeRecord> {
  final String id;
  final String plotId;
  final int number;
  final double dapCm;
  final double heightM;
  final bool hasTortuousStem;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final DateTime? locationCapturedAt;
  final PlotReferencePosition? plotReferencePosition;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TreeRecord({
    required this.id,
    required this.plotId,
    required this.number,
    required this.dapCm,
    required this.heightM,
    required this.hasTortuousStem,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.locationCapturedAt,
    this.plotReferencePosition,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plot_id'] = Variable<String>(plotId);
    map['number'] = Variable<int>(number);
    map['dap_cm'] = Variable<double>(dapCm);
    map['height_m'] = Variable<double>(heightM);
    map['has_tortuous_stem'] = Variable<bool>(hasTortuousStem);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || accuracyMeters != null) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters);
    }
    if (!nullToAbsent || locationCapturedAt != null) {
      map['location_captured_at'] = Variable<DateTime>(locationCapturedAt);
    }
    if (!nullToAbsent || plotReferencePosition != null) {
      map['plot_reference_position'] = Variable<String>(
        $TreesTable.$converterplotReferencePositionn.toSql(
          plotReferencePosition,
        ),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TreesCompanion toCompanion(bool nullToAbsent) {
    return TreesCompanion(
      id: Value(id),
      plotId: Value(plotId),
      number: Value(number),
      dapCm: Value(dapCm),
      heightM: Value(heightM),
      hasTortuousStem: Value(hasTortuousStem),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      accuracyMeters: accuracyMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyMeters),
      locationCapturedAt: locationCapturedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(locationCapturedAt),
      plotReferencePosition: plotReferencePosition == null && nullToAbsent
          ? const Value.absent()
          : Value(plotReferencePosition),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TreeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreeRecord(
      id: serializer.fromJson<String>(json['id']),
      plotId: serializer.fromJson<String>(json['plotId']),
      number: serializer.fromJson<int>(json['number']),
      dapCm: serializer.fromJson<double>(json['dapCm']),
      heightM: serializer.fromJson<double>(json['heightM']),
      hasTortuousStem: serializer.fromJson<bool>(json['hasTortuousStem']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      accuracyMeters: serializer.fromJson<double?>(json['accuracyMeters']),
      locationCapturedAt: serializer.fromJson<DateTime?>(
        json['locationCapturedAt'],
      ),
      plotReferencePosition: $TreesTable.$converterplotReferencePositionn
          .fromJson(
            serializer.fromJson<String?>(json['plotReferencePosition']),
          ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'plotId': serializer.toJson<String>(plotId),
      'number': serializer.toJson<int>(number),
      'dapCm': serializer.toJson<double>(dapCm),
      'heightM': serializer.toJson<double>(heightM),
      'hasTortuousStem': serializer.toJson<bool>(hasTortuousStem),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'accuracyMeters': serializer.toJson<double?>(accuracyMeters),
      'locationCapturedAt': serializer.toJson<DateTime?>(locationCapturedAt),
      'plotReferencePosition': serializer.toJson<String?>(
        $TreesTable.$converterplotReferencePositionn.toJson(
          plotReferencePosition,
        ),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TreeRecord copyWith({
    String? id,
    String? plotId,
    int? number,
    double? dapCm,
    double? heightM,
    bool? hasTortuousStem,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> accuracyMeters = const Value.absent(),
    Value<DateTime?> locationCapturedAt = const Value.absent(),
    Value<PlotReferencePosition?> plotReferencePosition = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TreeRecord(
    id: id ?? this.id,
    plotId: plotId ?? this.plotId,
    number: number ?? this.number,
    dapCm: dapCm ?? this.dapCm,
    heightM: heightM ?? this.heightM,
    hasTortuousStem: hasTortuousStem ?? this.hasTortuousStem,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    accuracyMeters: accuracyMeters.present
        ? accuracyMeters.value
        : this.accuracyMeters,
    locationCapturedAt: locationCapturedAt.present
        ? locationCapturedAt.value
        : this.locationCapturedAt,
    plotReferencePosition: plotReferencePosition.present
        ? plotReferencePosition.value
        : this.plotReferencePosition,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TreeRecord copyWithCompanion(TreesCompanion data) {
    return TreeRecord(
      id: data.id.present ? data.id.value : this.id,
      plotId: data.plotId.present ? data.plotId.value : this.plotId,
      number: data.number.present ? data.number.value : this.number,
      dapCm: data.dapCm.present ? data.dapCm.value : this.dapCm,
      heightM: data.heightM.present ? data.heightM.value : this.heightM,
      hasTortuousStem: data.hasTortuousStem.present
          ? data.hasTortuousStem.value
          : this.hasTortuousStem,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      locationCapturedAt: data.locationCapturedAt.present
          ? data.locationCapturedAt.value
          : this.locationCapturedAt,
      plotReferencePosition: data.plotReferencePosition.present
          ? data.plotReferencePosition.value
          : this.plotReferencePosition,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreeRecord(')
          ..write('id: $id, ')
          ..write('plotId: $plotId, ')
          ..write('number: $number, ')
          ..write('dapCm: $dapCm, ')
          ..write('heightM: $heightM, ')
          ..write('hasTortuousStem: $hasTortuousStem, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('locationCapturedAt: $locationCapturedAt, ')
          ..write('plotReferencePosition: $plotReferencePosition, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plotId,
    number,
    dapCm,
    heightM,
    hasTortuousStem,
    latitude,
    longitude,
    accuracyMeters,
    locationCapturedAt,
    plotReferencePosition,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreeRecord &&
          other.id == this.id &&
          other.plotId == this.plotId &&
          other.number == this.number &&
          other.dapCm == this.dapCm &&
          other.heightM == this.heightM &&
          other.hasTortuousStem == this.hasTortuousStem &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.locationCapturedAt == this.locationCapturedAt &&
          other.plotReferencePosition == this.plotReferencePosition &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TreesCompanion extends UpdateCompanion<TreeRecord> {
  final Value<String> id;
  final Value<String> plotId;
  final Value<int> number;
  final Value<double> dapCm;
  final Value<double> heightM;
  final Value<bool> hasTortuousStem;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> accuracyMeters;
  final Value<DateTime?> locationCapturedAt;
  final Value<PlotReferencePosition?> plotReferencePosition;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TreesCompanion({
    this.id = const Value.absent(),
    this.plotId = const Value.absent(),
    this.number = const Value.absent(),
    this.dapCm = const Value.absent(),
    this.heightM = const Value.absent(),
    this.hasTortuousStem = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.locationCapturedAt = const Value.absent(),
    this.plotReferencePosition = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreesCompanion.insert({
    required String id,
    required String plotId,
    required int number,
    required double dapCm,
    required double heightM,
    this.hasTortuousStem = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.locationCapturedAt = const Value.absent(),
    this.plotReferencePosition = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plotId = Value(plotId),
       number = Value(number),
       dapCm = Value(dapCm),
       heightM = Value(heightM),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TreeRecord> custom({
    Expression<String>? id,
    Expression<String>? plotId,
    Expression<int>? number,
    Expression<double>? dapCm,
    Expression<double>? heightM,
    Expression<bool>? hasTortuousStem,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? locationCapturedAt,
    Expression<String>? plotReferencePosition,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plotId != null) 'plot_id': plotId,
      if (number != null) 'number': number,
      if (dapCm != null) 'dap_cm': dapCm,
      if (heightM != null) 'height_m': heightM,
      if (hasTortuousStem != null) 'has_tortuous_stem': hasTortuousStem,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (locationCapturedAt != null)
        'location_captured_at': locationCapturedAt,
      if (plotReferencePosition != null)
        'plot_reference_position': plotReferencePosition,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreesCompanion copyWith({
    Value<String>? id,
    Value<String>? plotId,
    Value<int>? number,
    Value<double>? dapCm,
    Value<double>? heightM,
    Value<bool>? hasTortuousStem,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? accuracyMeters,
    Value<DateTime?>? locationCapturedAt,
    Value<PlotReferencePosition?>? plotReferencePosition,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TreesCompanion(
      id: id ?? this.id,
      plotId: plotId ?? this.plotId,
      number: number ?? this.number,
      dapCm: dapCm ?? this.dapCm,
      heightM: heightM ?? this.heightM,
      hasTortuousStem: hasTortuousStem ?? this.hasTortuousStem,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      locationCapturedAt: locationCapturedAt ?? this.locationCapturedAt,
      plotReferencePosition:
          plotReferencePosition ?? this.plotReferencePosition,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (plotId.present) {
      map['plot_id'] = Variable<String>(plotId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (dapCm.present) {
      map['dap_cm'] = Variable<double>(dapCm.value);
    }
    if (heightM.present) {
      map['height_m'] = Variable<double>(heightM.value);
    }
    if (hasTortuousStem.present) {
      map['has_tortuous_stem'] = Variable<bool>(hasTortuousStem.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (locationCapturedAt.present) {
      map['location_captured_at'] = Variable<DateTime>(
        locationCapturedAt.value,
      );
    }
    if (plotReferencePosition.present) {
      map['plot_reference_position'] = Variable<String>(
        $TreesTable.$converterplotReferencePositionn.toSql(
          plotReferencePosition.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreesCompanion(')
          ..write('id: $id, ')
          ..write('plotId: $plotId, ')
          ..write('number: $number, ')
          ..write('dapCm: $dapCm, ')
          ..write('heightM: $heightM, ')
          ..write('hasTortuousStem: $hasTortuousStem, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('locationCapturedAt: $locationCapturedAt, ')
          ..write('plotReferencePosition: $plotReferencePosition, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DendroDatabase extends GeneratedDatabase {
  _$DendroDatabase(QueryExecutor e) : super(e);
  $DendroDatabaseManager get managers => $DendroDatabaseManager(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $SpeciesTable species = $SpeciesTable(this);
  late final $FormulasTable formulas = $FormulasTable(this);
  late final $FormulaVariablesTable formulaVariables = $FormulaVariablesTable(
    this,
  );
  late final $FormulaCoefficientsTable formulaCoefficients =
      $FormulaCoefficientsTable(this);
  late final $SpeciesFormulasTable speciesFormulas = $SpeciesFormulasTable(
    this,
  );
  late final $StandsTable stands = $StandsTable(this);
  late final $InventoryRunsTable inventoryRuns = $InventoryRunsTable(this);
  late final $TalhaoLevantamentosTable talhaoLevantamentos =
      $TalhaoLevantamentosTable(this);
  late final $PlotsTable plots = $PlotsTable(this);
  late final $PlotGeoPointsTable plotGeoPoints = $PlotGeoPointsTable(this);
  late final $TreesTable trees = $TreesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    properties,
    species,
    formulas,
    formulaVariables,
    formulaCoefficients,
    speciesFormulas,
    stands,
    inventoryRuns,
    talhaoLevantamentos,
    plots,
    plotGeoPoints,
    trees,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'formulas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('formula_variables', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'formulas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('formula_coefficients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'species',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('species_formulas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'formulas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('species_formulas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'properties',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stands', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'properties',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inventory_runs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inventory_runs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('talhao_levantamentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stands',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('talhao_levantamentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'talhao_levantamentos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plots', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plot_geo_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trees', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PropertiesTableCreateCompanionBuilder =
    PropertiesCompanion Function({
      required String id,
      required String name,
      required String municipality,
      Value<String> state,
      required double totalAreaHa,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PropertiesTableUpdateCompanionBuilder =
    PropertiesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> municipality,
      Value<String> state,
      Value<double> totalAreaHa,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PropertiesTableReferences
    extends BaseReferences<_$DendroDatabase, $PropertiesTable, PropertyRecord> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StandsTable, List<StandRecord>> _standsRefsTable(
    _$DendroDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stands,
    aliasName: 'properties__id__stands__property_id',
  );

  $$StandsTableProcessedTableManager get standsRefs {
    final manager = $$StandsTableTableManager(
      $_db,
      $_db.stands,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_standsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InventoryRunsTable, List<InventoryRunRecord>>
  _inventoryRunsRefsTable(_$DendroDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryRuns,
    aliasName: 'properties__id__inventory_runs__property_id',
  );

  $$InventoryRunsTableProcessedTableManager get inventoryRunsRefs {
    final manager = $$InventoryRunsTableTableManager(
      $_db,
      $_db.inventoryRuns,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$DendroDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAreaHa => $composableBuilder(
    column: $table.totalAreaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> standsRefs(
    Expression<bool> Function($$StandsTableFilterComposer f) f,
  ) {
    final $$StandsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableFilterComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryRunsRefs(
    Expression<bool> Function($$InventoryRunsTableFilterComposer f) f,
  ) {
    final $$InventoryRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryRuns,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryRunsTableFilterComposer(
            $db: $db,
            $table: $db.inventoryRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$DendroDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAreaHa => $composableBuilder(
    column: $table.totalAreaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$DendroDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<double> get totalAreaHa => $composableBuilder(
    column: $table.totalAreaHa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> standsRefs<T extends Object>(
    Expression<T> Function($$StandsTableAnnotationComposer a) f,
  ) {
    final $$StandsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableAnnotationComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryRunsRefs<T extends Object>(
    Expression<T> Function($$InventoryRunsTableAnnotationComposer a) f,
  ) {
    final $$InventoryRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryRuns,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $PropertiesTable,
          PropertyRecord,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (PropertyRecord, $$PropertiesTableReferences),
          PropertyRecord,
          PrefetchHooks Function({bool standsRefs, bool inventoryRunsRefs})
        > {
  $$PropertiesTableTableManager(_$DendroDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> municipality = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<double> totalAreaHa = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                name: name,
                municipality: municipality,
                state: state,
                totalAreaHa: totalAreaHa,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String municipality,
                Value<String> state = const Value.absent(),
                required double totalAreaHa,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                name: name,
                municipality: municipality,
                state: state,
                totalAreaHa: totalAreaHa,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({standsRefs = false, inventoryRunsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (standsRefs) db.stands,
                    if (inventoryRunsRefs) db.inventoryRuns,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (standsRefs)
                        await $_getPrefetchedData<
                          PropertyRecord,
                          $PropertiesTable,
                          StandRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PropertiesTableReferences
                              ._standsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PropertiesTableReferences(
                                db,
                                table,
                                p0,
                              ).standsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.propertyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventoryRunsRefs)
                        await $_getPrefetchedData<
                          PropertyRecord,
                          $PropertiesTable,
                          InventoryRunRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PropertiesTableReferences
                              ._inventoryRunsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PropertiesTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryRunsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.propertyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $PropertiesTable,
      PropertyRecord,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (PropertyRecord, $$PropertiesTableReferences),
      PropertyRecord,
      PrefetchHooks Function({bool standsRefs, bool inventoryRunsRefs})
    >;
typedef $$SpeciesTableCreateCompanionBuilder =
    SpeciesCompanion Function({
      required String id,
      required String name,
      Value<String?> scientificName,
      Value<String?> description,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SpeciesTableUpdateCompanionBuilder =
    SpeciesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> scientificName,
      Value<String?> description,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SpeciesTableReferences
    extends BaseReferences<_$DendroDatabase, $SpeciesTable, SpeciesRecord> {
  $$SpeciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SpeciesFormulasTable, List<SpeciesFormulaRecord>>
  _speciesFormulasRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.speciesFormulas,
        aliasName: 'species__id__species_formulas__species_id',
      );

  $$SpeciesFormulasTableProcessedTableManager get speciesFormulasRefs {
    final manager = $$SpeciesFormulasTableTableManager(
      $_db,
      $_db.speciesFormulas,
    ).filter((f) => f.speciesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _speciesFormulasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StandsTable, List<StandRecord>> _standsRefsTable(
    _$DendroDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stands,
    aliasName: 'species__id__stands__species_id',
  );

  $$StandsTableProcessedTableManager get standsRefs {
    final manager = $$StandsTableTableManager(
      $_db,
      $_db.stands,
    ).filter((f) => f.speciesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_standsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamentoRecord>
  >
  _talhaoLevantamentosRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'species__id__talhao_levantamentos__species_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.speciesId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SpeciesTableFilterComposer
    extends Composer<_$DendroDatabase, $SpeciesTable> {
  $$SpeciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> speciesFormulasRefs(
    Expression<bool> Function($$SpeciesFormulasTableFilterComposer f) f,
  ) {
    final $$SpeciesFormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesFormulas,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesFormulasTableFilterComposer(
            $db: $db,
            $table: $db.speciesFormulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> standsRefs(
    Expression<bool> Function($$StandsTableFilterComposer f) f,
  ) {
    final $$StandsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableFilterComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> talhaoLevantamentosRefs(
    Expression<bool> Function($$TalhaoLevantamentosTableFilterComposer f) f,
  ) {
    final $$TalhaoLevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhaoLevantamentos,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhaoLevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.talhaoLevantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SpeciesTableOrderingComposer
    extends Composer<_$DendroDatabase, $SpeciesTable> {
  $$SpeciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeciesTableAnnotationComposer
    extends Composer<_$DendroDatabase, $SpeciesTable> {
  $$SpeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> speciesFormulasRefs<T extends Object>(
    Expression<T> Function($$SpeciesFormulasTableAnnotationComposer a) f,
  ) {
    final $$SpeciesFormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesFormulas,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesFormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.speciesFormulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> standsRefs<T extends Object>(
    Expression<T> Function($$StandsTableAnnotationComposer a) f,
  ) {
    final $$StandsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.speciesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableAnnotationComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> talhaoLevantamentosRefs<T extends Object>(
    Expression<T> Function($$TalhaoLevantamentosTableAnnotationComposer a) f,
  ) {
    final $$TalhaoLevantamentosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.speciesId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableAnnotationComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SpeciesTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $SpeciesTable,
          SpeciesRecord,
          $$SpeciesTableFilterComposer,
          $$SpeciesTableOrderingComposer,
          $$SpeciesTableAnnotationComposer,
          $$SpeciesTableCreateCompanionBuilder,
          $$SpeciesTableUpdateCompanionBuilder,
          (SpeciesRecord, $$SpeciesTableReferences),
          SpeciesRecord,
          PrefetchHooks Function({
            bool speciesFormulasRefs,
            bool standsRefs,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$SpeciesTableTableManager(_$DendroDatabase db, $SpeciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> scientificName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeciesCompanion(
                id: id,
                name: name,
                scientificName: scientificName,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> scientificName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SpeciesCompanion.insert(
                id: id,
                name: name,
                scientificName: scientificName,
                description: description,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpeciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                speciesFormulasRefs = false,
                standsRefs = false,
                talhaoLevantamentosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (speciesFormulasRefs) db.speciesFormulas,
                    if (standsRefs) db.stands,
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (speciesFormulasRefs)
                        await $_getPrefetchedData<
                          SpeciesRecord,
                          $SpeciesTable,
                          SpeciesFormulaRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SpeciesTableReferences
                              ._speciesFormulasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).speciesFormulasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.speciesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (standsRefs)
                        await $_getPrefetchedData<
                          SpeciesRecord,
                          $SpeciesTable,
                          StandRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SpeciesTableReferences
                              ._standsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).standsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.speciesId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          SpeciesRecord,
                          $SpeciesTable,
                          TalhaoLevantamentoRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SpeciesTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SpeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.speciesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SpeciesTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $SpeciesTable,
      SpeciesRecord,
      $$SpeciesTableFilterComposer,
      $$SpeciesTableOrderingComposer,
      $$SpeciesTableAnnotationComposer,
      $$SpeciesTableCreateCompanionBuilder,
      $$SpeciesTableUpdateCompanionBuilder,
      (SpeciesRecord, $$SpeciesTableReferences),
      SpeciesRecord,
      PrefetchHooks Function({
        bool speciesFormulasRefs,
        bool standsRefs,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$FormulasTableCreateCompanionBuilder =
    FormulasCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required String expression,
      Value<bool> active,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FormulasTableUpdateCompanionBuilder =
    FormulasCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> expression,
      Value<bool> active,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FormulasTableReferences
    extends BaseReferences<_$DendroDatabase, $FormulasTable, FormulaRecord> {
  $$FormulasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $FormulaVariablesTable,
    List<FormulaVariableRecord>
  >
  _formulaVariablesRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.formulaVariables,
        aliasName: 'formulas__id__formula_variables__formula_id',
      );

  $$FormulaVariablesTableProcessedTableManager get formulaVariablesRefs {
    final manager = $$FormulaVariablesTableTableManager(
      $_db,
      $_db.formulaVariables,
    ).filter((f) => f.formulaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _formulaVariablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FormulaCoefficientsTable,
    List<FormulaCoefficientRecord>
  >
  _formulaCoefficientsRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.formulaCoefficients,
        aliasName: 'formulas__id__formula_coefficients__formula_id',
      );

  $$FormulaCoefficientsTableProcessedTableManager get formulaCoefficientsRefs {
    final manager = $$FormulaCoefficientsTableTableManager(
      $_db,
      $_db.formulaCoefficients,
    ).filter((f) => f.formulaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _formulaCoefficientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SpeciesFormulasTable, List<SpeciesFormulaRecord>>
  _speciesFormulasRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.speciesFormulas,
        aliasName: 'formulas__id__species_formulas__formula_id',
      );

  $$SpeciesFormulasTableProcessedTableManager get speciesFormulasRefs {
    final manager = $$SpeciesFormulasTableTableManager(
      $_db,
      $_db.speciesFormulas,
    ).filter((f) => f.formulaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _speciesFormulasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamentoRecord>
  >
  _talhaoLevantamentosRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'formulas__id__talhao_levantamentos__formula_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.formulaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FormulasTableFilterComposer
    extends Composer<_$DendroDatabase, $FormulasTable> {
  $$FormulasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expression => $composableBuilder(
    column: $table.expression,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> formulaVariablesRefs(
    Expression<bool> Function($$FormulaVariablesTableFilterComposer f) f,
  ) {
    final $$FormulaVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formulaVariables,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulaVariablesTableFilterComposer(
            $db: $db,
            $table: $db.formulaVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> formulaCoefficientsRefs(
    Expression<bool> Function($$FormulaCoefficientsTableFilterComposer f) f,
  ) {
    final $$FormulaCoefficientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formulaCoefficients,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulaCoefficientsTableFilterComposer(
            $db: $db,
            $table: $db.formulaCoefficients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> speciesFormulasRefs(
    Expression<bool> Function($$SpeciesFormulasTableFilterComposer f) f,
  ) {
    final $$SpeciesFormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesFormulas,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesFormulasTableFilterComposer(
            $db: $db,
            $table: $db.speciesFormulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> talhaoLevantamentosRefs(
    Expression<bool> Function($$TalhaoLevantamentosTableFilterComposer f) f,
  ) {
    final $$TalhaoLevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhaoLevantamentos,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhaoLevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.talhaoLevantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FormulasTableOrderingComposer
    extends Composer<_$DendroDatabase, $FormulasTable> {
  $$FormulasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expression => $composableBuilder(
    column: $table.expression,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FormulasTableAnnotationComposer
    extends Composer<_$DendroDatabase, $FormulasTable> {
  $$FormulasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expression => $composableBuilder(
    column: $table.expression,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> formulaVariablesRefs<T extends Object>(
    Expression<T> Function($$FormulaVariablesTableAnnotationComposer a) f,
  ) {
    final $$FormulaVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.formulaVariables,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulaVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.formulaVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> formulaCoefficientsRefs<T extends Object>(
    Expression<T> Function($$FormulaCoefficientsTableAnnotationComposer a) f,
  ) {
    final $$FormulaCoefficientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.formulaCoefficients,
          getReferencedColumn: (t) => t.formulaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FormulaCoefficientsTableAnnotationComposer(
                $db: $db,
                $table: $db.formulaCoefficients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> speciesFormulasRefs<T extends Object>(
    Expression<T> Function($$SpeciesFormulasTableAnnotationComposer a) f,
  ) {
    final $$SpeciesFormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.speciesFormulas,
      getReferencedColumn: (t) => t.formulaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesFormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.speciesFormulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> talhaoLevantamentosRefs<T extends Object>(
    Expression<T> Function($$TalhaoLevantamentosTableAnnotationComposer a) f,
  ) {
    final $$TalhaoLevantamentosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.formulaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableAnnotationComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FormulasTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $FormulasTable,
          FormulaRecord,
          $$FormulasTableFilterComposer,
          $$FormulasTableOrderingComposer,
          $$FormulasTableAnnotationComposer,
          $$FormulasTableCreateCompanionBuilder,
          $$FormulasTableUpdateCompanionBuilder,
          (FormulaRecord, $$FormulasTableReferences),
          FormulaRecord,
          PrefetchHooks Function({
            bool formulaVariablesRefs,
            bool formulaCoefficientsRefs,
            bool speciesFormulasRefs,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$FormulasTableTableManager(_$DendroDatabase db, $FormulasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormulasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormulasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormulasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> expression = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormulasCompanion(
                id: id,
                name: name,
                description: description,
                expression: expression,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required String expression,
                Value<bool> active = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FormulasCompanion.insert(
                id: id,
                name: name,
                description: description,
                expression: expression,
                active: active,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FormulasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                formulaVariablesRefs = false,
                formulaCoefficientsRefs = false,
                speciesFormulasRefs = false,
                talhaoLevantamentosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (formulaVariablesRefs) db.formulaVariables,
                    if (formulaCoefficientsRefs) db.formulaCoefficients,
                    if (speciesFormulasRefs) db.speciesFormulas,
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (formulaVariablesRefs)
                        await $_getPrefetchedData<
                          FormulaRecord,
                          $FormulasTable,
                          FormulaVariableRecord
                        >(
                          currentTable: table,
                          referencedTable: $$FormulasTableReferences
                              ._formulaVariablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FormulasTableReferences(
                                db,
                                table,
                                p0,
                              ).formulaVariablesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.formulaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (formulaCoefficientsRefs)
                        await $_getPrefetchedData<
                          FormulaRecord,
                          $FormulasTable,
                          FormulaCoefficientRecord
                        >(
                          currentTable: table,
                          referencedTable: $$FormulasTableReferences
                              ._formulaCoefficientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FormulasTableReferences(
                                db,
                                table,
                                p0,
                              ).formulaCoefficientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.formulaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (speciesFormulasRefs)
                        await $_getPrefetchedData<
                          FormulaRecord,
                          $FormulasTable,
                          SpeciesFormulaRecord
                        >(
                          currentTable: table,
                          referencedTable: $$FormulasTableReferences
                              ._speciesFormulasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FormulasTableReferences(
                                db,
                                table,
                                p0,
                              ).speciesFormulasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.formulaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          FormulaRecord,
                          $FormulasTable,
                          TalhaoLevantamentoRecord
                        >(
                          currentTable: table,
                          referencedTable: $$FormulasTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FormulasTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.formulaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FormulasTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $FormulasTable,
      FormulaRecord,
      $$FormulasTableFilterComposer,
      $$FormulasTableOrderingComposer,
      $$FormulasTableAnnotationComposer,
      $$FormulasTableCreateCompanionBuilder,
      $$FormulasTableUpdateCompanionBuilder,
      (FormulaRecord, $$FormulasTableReferences),
      FormulaRecord,
      PrefetchHooks Function({
        bool formulaVariablesRefs,
        bool formulaCoefficientsRefs,
        bool speciesFormulasRefs,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$FormulaVariablesTableCreateCompanionBuilder =
    FormulaVariablesCompanion Function({
      required String id,
      required String formulaId,
      required String symbol,
      required String label,
      required String unit,
      required String valueSource,
      required FormulaVariableKey variableKey,
      Value<int> rowid,
    });
typedef $$FormulaVariablesTableUpdateCompanionBuilder =
    FormulaVariablesCompanion Function({
      Value<String> id,
      Value<String> formulaId,
      Value<String> symbol,
      Value<String> label,
      Value<String> unit,
      Value<String> valueSource,
      Value<FormulaVariableKey> variableKey,
      Value<int> rowid,
    });

final class $$FormulaVariablesTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $FormulaVariablesTable,
          FormulaVariableRecord
        > {
  $$FormulaVariablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FormulasTable _formulaIdTable(_$DendroDatabase db) =>
      db.formulas.createAlias('formula_variables__formula_id__formulas__id');

  $$FormulasTableProcessedTableManager get formulaId {
    final $_column = $_itemColumn<String>('formula_id')!;

    final manager = $$FormulasTableTableManager(
      $_db,
      $_db.formulas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_formulaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormulaVariablesTableFilterComposer
    extends Composer<_$DendroDatabase, $FormulaVariablesTable> {
  $$FormulaVariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueSource => $composableBuilder(
    column: $table.valueSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FormulaVariableKey, FormulaVariableKey, String>
  get variableKey => $composableBuilder(
    column: $table.variableKey,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$FormulasTableFilterComposer get formulaId {
    final $$FormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableFilterComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaVariablesTableOrderingComposer
    extends Composer<_$DendroDatabase, $FormulaVariablesTable> {
  $$FormulaVariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueSource => $composableBuilder(
    column: $table.valueSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variableKey => $composableBuilder(
    column: $table.variableKey,
    builder: (column) => ColumnOrderings(column),
  );

  $$FormulasTableOrderingComposer get formulaId {
    final $$FormulasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableOrderingComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaVariablesTableAnnotationComposer
    extends Composer<_$DendroDatabase, $FormulaVariablesTable> {
  $$FormulaVariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get valueSource => $composableBuilder(
    column: $table.valueSource,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FormulaVariableKey, String>
  get variableKey => $composableBuilder(
    column: $table.variableKey,
    builder: (column) => column,
  );

  $$FormulasTableAnnotationComposer get formulaId {
    final $$FormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaVariablesTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $FormulaVariablesTable,
          FormulaVariableRecord,
          $$FormulaVariablesTableFilterComposer,
          $$FormulaVariablesTableOrderingComposer,
          $$FormulaVariablesTableAnnotationComposer,
          $$FormulaVariablesTableCreateCompanionBuilder,
          $$FormulaVariablesTableUpdateCompanionBuilder,
          (FormulaVariableRecord, $$FormulaVariablesTableReferences),
          FormulaVariableRecord,
          PrefetchHooks Function({bool formulaId})
        > {
  $$FormulaVariablesTableTableManager(
    _$DendroDatabase db,
    $FormulaVariablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormulaVariablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormulaVariablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FormulaVariablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> formulaId = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> valueSource = const Value.absent(),
                Value<FormulaVariableKey> variableKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormulaVariablesCompanion(
                id: id,
                formulaId: formulaId,
                symbol: symbol,
                label: label,
                unit: unit,
                valueSource: valueSource,
                variableKey: variableKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String formulaId,
                required String symbol,
                required String label,
                required String unit,
                required String valueSource,
                required FormulaVariableKey variableKey,
                Value<int> rowid = const Value.absent(),
              }) => FormulaVariablesCompanion.insert(
                id: id,
                formulaId: formulaId,
                symbol: symbol,
                label: label,
                unit: unit,
                valueSource: valueSource,
                variableKey: variableKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FormulaVariablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({formulaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (formulaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.formulaId,
                                referencedTable:
                                    $$FormulaVariablesTableReferences
                                        ._formulaIdTable(db),
                                referencedColumn:
                                    $$FormulaVariablesTableReferences
                                        ._formulaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormulaVariablesTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $FormulaVariablesTable,
      FormulaVariableRecord,
      $$FormulaVariablesTableFilterComposer,
      $$FormulaVariablesTableOrderingComposer,
      $$FormulaVariablesTableAnnotationComposer,
      $$FormulaVariablesTableCreateCompanionBuilder,
      $$FormulaVariablesTableUpdateCompanionBuilder,
      (FormulaVariableRecord, $$FormulaVariablesTableReferences),
      FormulaVariableRecord,
      PrefetchHooks Function({bool formulaId})
    >;
typedef $$FormulaCoefficientsTableCreateCompanionBuilder =
    FormulaCoefficientsCompanion Function({
      required String id,
      required String formulaId,
      required String symbol,
      required String label,
      Value<double?> value,
      Value<int> rowid,
    });
typedef $$FormulaCoefficientsTableUpdateCompanionBuilder =
    FormulaCoefficientsCompanion Function({
      Value<String> id,
      Value<String> formulaId,
      Value<String> symbol,
      Value<String> label,
      Value<double?> value,
      Value<int> rowid,
    });

final class $$FormulaCoefficientsTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $FormulaCoefficientsTable,
          FormulaCoefficientRecord
        > {
  $$FormulaCoefficientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FormulasTable _formulaIdTable(_$DendroDatabase db) =>
      db.formulas.createAlias('formula_coefficients__formula_id__formulas__id');

  $$FormulasTableProcessedTableManager get formulaId {
    final $_column = $_itemColumn<String>('formula_id')!;

    final manager = $$FormulasTableTableManager(
      $_db,
      $_db.formulas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_formulaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FormulaCoefficientsTableFilterComposer
    extends Composer<_$DendroDatabase, $FormulaCoefficientsTable> {
  $$FormulaCoefficientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$FormulasTableFilterComposer get formulaId {
    final $$FormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableFilterComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaCoefficientsTableOrderingComposer
    extends Composer<_$DendroDatabase, $FormulaCoefficientsTable> {
  $$FormulaCoefficientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$FormulasTableOrderingComposer get formulaId {
    final $$FormulasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableOrderingComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaCoefficientsTableAnnotationComposer
    extends Composer<_$DendroDatabase, $FormulaCoefficientsTable> {
  $$FormulaCoefficientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$FormulasTableAnnotationComposer get formulaId {
    final $$FormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FormulaCoefficientsTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $FormulaCoefficientsTable,
          FormulaCoefficientRecord,
          $$FormulaCoefficientsTableFilterComposer,
          $$FormulaCoefficientsTableOrderingComposer,
          $$FormulaCoefficientsTableAnnotationComposer,
          $$FormulaCoefficientsTableCreateCompanionBuilder,
          $$FormulaCoefficientsTableUpdateCompanionBuilder,
          (FormulaCoefficientRecord, $$FormulaCoefficientsTableReferences),
          FormulaCoefficientRecord,
          PrefetchHooks Function({bool formulaId})
        > {
  $$FormulaCoefficientsTableTableManager(
    _$DendroDatabase db,
    $FormulaCoefficientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FormulaCoefficientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FormulaCoefficientsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FormulaCoefficientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> formulaId = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormulaCoefficientsCompanion(
                id: id,
                formulaId: formulaId,
                symbol: symbol,
                label: label,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String formulaId,
                required String symbol,
                required String label,
                Value<double?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormulaCoefficientsCompanion.insert(
                id: id,
                formulaId: formulaId,
                symbol: symbol,
                label: label,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FormulaCoefficientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({formulaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (formulaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.formulaId,
                                referencedTable:
                                    $$FormulaCoefficientsTableReferences
                                        ._formulaIdTable(db),
                                referencedColumn:
                                    $$FormulaCoefficientsTableReferences
                                        ._formulaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FormulaCoefficientsTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $FormulaCoefficientsTable,
      FormulaCoefficientRecord,
      $$FormulaCoefficientsTableFilterComposer,
      $$FormulaCoefficientsTableOrderingComposer,
      $$FormulaCoefficientsTableAnnotationComposer,
      $$FormulaCoefficientsTableCreateCompanionBuilder,
      $$FormulaCoefficientsTableUpdateCompanionBuilder,
      (FormulaCoefficientRecord, $$FormulaCoefficientsTableReferences),
      FormulaCoefficientRecord,
      PrefetchHooks Function({bool formulaId})
    >;
typedef $$SpeciesFormulasTableCreateCompanionBuilder =
    SpeciesFormulasCompanion Function({
      required String speciesId,
      required String formulaId,
      Value<bool> isDefault,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SpeciesFormulasTableUpdateCompanionBuilder =
    SpeciesFormulasCompanion Function({
      Value<String> speciesId,
      Value<String> formulaId,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SpeciesFormulasTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $SpeciesFormulasTable,
          SpeciesFormulaRecord
        > {
  $$SpeciesFormulasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SpeciesTable _speciesIdTable(_$DendroDatabase db) =>
      db.species.createAlias('species_formulas__species_id__species__id');

  $$SpeciesTableProcessedTableManager get speciesId {
    final $_column = $_itemColumn<String>('species_id')!;

    final manager = $$SpeciesTableTableManager(
      $_db,
      $_db.species,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FormulasTable _formulaIdTable(_$DendroDatabase db) =>
      db.formulas.createAlias('species_formulas__formula_id__formulas__id');

  $$FormulasTableProcessedTableManager get formulaId {
    final $_column = $_itemColumn<String>('formula_id')!;

    final manager = $$FormulasTableTableManager(
      $_db,
      $_db.formulas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_formulaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SpeciesFormulasTableFilterComposer
    extends Composer<_$DendroDatabase, $SpeciesFormulasTable> {
  $$SpeciesFormulasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SpeciesTableFilterComposer get speciesId {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableFilterComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableFilterComposer get formulaId {
    final $$FormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableFilterComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesFormulasTableOrderingComposer
    extends Composer<_$DendroDatabase, $SpeciesFormulasTable> {
  $$SpeciesFormulasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SpeciesTableOrderingComposer get speciesId {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableOrderingComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableOrderingComposer get formulaId {
    final $$FormulasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableOrderingComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesFormulasTableAnnotationComposer
    extends Composer<_$DendroDatabase, $SpeciesFormulasTable> {
  $$SpeciesFormulasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SpeciesTableAnnotationComposer get speciesId {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableAnnotationComposer get formulaId {
    final $$FormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SpeciesFormulasTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $SpeciesFormulasTable,
          SpeciesFormulaRecord,
          $$SpeciesFormulasTableFilterComposer,
          $$SpeciesFormulasTableOrderingComposer,
          $$SpeciesFormulasTableAnnotationComposer,
          $$SpeciesFormulasTableCreateCompanionBuilder,
          $$SpeciesFormulasTableUpdateCompanionBuilder,
          (SpeciesFormulaRecord, $$SpeciesFormulasTableReferences),
          SpeciesFormulaRecord,
          PrefetchHooks Function({bool speciesId, bool formulaId})
        > {
  $$SpeciesFormulasTableTableManager(
    _$DendroDatabase db,
    $SpeciesFormulasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesFormulasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesFormulasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesFormulasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> speciesId = const Value.absent(),
                Value<String> formulaId = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeciesFormulasCompanion(
                speciesId: speciesId,
                formulaId: formulaId,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String speciesId,
                required String formulaId,
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SpeciesFormulasCompanion.insert(
                speciesId: speciesId,
                formulaId: formulaId,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SpeciesFormulasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({speciesId = false, formulaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (speciesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.speciesId,
                                referencedTable:
                                    $$SpeciesFormulasTableReferences
                                        ._speciesIdTable(db),
                                referencedColumn:
                                    $$SpeciesFormulasTableReferences
                                        ._speciesIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (formulaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.formulaId,
                                referencedTable:
                                    $$SpeciesFormulasTableReferences
                                        ._formulaIdTable(db),
                                referencedColumn:
                                    $$SpeciesFormulasTableReferences
                                        ._formulaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SpeciesFormulasTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $SpeciesFormulasTable,
      SpeciesFormulaRecord,
      $$SpeciesFormulasTableFilterComposer,
      $$SpeciesFormulasTableOrderingComposer,
      $$SpeciesFormulasTableAnnotationComposer,
      $$SpeciesFormulasTableCreateCompanionBuilder,
      $$SpeciesFormulasTableUpdateCompanionBuilder,
      (SpeciesFormulaRecord, $$SpeciesFormulasTableReferences),
      SpeciesFormulaRecord,
      PrefetchHooks Function({bool speciesId, bool formulaId})
    >;
typedef $$StandsTableCreateCompanionBuilder =
    StandsCompanion Function({
      required String id,
      required String propertyId,
      required String identification,
      required String speciesId,
      required double areaHa,
      Value<int?> plantingYear,
      Value<String?> spacing,
      Value<String?> managementRegime,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StandsTableUpdateCompanionBuilder =
    StandsCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<String> identification,
      Value<String> speciesId,
      Value<double> areaHa,
      Value<int?> plantingYear,
      Value<String?> spacing,
      Value<String?> managementRegime,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StandsTableReferences
    extends BaseReferences<_$DendroDatabase, $StandsTable, StandRecord> {
  $$StandsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$DendroDatabase db) =>
      db.properties.createAlias('stands__property_id__properties__id');

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SpeciesTable _speciesIdTable(_$DendroDatabase db) =>
      db.species.createAlias('stands__species_id__species__id');

  $$SpeciesTableProcessedTableManager get speciesId {
    final $_column = $_itemColumn<String>('species_id')!;

    final manager = $$SpeciesTableTableManager(
      $_db,
      $_db.species,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamentoRecord>
  >
  _talhaoLevantamentosRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'stands__id__talhao_levantamentos__stand_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.standId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StandsTableFilterComposer
    extends Composer<_$DendroDatabase, $StandsTable> {
  $$StandsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plantingYear => $composableBuilder(
    column: $table.plantingYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spacing => $composableBuilder(
    column: $table.spacing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get managementRegime => $composableBuilder(
    column: $table.managementRegime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableFilterComposer get speciesId {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableFilterComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> talhaoLevantamentosRefs(
    Expression<bool> Function($$TalhaoLevantamentosTableFilterComposer f) f,
  ) {
    final $$TalhaoLevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhaoLevantamentos,
      getReferencedColumn: (t) => t.standId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhaoLevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.talhaoLevantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StandsTableOrderingComposer
    extends Composer<_$DendroDatabase, $StandsTable> {
  $$StandsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plantingYear => $composableBuilder(
    column: $table.plantingYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spacing => $composableBuilder(
    column: $table.spacing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get managementRegime => $composableBuilder(
    column: $table.managementRegime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableOrderingComposer get speciesId {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableOrderingComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StandsTableAnnotationComposer
    extends Composer<_$DendroDatabase, $StandsTable> {
  $$StandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaHa =>
      $composableBuilder(column: $table.areaHa, builder: (column) => column);

  GeneratedColumn<int> get plantingYear => $composableBuilder(
    column: $table.plantingYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spacing =>
      $composableBuilder(column: $table.spacing, builder: (column) => column);

  GeneratedColumn<String> get managementRegime => $composableBuilder(
    column: $table.managementRegime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableAnnotationComposer get speciesId {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> talhaoLevantamentosRefs<T extends Object>(
    Expression<T> Function($$TalhaoLevantamentosTableAnnotationComposer a) f,
  ) {
    final $$TalhaoLevantamentosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.standId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableAnnotationComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StandsTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $StandsTable,
          StandRecord,
          $$StandsTableFilterComposer,
          $$StandsTableOrderingComposer,
          $$StandsTableAnnotationComposer,
          $$StandsTableCreateCompanionBuilder,
          $$StandsTableUpdateCompanionBuilder,
          (StandRecord, $$StandsTableReferences),
          StandRecord,
          PrefetchHooks Function({
            bool propertyId,
            bool speciesId,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$StandsTableTableManager(_$DendroDatabase db, $StandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<String> identification = const Value.absent(),
                Value<String> speciesId = const Value.absent(),
                Value<double> areaHa = const Value.absent(),
                Value<int?> plantingYear = const Value.absent(),
                Value<String?> spacing = const Value.absent(),
                Value<String?> managementRegime = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StandsCompanion(
                id: id,
                propertyId: propertyId,
                identification: identification,
                speciesId: speciesId,
                areaHa: areaHa,
                plantingYear: plantingYear,
                spacing: spacing,
                managementRegime: managementRegime,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required String identification,
                required String speciesId,
                required double areaHa,
                Value<int?> plantingYear = const Value.absent(),
                Value<String?> spacing = const Value.absent(),
                Value<String?> managementRegime = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StandsCompanion.insert(
                id: id,
                propertyId: propertyId,
                identification: identification,
                speciesId: speciesId,
                areaHa: areaHa,
                plantingYear: plantingYear,
                spacing: spacing,
                managementRegime: managementRegime,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StandsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propertyId = false,
                speciesId = false,
                talhaoLevantamentosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.propertyId,
                                    referencedTable: $$StandsTableReferences
                                        ._propertyIdTable(db),
                                    referencedColumn: $$StandsTableReferences
                                        ._propertyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (speciesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.speciesId,
                                    referencedTable: $$StandsTableReferences
                                        ._speciesIdTable(db),
                                    referencedColumn: $$StandsTableReferences
                                        ._speciesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          StandRecord,
                          $StandsTable,
                          TalhaoLevantamentoRecord
                        >(
                          currentTable: table,
                          referencedTable: $$StandsTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StandsTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.standId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StandsTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $StandsTable,
      StandRecord,
      $$StandsTableFilterComposer,
      $$StandsTableOrderingComposer,
      $$StandsTableAnnotationComposer,
      $$StandsTableCreateCompanionBuilder,
      $$StandsTableUpdateCompanionBuilder,
      (StandRecord, $$StandsTableReferences),
      StandRecord,
      PrefetchHooks Function({
        bool propertyId,
        bool speciesId,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$InventoryRunsTableCreateCompanionBuilder =
    InventoryRunsCompanion Function({
      required String id,
      required String propertyId,
      required InventoryRunStatus status,
      required DateTime startedAt,
      required DateTime updatedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$InventoryRunsTableUpdateCompanionBuilder =
    InventoryRunsCompanion Function({
      Value<String> id,
      Value<String> propertyId,
      Value<InventoryRunStatus> status,
      Value<DateTime> startedAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$InventoryRunsTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $InventoryRunsTable,
          InventoryRunRecord
        > {
  $$InventoryRunsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PropertiesTable _propertyIdTable(_$DendroDatabase db) =>
      db.properties.createAlias('inventory_runs__property_id__properties__id');

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<String>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamentoRecord>
  >
  _talhaoLevantamentosRefsTable(_$DendroDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'inventory_runs__id__talhao_levantamentos__inventory_run_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.inventoryRunId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InventoryRunsTableFilterComposer
    extends Composer<_$DendroDatabase, $InventoryRunsTable> {
  $$InventoryRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InventoryRunStatus, InventoryRunStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> talhaoLevantamentosRefs(
    Expression<bool> Function($$TalhaoLevantamentosTableFilterComposer f) f,
  ) {
    final $$TalhaoLevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhaoLevantamentos,
      getReferencedColumn: (t) => t.inventoryRunId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhaoLevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.talhaoLevantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InventoryRunsTableOrderingComposer
    extends Composer<_$DendroDatabase, $InventoryRunsTable> {
  $$InventoryRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryRunsTableAnnotationComposer
    extends Composer<_$DendroDatabase, $InventoryRunsTable> {
  $$InventoryRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InventoryRunStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> talhaoLevantamentosRefs<T extends Object>(
    Expression<T> Function($$TalhaoLevantamentosTableAnnotationComposer a) f,
  ) {
    final $$TalhaoLevantamentosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.inventoryRunId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableAnnotationComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InventoryRunsTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $InventoryRunsTable,
          InventoryRunRecord,
          $$InventoryRunsTableFilterComposer,
          $$InventoryRunsTableOrderingComposer,
          $$InventoryRunsTableAnnotationComposer,
          $$InventoryRunsTableCreateCompanionBuilder,
          $$InventoryRunsTableUpdateCompanionBuilder,
          (InventoryRunRecord, $$InventoryRunsTableReferences),
          InventoryRunRecord,
          PrefetchHooks Function({
            bool propertyId,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$InventoryRunsTableTableManager(
    _$DendroDatabase db,
    $InventoryRunsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> propertyId = const Value.absent(),
                Value<InventoryRunStatus> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryRunsCompanion(
                id: id,
                propertyId: propertyId,
                status: status,
                startedAt: startedAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String propertyId,
                required InventoryRunStatus status,
                required DateTime startedAt,
                required DateTime updatedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryRunsCompanion.insert(
                id: id,
                propertyId: propertyId,
                status: status,
                startedAt: startedAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InventoryRunsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({propertyId = false, talhaoLevantamentosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.propertyId,
                                    referencedTable:
                                        $$InventoryRunsTableReferences
                                            ._propertyIdTable(db),
                                    referencedColumn:
                                        $$InventoryRunsTableReferences
                                            ._propertyIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          InventoryRunRecord,
                          $InventoryRunsTable,
                          TalhaoLevantamentoRecord
                        >(
                          currentTable: table,
                          referencedTable: $$InventoryRunsTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InventoryRunsTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inventoryRunId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InventoryRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $InventoryRunsTable,
      InventoryRunRecord,
      $$InventoryRunsTableFilterComposer,
      $$InventoryRunsTableOrderingComposer,
      $$InventoryRunsTableAnnotationComposer,
      $$InventoryRunsTableCreateCompanionBuilder,
      $$InventoryRunsTableUpdateCompanionBuilder,
      (InventoryRunRecord, $$InventoryRunsTableReferences),
      InventoryRunRecord,
      PrefetchHooks Function({bool propertyId, bool talhaoLevantamentosRefs})
    >;
typedef $$TalhaoLevantamentosTableCreateCompanionBuilder =
    TalhaoLevantamentosCompanion Function({
      required String id,
      required String inventoryRunId,
      required String standId,
      required String speciesId,
      required String formulaId,
      Value<double?> defaultPlotAreaHa,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TalhaoLevantamentosTableUpdateCompanionBuilder =
    TalhaoLevantamentosCompanion Function({
      Value<String> id,
      Value<String> inventoryRunId,
      Value<String> standId,
      Value<String> speciesId,
      Value<String> formulaId,
      Value<double?> defaultPlotAreaHa,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TalhaoLevantamentosTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $TalhaoLevantamentosTable,
          TalhaoLevantamentoRecord
        > {
  $$TalhaoLevantamentosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InventoryRunsTable _inventoryRunIdTable(_$DendroDatabase db) =>
      db.inventoryRuns.createAlias(
        'talhao_levantamentos__inventory_run_id__inventory_runs__id',
      );

  $$InventoryRunsTableProcessedTableManager get inventoryRunId {
    final $_column = $_itemColumn<String>('inventory_run_id')!;

    final manager = $$InventoryRunsTableTableManager(
      $_db,
      $_db.inventoryRuns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inventoryRunIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StandsTable _standIdTable(_$DendroDatabase db) =>
      db.stands.createAlias('talhao_levantamentos__stand_id__stands__id');

  $$StandsTableProcessedTableManager get standId {
    final $_column = $_itemColumn<String>('stand_id')!;

    final manager = $$StandsTableTableManager(
      $_db,
      $_db.stands,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_standIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SpeciesTable _speciesIdTable(_$DendroDatabase db) =>
      db.species.createAlias('talhao_levantamentos__species_id__species__id');

  $$SpeciesTableProcessedTableManager get speciesId {
    final $_column = $_itemColumn<String>('species_id')!;

    final manager = $$SpeciesTableTableManager(
      $_db,
      $_db.species,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_speciesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FormulasTable _formulaIdTable(_$DendroDatabase db) =>
      db.formulas.createAlias('talhao_levantamentos__formula_id__formulas__id');

  $$FormulasTableProcessedTableManager get formulaId {
    final $_column = $_itemColumn<String>('formula_id')!;

    final manager = $$FormulasTableTableManager(
      $_db,
      $_db.formulas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_formulaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlotsTable, List<PlotRecord>> _plotsRefsTable(
    _$DendroDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.plots,
    aliasName: 'talhao_levantamentos__id__plots__talhao_levantamento_id',
  );

  $$PlotsTableProcessedTableManager get plotsRefs {
    final manager = $$PlotsTableTableManager($_db, $_db.plots).filter(
      (f) => f.talhaoLevantamentoId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_plotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TalhaoLevantamentosTableFilterComposer
    extends Composer<_$DendroDatabase, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultPlotAreaHa => $composableBuilder(
    column: $table.defaultPlotAreaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InventoryRunsTableFilterComposer get inventoryRunId {
    final $$InventoryRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventoryRunId,
      referencedTable: $db.inventoryRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryRunsTableFilterComposer(
            $db: $db,
            $table: $db.inventoryRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StandsTableFilterComposer get standId {
    final $$StandsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.standId,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableFilterComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableFilterComposer get speciesId {
    final $$SpeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableFilterComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableFilterComposer get formulaId {
    final $$FormulasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableFilterComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> plotsRefs(
    Expression<bool> Function($$PlotsTableFilterComposer f) f,
  ) {
    final $$PlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.talhaoLevantamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableFilterComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TalhaoLevantamentosTableOrderingComposer
    extends Composer<_$DendroDatabase, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultPlotAreaHa => $composableBuilder(
    column: $table.defaultPlotAreaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InventoryRunsTableOrderingComposer get inventoryRunId {
    final $$InventoryRunsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventoryRunId,
      referencedTable: $db.inventoryRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryRunsTableOrderingComposer(
            $db: $db,
            $table: $db.inventoryRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StandsTableOrderingComposer get standId {
    final $$StandsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.standId,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableOrderingComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableOrderingComposer get speciesId {
    final $$SpeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableOrderingComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableOrderingComposer get formulaId {
    final $$FormulasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableOrderingComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TalhaoLevantamentosTableAnnotationComposer
    extends Composer<_$DendroDatabase, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get defaultPlotAreaHa => $composableBuilder(
    column: $table.defaultPlotAreaHa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$InventoryRunsTableAnnotationComposer get inventoryRunId {
    final $$InventoryRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inventoryRunId,
      referencedTable: $db.inventoryRuns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StandsTableAnnotationComposer get standId {
    final $$StandsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.standId,
      referencedTable: $db.stands,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StandsTableAnnotationComposer(
            $db: $db,
            $table: $db.stands,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SpeciesTableAnnotationComposer get speciesId {
    final $$SpeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.speciesId,
      referencedTable: $db.species,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SpeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.species,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FormulasTableAnnotationComposer get formulaId {
    final $$FormulasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.formulaId,
      referencedTable: $db.formulas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FormulasTableAnnotationComposer(
            $db: $db,
            $table: $db.formulas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> plotsRefs<T extends Object>(
    Expression<T> Function($$PlotsTableAnnotationComposer a) f,
  ) {
    final $$PlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.talhaoLevantamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TalhaoLevantamentosTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $TalhaoLevantamentosTable,
          TalhaoLevantamentoRecord,
          $$TalhaoLevantamentosTableFilterComposer,
          $$TalhaoLevantamentosTableOrderingComposer,
          $$TalhaoLevantamentosTableAnnotationComposer,
          $$TalhaoLevantamentosTableCreateCompanionBuilder,
          $$TalhaoLevantamentosTableUpdateCompanionBuilder,
          (TalhaoLevantamentoRecord, $$TalhaoLevantamentosTableReferences),
          TalhaoLevantamentoRecord,
          PrefetchHooks Function({
            bool inventoryRunId,
            bool standId,
            bool speciesId,
            bool formulaId,
            bool plotsRefs,
          })
        > {
  $$TalhaoLevantamentosTableTableManager(
    _$DendroDatabase db,
    $TalhaoLevantamentosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TalhaoLevantamentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TalhaoLevantamentosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TalhaoLevantamentosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> inventoryRunId = const Value.absent(),
                Value<String> standId = const Value.absent(),
                Value<String> speciesId = const Value.absent(),
                Value<String> formulaId = const Value.absent(),
                Value<double?> defaultPlotAreaHa = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TalhaoLevantamentosCompanion(
                id: id,
                inventoryRunId: inventoryRunId,
                standId: standId,
                speciesId: speciesId,
                formulaId: formulaId,
                defaultPlotAreaHa: defaultPlotAreaHa,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String inventoryRunId,
                required String standId,
                required String speciesId,
                required String formulaId,
                Value<double?> defaultPlotAreaHa = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TalhaoLevantamentosCompanion.insert(
                id: id,
                inventoryRunId: inventoryRunId,
                standId: standId,
                speciesId: speciesId,
                formulaId: formulaId,
                defaultPlotAreaHa: defaultPlotAreaHa,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TalhaoLevantamentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                inventoryRunId = false,
                standId = false,
                speciesId = false,
                formulaId = false,
                plotsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (plotsRefs) db.plots],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (inventoryRunId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.inventoryRunId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._inventoryRunIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._inventoryRunIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (standId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.standId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._standIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._standIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (speciesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.speciesId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._speciesIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._speciesIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (formulaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.formulaId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._formulaIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._formulaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plotsRefs)
                        await $_getPrefetchedData<
                          TalhaoLevantamentoRecord,
                          $TalhaoLevantamentosTable,
                          PlotRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TalhaoLevantamentosTableReferences
                              ._plotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TalhaoLevantamentosTableReferences(
                                db,
                                table,
                                p0,
                              ).plotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.talhaoLevantamentoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TalhaoLevantamentosTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $TalhaoLevantamentosTable,
      TalhaoLevantamentoRecord,
      $$TalhaoLevantamentosTableFilterComposer,
      $$TalhaoLevantamentosTableOrderingComposer,
      $$TalhaoLevantamentosTableAnnotationComposer,
      $$TalhaoLevantamentosTableCreateCompanionBuilder,
      $$TalhaoLevantamentosTableUpdateCompanionBuilder,
      (TalhaoLevantamentoRecord, $$TalhaoLevantamentosTableReferences),
      TalhaoLevantamentoRecord,
      PrefetchHooks Function({
        bool inventoryRunId,
        bool standId,
        bool speciesId,
        bool formulaId,
        bool plotsRefs,
      })
    >;
typedef $$PlotsTableCreateCompanionBuilder =
    PlotsCompanion Function({
      required String id,
      required String talhaoLevantamentoId,
      required String identification,
      required PlotStatus status,
      Value<double?> areaHa,
      Value<PlotReferencePosition?> referencePosition,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlotsTableUpdateCompanionBuilder =
    PlotsCompanion Function({
      Value<String> id,
      Value<String> talhaoLevantamentoId,
      Value<String> identification,
      Value<PlotStatus> status,
      Value<double?> areaHa,
      Value<PlotReferencePosition?> referencePosition,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlotsTableReferences
    extends BaseReferences<_$DendroDatabase, $PlotsTable, PlotRecord> {
  $$PlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TalhaoLevantamentosTable _talhaoLevantamentoIdTable(
    _$DendroDatabase db,
  ) => db.talhaoLevantamentos.createAlias(
    'plots__talhao_levantamento_id__talhao_levantamentos__id',
  );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentoId {
    final $_column = $_itemColumn<String>('talhao_levantamento_id')!;

    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _talhaoLevantamentoIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlotGeoPointsTable, List<PlotGeoPointRecord>>
  _plotGeoPointsRefsTable(_$DendroDatabase db) => MultiTypedResultKey.fromTable(
    db.plotGeoPoints,
    aliasName: 'plots__id__plot_geo_points__plot_id',
  );

  $$PlotGeoPointsTableProcessedTableManager get plotGeoPointsRefs {
    final manager = $$PlotGeoPointsTableTableManager(
      $_db,
      $_db.plotGeoPoints,
    ).filter((f) => f.plotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plotGeoPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TreesTable, List<TreeRecord>> _treesRefsTable(
    _$DendroDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trees,
    aliasName: 'plots__id__trees__plot_id',
  );

  $$TreesTableProcessedTableManager get treesRefs {
    final manager = $$TreesTableTableManager(
      $_db,
      $_db.trees,
    ).filter((f) => f.plotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_treesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlotsTableFilterComposer
    extends Composer<_$DendroDatabase, $PlotsTable> {
  $$PlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlotStatus, PlotStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PlotReferencePosition?,
    PlotReferencePosition,
    String
  >
  get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TalhaoLevantamentosTableFilterComposer get talhaoLevantamentoId {
    final $$TalhaoLevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talhaoLevantamentoId,
      referencedTable: $db.talhaoLevantamentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhaoLevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.talhaoLevantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> plotGeoPointsRefs(
    Expression<bool> Function($$PlotGeoPointsTableFilterComposer f) f,
  ) {
    final $$PlotGeoPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plotGeoPoints,
      getReferencedColumn: (t) => t.plotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotGeoPointsTableFilterComposer(
            $db: $db,
            $table: $db.plotGeoPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> treesRefs(
    Expression<bool> Function($$TreesTableFilterComposer f) f,
  ) {
    final $$TreesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trees,
      getReferencedColumn: (t) => t.plotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreesTableFilterComposer(
            $db: $db,
            $table: $db.trees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlotsTableOrderingComposer
    extends Composer<_$DendroDatabase, $PlotsTable> {
  $$PlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TalhaoLevantamentosTableOrderingComposer get talhaoLevantamentoId {
    final $$TalhaoLevantamentosTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.talhaoLevantamentoId,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableOrderingComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$PlotsTableAnnotationComposer
    extends Composer<_$DendroDatabase, $PlotsTable> {
  $$PlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get identification => $composableBuilder(
    column: $table.identification,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlotStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get areaHa =>
      $composableBuilder(column: $table.areaHa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TalhaoLevantamentosTableAnnotationComposer get talhaoLevantamentoId {
    final $$TalhaoLevantamentosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.talhaoLevantamentoId,
          referencedTable: $db.talhaoLevantamentos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TalhaoLevantamentosTableAnnotationComposer(
                $db: $db,
                $table: $db.talhaoLevantamentos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> plotGeoPointsRefs<T extends Object>(
    Expression<T> Function($$PlotGeoPointsTableAnnotationComposer a) f,
  ) {
    final $$PlotGeoPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plotGeoPoints,
      getReferencedColumn: (t) => t.plotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotGeoPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.plotGeoPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> treesRefs<T extends Object>(
    Expression<T> Function($$TreesTableAnnotationComposer a) f,
  ) {
    final $$TreesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trees,
      getReferencedColumn: (t) => t.plotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TreesTableAnnotationComposer(
            $db: $db,
            $table: $db.trees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlotsTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $PlotsTable,
          PlotRecord,
          $$PlotsTableFilterComposer,
          $$PlotsTableOrderingComposer,
          $$PlotsTableAnnotationComposer,
          $$PlotsTableCreateCompanionBuilder,
          $$PlotsTableUpdateCompanionBuilder,
          (PlotRecord, $$PlotsTableReferences),
          PlotRecord,
          PrefetchHooks Function({
            bool talhaoLevantamentoId,
            bool plotGeoPointsRefs,
            bool treesRefs,
          })
        > {
  $$PlotsTableTableManager(_$DendroDatabase db, $PlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> talhaoLevantamentoId = const Value.absent(),
                Value<String> identification = const Value.absent(),
                Value<PlotStatus> status = const Value.absent(),
                Value<double?> areaHa = const Value.absent(),
                Value<PlotReferencePosition?> referencePosition =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlotsCompanion(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                identification: identification,
                status: status,
                areaHa: areaHa,
                referencePosition: referencePosition,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String talhaoLevantamentoId,
                required String identification,
                required PlotStatus status,
                Value<double?> areaHa = const Value.absent(),
                Value<PlotReferencePosition?> referencePosition =
                    const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlotsCompanion.insert(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                identification: identification,
                status: status,
                areaHa: areaHa,
                referencePosition: referencePosition,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlotsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                talhaoLevantamentoId = false,
                plotGeoPointsRefs = false,
                treesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (plotGeoPointsRefs) db.plotGeoPoints,
                    if (treesRefs) db.trees,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (talhaoLevantamentoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.talhaoLevantamentoId,
                                    referencedTable: $$PlotsTableReferences
                                        ._talhaoLevantamentoIdTable(db),
                                    referencedColumn: $$PlotsTableReferences
                                        ._talhaoLevantamentoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (plotGeoPointsRefs)
                        await $_getPrefetchedData<
                          PlotRecord,
                          $PlotsTable,
                          PlotGeoPointRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PlotsTableReferences
                              ._plotGeoPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlotsTableReferences(
                                db,
                                table,
                                p0,
                              ).plotGeoPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plotId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (treesRefs)
                        await $_getPrefetchedData<
                          PlotRecord,
                          $PlotsTable,
                          TreeRecord
                        >(
                          currentTable: table,
                          referencedTable: $$PlotsTableReferences
                              ._treesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlotsTableReferences(db, table, p0).treesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.plotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $PlotsTable,
      PlotRecord,
      $$PlotsTableFilterComposer,
      $$PlotsTableOrderingComposer,
      $$PlotsTableAnnotationComposer,
      $$PlotsTableCreateCompanionBuilder,
      $$PlotsTableUpdateCompanionBuilder,
      (PlotRecord, $$PlotsTableReferences),
      PlotRecord,
      PrefetchHooks Function({
        bool talhaoLevantamentoId,
        bool plotGeoPointsRefs,
        bool treesRefs,
      })
    >;
typedef $$PlotGeoPointsTableCreateCompanionBuilder =
    PlotGeoPointsCompanion Function({
      required String id,
      required String plotId,
      required int pointOrder,
      Value<PlotReferencePosition?> referencePosition,
      required double latitude,
      required double longitude,
      Value<double?> accuracyMeters,
      required DateTime capturedAt,
      Value<int> rowid,
    });
typedef $$PlotGeoPointsTableUpdateCompanionBuilder =
    PlotGeoPointsCompanion Function({
      Value<String> id,
      Value<String> plotId,
      Value<int> pointOrder,
      Value<PlotReferencePosition?> referencePosition,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> accuracyMeters,
      Value<DateTime> capturedAt,
      Value<int> rowid,
    });

final class $$PlotGeoPointsTableReferences
    extends
        BaseReferences<
          _$DendroDatabase,
          $PlotGeoPointsTable,
          PlotGeoPointRecord
        > {
  $$PlotGeoPointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlotsTable _plotIdTable(_$DendroDatabase db) =>
      db.plots.createAlias('plot_geo_points__plot_id__plots__id');

  $$PlotsTableProcessedTableManager get plotId {
    final $_column = $_itemColumn<String>('plot_id')!;

    final manager = $$PlotsTableTableManager(
      $_db,
      $_db.plots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlotGeoPointsTableFilterComposer
    extends Composer<_$DendroDatabase, $PlotGeoPointsTable> {
  $$PlotGeoPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointOrder => $composableBuilder(
    column: $table.pointOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PlotReferencePosition?,
    PlotReferencePosition,
    String
  >
  get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlotsTableFilterComposer get plotId {
    final $$PlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableFilterComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlotGeoPointsTableOrderingComposer
    extends Composer<_$DendroDatabase, $PlotGeoPointsTable> {
  $$PlotGeoPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointOrder => $composableBuilder(
    column: $table.pointOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlotsTableOrderingComposer get plotId {
    final $$PlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableOrderingComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlotGeoPointsTableAnnotationComposer
    extends Composer<_$DendroDatabase, $PlotGeoPointsTable> {
  $$PlotGeoPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pointOrder => $composableBuilder(
    column: $table.pointOrder,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  get referencePosition => $composableBuilder(
    column: $table.referencePosition,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  $$PlotsTableAnnotationComposer get plotId {
    final $$PlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlotGeoPointsTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $PlotGeoPointsTable,
          PlotGeoPointRecord,
          $$PlotGeoPointsTableFilterComposer,
          $$PlotGeoPointsTableOrderingComposer,
          $$PlotGeoPointsTableAnnotationComposer,
          $$PlotGeoPointsTableCreateCompanionBuilder,
          $$PlotGeoPointsTableUpdateCompanionBuilder,
          (PlotGeoPointRecord, $$PlotGeoPointsTableReferences),
          PlotGeoPointRecord,
          PrefetchHooks Function({bool plotId})
        > {
  $$PlotGeoPointsTableTableManager(
    _$DendroDatabase db,
    $PlotGeoPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlotGeoPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlotGeoPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlotGeoPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> plotId = const Value.absent(),
                Value<int> pointOrder = const Value.absent(),
                Value<PlotReferencePosition?> referencePosition =
                    const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlotGeoPointsCompanion(
                id: id,
                plotId: plotId,
                pointOrder: pointOrder,
                referencePosition: referencePosition,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String plotId,
                required int pointOrder,
                Value<PlotReferencePosition?> referencePosition =
                    const Value.absent(),
                required double latitude,
                required double longitude,
                Value<double?> accuracyMeters = const Value.absent(),
                required DateTime capturedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlotGeoPointsCompanion.insert(
                id: id,
                plotId: plotId,
                pointOrder: pointOrder,
                referencePosition: referencePosition,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                capturedAt: capturedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlotGeoPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (plotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plotId,
                                referencedTable: $$PlotGeoPointsTableReferences
                                    ._plotIdTable(db),
                                referencedColumn: $$PlotGeoPointsTableReferences
                                    ._plotIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlotGeoPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $PlotGeoPointsTable,
      PlotGeoPointRecord,
      $$PlotGeoPointsTableFilterComposer,
      $$PlotGeoPointsTableOrderingComposer,
      $$PlotGeoPointsTableAnnotationComposer,
      $$PlotGeoPointsTableCreateCompanionBuilder,
      $$PlotGeoPointsTableUpdateCompanionBuilder,
      (PlotGeoPointRecord, $$PlotGeoPointsTableReferences),
      PlotGeoPointRecord,
      PrefetchHooks Function({bool plotId})
    >;
typedef $$TreesTableCreateCompanionBuilder =
    TreesCompanion Function({
      required String id,
      required String plotId,
      required int number,
      required double dapCm,
      required double heightM,
      Value<bool> hasTortuousStem,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> accuracyMeters,
      Value<DateTime?> locationCapturedAt,
      Value<PlotReferencePosition?> plotReferencePosition,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TreesTableUpdateCompanionBuilder =
    TreesCompanion Function({
      Value<String> id,
      Value<String> plotId,
      Value<int> number,
      Value<double> dapCm,
      Value<double> heightM,
      Value<bool> hasTortuousStem,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> accuracyMeters,
      Value<DateTime?> locationCapturedAt,
      Value<PlotReferencePosition?> plotReferencePosition,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TreesTableReferences
    extends BaseReferences<_$DendroDatabase, $TreesTable, TreeRecord> {
  $$TreesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlotsTable _plotIdTable(_$DendroDatabase db) =>
      db.plots.createAlias('trees__plot_id__plots__id');

  $$PlotsTableProcessedTableManager get plotId {
    final $_column = $_itemColumn<String>('plot_id')!;

    final manager = $$PlotsTableTableManager(
      $_db,
      $_db.plots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TreesTableFilterComposer
    extends Composer<_$DendroDatabase, $TreesTable> {
  $$TreesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dapCm => $composableBuilder(
    column: $table.dapCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightM => $composableBuilder(
    column: $table.heightM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasTortuousStem => $composableBuilder(
    column: $table.hasTortuousStem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get locationCapturedAt => $composableBuilder(
    column: $table.locationCapturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PlotReferencePosition?,
    PlotReferencePosition,
    String
  >
  get plotReferencePosition => $composableBuilder(
    column: $table.plotReferencePosition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlotsTableFilterComposer get plotId {
    final $$PlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableFilterComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreesTableOrderingComposer
    extends Composer<_$DendroDatabase, $TreesTable> {
  $$TreesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dapCm => $composableBuilder(
    column: $table.dapCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightM => $composableBuilder(
    column: $table.heightM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasTortuousStem => $composableBuilder(
    column: $table.hasTortuousStem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get locationCapturedAt => $composableBuilder(
    column: $table.locationCapturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plotReferencePosition => $composableBuilder(
    column: $table.plotReferencePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlotsTableOrderingComposer get plotId {
    final $$PlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableOrderingComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreesTableAnnotationComposer
    extends Composer<_$DendroDatabase, $TreesTable> {
  $$TreesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<double> get dapCm =>
      $composableBuilder(column: $table.dapCm, builder: (column) => column);

  GeneratedColumn<double> get heightM =>
      $composableBuilder(column: $table.heightM, builder: (column) => column);

  GeneratedColumn<bool> get hasTortuousStem => $composableBuilder(
    column: $table.hasTortuousStem,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get locationCapturedAt => $composableBuilder(
    column: $table.locationCapturedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlotReferencePosition?, String>
  get plotReferencePosition => $composableBuilder(
    column: $table.plotReferencePosition,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlotsTableAnnotationComposer get plotId {
    final $$PlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plotId,
      referencedTable: $db.plots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.plots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TreesTableTableManager
    extends
        RootTableManager<
          _$DendroDatabase,
          $TreesTable,
          TreeRecord,
          $$TreesTableFilterComposer,
          $$TreesTableOrderingComposer,
          $$TreesTableAnnotationComposer,
          $$TreesTableCreateCompanionBuilder,
          $$TreesTableUpdateCompanionBuilder,
          (TreeRecord, $$TreesTableReferences),
          TreeRecord,
          PrefetchHooks Function({bool plotId})
        > {
  $$TreesTableTableManager(_$DendroDatabase db, $TreesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> plotId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<double> dapCm = const Value.absent(),
                Value<double> heightM = const Value.absent(),
                Value<bool> hasTortuousStem = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<DateTime?> locationCapturedAt = const Value.absent(),
                Value<PlotReferencePosition?> plotReferencePosition =
                    const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TreesCompanion(
                id: id,
                plotId: plotId,
                number: number,
                dapCm: dapCm,
                heightM: heightM,
                hasTortuousStem: hasTortuousStem,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                locationCapturedAt: locationCapturedAt,
                plotReferencePosition: plotReferencePosition,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String plotId,
                required int number,
                required double dapCm,
                required double heightM,
                Value<bool> hasTortuousStem = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> accuracyMeters = const Value.absent(),
                Value<DateTime?> locationCapturedAt = const Value.absent(),
                Value<PlotReferencePosition?> plotReferencePosition =
                    const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TreesCompanion.insert(
                id: id,
                plotId: plotId,
                number: number,
                dapCm: dapCm,
                heightM: heightM,
                hasTortuousStem: hasTortuousStem,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                locationCapturedAt: locationCapturedAt,
                plotReferencePosition: plotReferencePosition,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TreesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({plotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (plotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.plotId,
                                referencedTable: $$TreesTableReferences
                                    ._plotIdTable(db),
                                referencedColumn: $$TreesTableReferences
                                    ._plotIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TreesTableProcessedTableManager =
    ProcessedTableManager<
      _$DendroDatabase,
      $TreesTable,
      TreeRecord,
      $$TreesTableFilterComposer,
      $$TreesTableOrderingComposer,
      $$TreesTableAnnotationComposer,
      $$TreesTableCreateCompanionBuilder,
      $$TreesTableUpdateCompanionBuilder,
      (TreeRecord, $$TreesTableReferences),
      TreeRecord,
      PrefetchHooks Function({bool plotId})
    >;

class $DendroDatabaseManager {
  final _$DendroDatabase _db;
  $DendroDatabaseManager(this._db);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$SpeciesTableTableManager get species =>
      $$SpeciesTableTableManager(_db, _db.species);
  $$FormulasTableTableManager get formulas =>
      $$FormulasTableTableManager(_db, _db.formulas);
  $$FormulaVariablesTableTableManager get formulaVariables =>
      $$FormulaVariablesTableTableManager(_db, _db.formulaVariables);
  $$FormulaCoefficientsTableTableManager get formulaCoefficients =>
      $$FormulaCoefficientsTableTableManager(_db, _db.formulaCoefficients);
  $$SpeciesFormulasTableTableManager get speciesFormulas =>
      $$SpeciesFormulasTableTableManager(_db, _db.speciesFormulas);
  $$StandsTableTableManager get stands =>
      $$StandsTableTableManager(_db, _db.stands);
  $$InventoryRunsTableTableManager get inventoryRuns =>
      $$InventoryRunsTableTableManager(_db, _db.inventoryRuns);
  $$TalhaoLevantamentosTableTableManager get talhaoLevantamentos =>
      $$TalhaoLevantamentosTableTableManager(_db, _db.talhaoLevantamentos);
  $$PlotsTableTableManager get plots =>
      $$PlotsTableTableManager(_db, _db.plots);
  $$PlotGeoPointsTableTableManager get plotGeoPoints =>
      $$PlotGeoPointsTableTableManager(_db, _db.plotGeoPoints);
  $$TreesTableTableManager get trees =>
      $$TreesTableTableManager(_db, _db.trees);
}
