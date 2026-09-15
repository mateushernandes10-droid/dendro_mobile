// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco_dendro.dart';

// ignore_for_file: type=lint
class $PropriedadesTable extends Propriedades
    with TableInfo<$PropriedadesTable, Propriedade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropriedadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _municipioMeta = const VerificationMeta(
    'municipio',
  );
  @override
  late final GeneratedColumn<String> municipio = GeneratedColumn<String>(
    'municipio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('RS'),
  );
  static const VerificationMeta _areaTotalHaMeta = const VerificationMeta(
    'areaTotalHa',
  );
  @override
  late final GeneratedColumn<double> areaTotalHa = GeneratedColumn<double>(
    'area_total_ha',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    municipio,
    estado,
    areaTotalHa,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'propriedades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Propriedade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('municipio')) {
      context.handle(
        _municipioMeta,
        municipio.isAcceptableOrUnknown(data['municipio']!, _municipioMeta),
      );
    } else if (isInserting) {
      context.missing(_municipioMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('area_total_ha')) {
      context.handle(
        _areaTotalHaMeta,
        areaTotalHa.isAcceptableOrUnknown(
          data['area_total_ha']!,
          _areaTotalHaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_areaTotalHaMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Propriedade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Propriedade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      municipio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}municipio'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      areaTotalHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_total_ha'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $PropriedadesTable createAlias(String alias) {
    return $PropriedadesTable(attachedDatabase, alias);
  }
}

class Propriedade extends DataClass implements Insertable<Propriedade> {
  final int id;
  final String nome;
  final String municipio;
  final String estado;
  final double areaTotalHa;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Propriedade({
    required this.id,
    required this.nome,
    required this.municipio,
    required this.estado,
    required this.areaTotalHa,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['municipio'] = Variable<String>(municipio);
    map['estado'] = Variable<String>(estado);
    map['area_total_ha'] = Variable<double>(areaTotalHa);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  PropriedadesCompanion toCompanion(bool nullToAbsent) {
    return PropriedadesCompanion(
      id: Value(id),
      nome: Value(nome),
      municipio: Value(municipio),
      estado: Value(estado),
      areaTotalHa: Value(areaTotalHa),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Propriedade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Propriedade(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      municipio: serializer.fromJson<String>(json['municipio']),
      estado: serializer.fromJson<String>(json['estado']),
      areaTotalHa: serializer.fromJson<double>(json['areaTotalHa']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'municipio': serializer.toJson<String>(municipio),
      'estado': serializer.toJson<String>(estado),
      'areaTotalHa': serializer.toJson<double>(areaTotalHa),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Propriedade copyWith({
    int? id,
    String? nome,
    String? municipio,
    String? estado,
    double? areaTotalHa,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Propriedade(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    municipio: municipio ?? this.municipio,
    estado: estado ?? this.estado,
    areaTotalHa: areaTotalHa ?? this.areaTotalHa,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Propriedade copyWithCompanion(PropriedadesCompanion data) {
    return Propriedade(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      municipio: data.municipio.present ? data.municipio.value : this.municipio,
      estado: data.estado.present ? data.estado.value : this.estado,
      areaTotalHa: data.areaTotalHa.present
          ? data.areaTotalHa.value
          : this.areaTotalHa,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Propriedade(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('areaTotalHa: $areaTotalHa, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    municipio,
    estado,
    areaTotalHa,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Propriedade &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.municipio == this.municipio &&
          other.estado == this.estado &&
          other.areaTotalHa == this.areaTotalHa &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class PropriedadesCompanion extends UpdateCompanion<Propriedade> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> municipio;
  final Value<String> estado;
  final Value<double> areaTotalHa;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const PropriedadesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.municipio = const Value.absent(),
    this.estado = const Value.absent(),
    this.areaTotalHa = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  PropriedadesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String municipio,
    this.estado = const Value.absent(),
    required double areaTotalHa,
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : nome = Value(nome),
       municipio = Value(municipio),
       areaTotalHa = Value(areaTotalHa),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Propriedade> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? municipio,
    Expression<String>? estado,
    Expression<double>? areaTotalHa,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (municipio != null) 'municipio': municipio,
      if (estado != null) 'estado': estado,
      if (areaTotalHa != null) 'area_total_ha': areaTotalHa,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  PropriedadesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? municipio,
    Value<String>? estado,
    Value<double>? areaTotalHa,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return PropriedadesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      municipio: municipio ?? this.municipio,
      estado: estado ?? this.estado,
      areaTotalHa: areaTotalHa ?? this.areaTotalHa,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (municipio.present) {
      map['municipio'] = Variable<String>(municipio.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (areaTotalHa.present) {
      map['area_total_ha'] = Variable<double>(areaTotalHa.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropriedadesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('municipio: $municipio, ')
          ..write('estado: $estado, ')
          ..write('areaTotalHa: $areaTotalHa, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $EspeciesTable extends Especies with TableInfo<$EspeciesTable, Especie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EspeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomeCientificoMeta = const VerificationMeta(
    'nomeCientifico',
  );
  @override
  late final GeneratedColumn<String> nomeCientifico = GeneratedColumn<String>(
    'nome_cientifico',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nome,
    nomeCientifico,
    descricao,
    ativo,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'especies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Especie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('nome_cientifico')) {
      context.handle(
        _nomeCientificoMeta,
        nomeCientifico.isAcceptableOrUnknown(
          data['nome_cientifico']!,
          _nomeCientificoMeta,
        ),
      );
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Especie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Especie(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      ),
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      nomeCientifico: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_cientifico'],
      ),
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $EspeciesTable createAlias(String alias) {
    return $EspeciesTable(attachedDatabase, alias);
  }
}

class Especie extends DataClass implements Insertable<Especie> {
  final int id;
  final String? codigo;
  final String nome;
  final String? nomeCientifico;
  final String? descricao;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Especie({
    required this.id,
    this.codigo,
    required this.nome,
    this.nomeCientifico,
    this.descricao,
    required this.ativo,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || nomeCientifico != null) {
      map['nome_cientifico'] = Variable<String>(nomeCientifico);
    }
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  EspeciesCompanion toCompanion(bool nullToAbsent) {
    return EspeciesCompanion(
      id: Value(id),
      codigo: codigo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigo),
      nome: Value(nome),
      nomeCientifico: nomeCientifico == null && nullToAbsent
          ? const Value.absent()
          : Value(nomeCientifico),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Especie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Especie(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      nome: serializer.fromJson<String>(json['nome']),
      nomeCientifico: serializer.fromJson<String?>(json['nomeCientifico']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String?>(codigo),
      'nome': serializer.toJson<String>(nome),
      'nomeCientifico': serializer.toJson<String?>(nomeCientifico),
      'descricao': serializer.toJson<String?>(descricao),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Especie copyWith({
    int? id,
    Value<String?> codigo = const Value.absent(),
    String? nome,
    Value<String?> nomeCientifico = const Value.absent(),
    Value<String?> descricao = const Value.absent(),
    bool? ativo,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Especie(
    id: id ?? this.id,
    codigo: codigo.present ? codigo.value : this.codigo,
    nome: nome ?? this.nome,
    nomeCientifico: nomeCientifico.present
        ? nomeCientifico.value
        : this.nomeCientifico,
    descricao: descricao.present ? descricao.value : this.descricao,
    ativo: ativo ?? this.ativo,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Especie copyWithCompanion(EspeciesCompanion data) {
    return Especie(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nome: data.nome.present ? data.nome.value : this.nome,
      nomeCientifico: data.nomeCientifico.present
          ? data.nomeCientifico.value
          : this.nomeCientifico,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Especie(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('nomeCientifico: $nomeCientifico, ')
          ..write('descricao: $descricao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nome,
    nomeCientifico,
    descricao,
    ativo,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Especie &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nome == this.nome &&
          other.nomeCientifico == this.nomeCientifico &&
          other.descricao == this.descricao &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class EspeciesCompanion extends UpdateCompanion<Especie> {
  final Value<int> id;
  final Value<String?> codigo;
  final Value<String> nome;
  final Value<String?> nomeCientifico;
  final Value<String?> descricao;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const EspeciesCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nome = const Value.absent(),
    this.nomeCientifico = const Value.absent(),
    this.descricao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  EspeciesCompanion.insert({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    required String nome,
    this.nomeCientifico = const Value.absent(),
    this.descricao = const Value.absent(),
    this.ativo = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : nome = Value(nome),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Especie> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nome,
    Expression<String>? nomeCientifico,
    Expression<String>? descricao,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nome != null) 'nome': nome,
      if (nomeCientifico != null) 'nome_cientifico': nomeCientifico,
      if (descricao != null) 'descricao': descricao,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  EspeciesCompanion copyWith({
    Value<int>? id,
    Value<String?>? codigo,
    Value<String>? nome,
    Value<String?>? nomeCientifico,
    Value<String?>? descricao,
    Value<bool>? ativo,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return EspeciesCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      nomeCientifico: nomeCientifico ?? this.nomeCientifico,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (nomeCientifico.present) {
      map['nome_cientifico'] = Variable<String>(nomeCientifico.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EspeciesCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('nomeCientifico: $nomeCientifico, ')
          ..write('descricao: $descricao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $ModelosMatematicosTable extends ModelosMatematicos
    with TableInfo<$ModelosMatematicosTable, ModeloMatematico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelosMatematicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expressaoMeta = const VerificationMeta(
    'expressao',
  );
  @override
  late final GeneratedColumn<String> expressao = GeneratedColumn<String>(
    'expressao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nome,
    descricao,
    expressao,
    ativo,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modelos_matematicos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModeloMatematico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    }
    if (data.containsKey('expressao')) {
      context.handle(
        _expressaoMeta,
        expressao.isAcceptableOrUnknown(data['expressao']!, _expressaoMeta),
      );
    } else if (isInserting) {
      context.missing(_expressaoMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModeloMatematico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModeloMatematico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      ),
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      ),
      expressao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expressao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $ModelosMatematicosTable createAlias(String alias) {
    return $ModelosMatematicosTable(attachedDatabase, alias);
  }
}

class ModeloMatematico extends DataClass
    implements Insertable<ModeloMatematico> {
  final int id;
  final String? codigo;
  final String nome;
  final String? descricao;
  final String expressao;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const ModeloMatematico({
    required this.id,
    this.codigo,
    required this.nome,
    this.descricao,
    required this.expressao,
    required this.ativo,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || descricao != null) {
      map['descricao'] = Variable<String>(descricao);
    }
    map['expressao'] = Variable<String>(expressao);
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ModelosMatematicosCompanion toCompanion(bool nullToAbsent) {
    return ModelosMatematicosCompanion(
      id: Value(id),
      codigo: codigo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigo),
      nome: Value(nome),
      descricao: descricao == null && nullToAbsent
          ? const Value.absent()
          : Value(descricao),
      expressao: Value(expressao),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory ModeloMatematico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModeloMatematico(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      nome: serializer.fromJson<String>(json['nome']),
      descricao: serializer.fromJson<String?>(json['descricao']),
      expressao: serializer.fromJson<String>(json['expressao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String?>(codigo),
      'nome': serializer.toJson<String>(nome),
      'descricao': serializer.toJson<String?>(descricao),
      'expressao': serializer.toJson<String>(expressao),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  ModeloMatematico copyWith({
    int? id,
    Value<String?> codigo = const Value.absent(),
    String? nome,
    Value<String?> descricao = const Value.absent(),
    String? expressao,
    bool? ativo,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => ModeloMatematico(
    id: id ?? this.id,
    codigo: codigo.present ? codigo.value : this.codigo,
    nome: nome ?? this.nome,
    descricao: descricao.present ? descricao.value : this.descricao,
    expressao: expressao ?? this.expressao,
    ativo: ativo ?? this.ativo,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  ModeloMatematico copyWithCompanion(ModelosMatematicosCompanion data) {
    return ModeloMatematico(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nome: data.nome.present ? data.nome.value : this.nome,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      expressao: data.expressao.present ? data.expressao.value : this.expressao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModeloMatematico(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('expressao: $expressao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nome,
    descricao,
    expressao,
    ativo,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModeloMatematico &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nome == this.nome &&
          other.descricao == this.descricao &&
          other.expressao == this.expressao &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ModelosMatematicosCompanion extends UpdateCompanion<ModeloMatematico> {
  final Value<int> id;
  final Value<String?> codigo;
  final Value<String> nome;
  final Value<String?> descricao;
  final Value<String> expressao;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const ModelosMatematicosCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nome = const Value.absent(),
    this.descricao = const Value.absent(),
    this.expressao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  ModelosMatematicosCompanion.insert({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    required String nome,
    this.descricao = const Value.absent(),
    required String expressao,
    this.ativo = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : nome = Value(nome),
       expressao = Value(expressao),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<ModeloMatematico> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nome,
    Expression<String>? descricao,
    Expression<String>? expressao,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nome != null) 'nome': nome,
      if (descricao != null) 'descricao': descricao,
      if (expressao != null) 'expressao': expressao,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  ModelosMatematicosCompanion copyWith({
    Value<int>? id,
    Value<String?>? codigo,
    Value<String>? nome,
    Value<String?>? descricao,
    Value<String>? expressao,
    Value<bool>? ativo,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return ModelosMatematicosCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      expressao: expressao ?? this.expressao,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (expressao.present) {
      map['expressao'] = Variable<String>(expressao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelosMatematicosCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nome: $nome, ')
          ..write('descricao: $descricao, ')
          ..write('expressao: $expressao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $VariaveisModeloTable extends VariaveisModelo
    with TableInfo<$VariaveisModeloTable, VariavelModelo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariaveisModeloTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeloMatematicoIdMeta =
      const VerificationMeta('modeloMatematicoId');
  @override
  late final GeneratedColumn<int> modeloMatematicoId = GeneratedColumn<int>(
    'modelo_matematico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modelos_matematicos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _simboloMeta = const VerificationMeta(
    'simbolo',
  );
  @override
  late final GeneratedColumn<String> simbolo = GeneratedColumn<String>(
    'simbolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotuloMeta = const VerificationMeta('rotulo');
  @override
  late final GeneratedColumn<String> rotulo = GeneratedColumn<String>(
    'rotulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadeMeta = const VerificationMeta(
    'unidade',
  );
  @override
  late final GeneratedColumn<String> unidade = GeneratedColumn<String>(
    'unidade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _origemValorMeta = const VerificationMeta(
    'origemValor',
  );
  @override
  late final GeneratedColumn<String> origemValor = GeneratedColumn<String>(
    'origem_valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChaveVariavelModelo, String>
  chaveVariavel =
      GeneratedColumn<String>(
        'chave_variavel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ChaveVariavelModelo>(
        $VariaveisModeloTable.$converterchaveVariavel,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modeloMatematicoId,
    simbolo,
    rotulo,
    unidade,
    origemValor,
    chaveVariavel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variaveis_modelo';
  @override
  VerificationContext validateIntegrity(
    Insertable<VariavelModelo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_matematico_id')) {
      context.handle(
        _modeloMatematicoIdMeta,
        modeloMatematicoId.isAcceptableOrUnknown(
          data['modelo_matematico_id']!,
          _modeloMatematicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modeloMatematicoIdMeta);
    }
    if (data.containsKey('simbolo')) {
      context.handle(
        _simboloMeta,
        simbolo.isAcceptableOrUnknown(data['simbolo']!, _simboloMeta),
      );
    } else if (isInserting) {
      context.missing(_simboloMeta);
    }
    if (data.containsKey('rotulo')) {
      context.handle(
        _rotuloMeta,
        rotulo.isAcceptableOrUnknown(data['rotulo']!, _rotuloMeta),
      );
    } else if (isInserting) {
      context.missing(_rotuloMeta);
    }
    if (data.containsKey('unidade')) {
      context.handle(
        _unidadeMeta,
        unidade.isAcceptableOrUnknown(data['unidade']!, _unidadeMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadeMeta);
    }
    if (data.containsKey('origem_valor')) {
      context.handle(
        _origemValorMeta,
        origemValor.isAcceptableOrUnknown(
          data['origem_valor']!,
          _origemValorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_origemValorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VariavelModelo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VariavelModelo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modeloMatematicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modelo_matematico_id'],
      )!,
      simbolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simbolo'],
      )!,
      rotulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotulo'],
      )!,
      unidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidade'],
      )!,
      origemValor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem_valor'],
      )!,
      chaveVariavel: $VariaveisModeloTable.$converterchaveVariavel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}chave_variavel'],
        )!,
      ),
    );
  }

  @override
  $VariaveisModeloTable createAlias(String alias) {
    return $VariaveisModeloTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChaveVariavelModelo, String, String>
  $converterchaveVariavel = const EnumNameConverter<ChaveVariavelModelo>(
    ChaveVariavelModelo.values,
  );
}

class VariavelModelo extends DataClass implements Insertable<VariavelModelo> {
  final int id;
  final int modeloMatematicoId;
  final String simbolo;
  final String rotulo;
  final String unidade;
  final String origemValor;
  final ChaveVariavelModelo chaveVariavel;
  const VariavelModelo({
    required this.id,
    required this.modeloMatematicoId,
    required this.simbolo,
    required this.rotulo,
    required this.unidade,
    required this.origemValor,
    required this.chaveVariavel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId);
    map['simbolo'] = Variable<String>(simbolo);
    map['rotulo'] = Variable<String>(rotulo);
    map['unidade'] = Variable<String>(unidade);
    map['origem_valor'] = Variable<String>(origemValor);
    {
      map['chave_variavel'] = Variable<String>(
        $VariaveisModeloTable.$converterchaveVariavel.toSql(chaveVariavel),
      );
    }
    return map;
  }

  VariaveisModeloCompanion toCompanion(bool nullToAbsent) {
    return VariaveisModeloCompanion(
      id: Value(id),
      modeloMatematicoId: Value(modeloMatematicoId),
      simbolo: Value(simbolo),
      rotulo: Value(rotulo),
      unidade: Value(unidade),
      origemValor: Value(origemValor),
      chaveVariavel: Value(chaveVariavel),
    );
  }

  factory VariavelModelo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VariavelModelo(
      id: serializer.fromJson<int>(json['id']),
      modeloMatematicoId: serializer.fromJson<int>(json['modeloMatematicoId']),
      simbolo: serializer.fromJson<String>(json['simbolo']),
      rotulo: serializer.fromJson<String>(json['rotulo']),
      unidade: serializer.fromJson<String>(json['unidade']),
      origemValor: serializer.fromJson<String>(json['origemValor']),
      chaveVariavel: $VariaveisModeloTable.$converterchaveVariavel.fromJson(
        serializer.fromJson<String>(json['chaveVariavel']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloMatematicoId': serializer.toJson<int>(modeloMatematicoId),
      'simbolo': serializer.toJson<String>(simbolo),
      'rotulo': serializer.toJson<String>(rotulo),
      'unidade': serializer.toJson<String>(unidade),
      'origemValor': serializer.toJson<String>(origemValor),
      'chaveVariavel': serializer.toJson<String>(
        $VariaveisModeloTable.$converterchaveVariavel.toJson(chaveVariavel),
      ),
    };
  }

  VariavelModelo copyWith({
    int? id,
    int? modeloMatematicoId,
    String? simbolo,
    String? rotulo,
    String? unidade,
    String? origemValor,
    ChaveVariavelModelo? chaveVariavel,
  }) => VariavelModelo(
    id: id ?? this.id,
    modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
    simbolo: simbolo ?? this.simbolo,
    rotulo: rotulo ?? this.rotulo,
    unidade: unidade ?? this.unidade,
    origemValor: origemValor ?? this.origemValor,
    chaveVariavel: chaveVariavel ?? this.chaveVariavel,
  );
  VariavelModelo copyWithCompanion(VariaveisModeloCompanion data) {
    return VariavelModelo(
      id: data.id.present ? data.id.value : this.id,
      modeloMatematicoId: data.modeloMatematicoId.present
          ? data.modeloMatematicoId.value
          : this.modeloMatematicoId,
      simbolo: data.simbolo.present ? data.simbolo.value : this.simbolo,
      rotulo: data.rotulo.present ? data.rotulo.value : this.rotulo,
      unidade: data.unidade.present ? data.unidade.value : this.unidade,
      origemValor: data.origemValor.present
          ? data.origemValor.value
          : this.origemValor,
      chaveVariavel: data.chaveVariavel.present
          ? data.chaveVariavel.value
          : this.chaveVariavel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VariavelModelo(')
          ..write('id: $id, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('unidade: $unidade, ')
          ..write('origemValor: $origemValor, ')
          ..write('chaveVariavel: $chaveVariavel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modeloMatematicoId,
    simbolo,
    rotulo,
    unidade,
    origemValor,
    chaveVariavel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariavelModelo &&
          other.id == this.id &&
          other.modeloMatematicoId == this.modeloMatematicoId &&
          other.simbolo == this.simbolo &&
          other.rotulo == this.rotulo &&
          other.unidade == this.unidade &&
          other.origemValor == this.origemValor &&
          other.chaveVariavel == this.chaveVariavel);
}

class VariaveisModeloCompanion extends UpdateCompanion<VariavelModelo> {
  final Value<int> id;
  final Value<int> modeloMatematicoId;
  final Value<String> simbolo;
  final Value<String> rotulo;
  final Value<String> unidade;
  final Value<String> origemValor;
  final Value<ChaveVariavelModelo> chaveVariavel;
  const VariaveisModeloCompanion({
    this.id = const Value.absent(),
    this.modeloMatematicoId = const Value.absent(),
    this.simbolo = const Value.absent(),
    this.rotulo = const Value.absent(),
    this.unidade = const Value.absent(),
    this.origemValor = const Value.absent(),
    this.chaveVariavel = const Value.absent(),
  });
  VariaveisModeloCompanion.insert({
    this.id = const Value.absent(),
    required int modeloMatematicoId,
    required String simbolo,
    required String rotulo,
    required String unidade,
    required String origemValor,
    required ChaveVariavelModelo chaveVariavel,
  }) : modeloMatematicoId = Value(modeloMatematicoId),
       simbolo = Value(simbolo),
       rotulo = Value(rotulo),
       unidade = Value(unidade),
       origemValor = Value(origemValor),
       chaveVariavel = Value(chaveVariavel);
  static Insertable<VariavelModelo> custom({
    Expression<int>? id,
    Expression<int>? modeloMatematicoId,
    Expression<String>? simbolo,
    Expression<String>? rotulo,
    Expression<String>? unidade,
    Expression<String>? origemValor,
    Expression<String>? chaveVariavel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloMatematicoId != null)
        'modelo_matematico_id': modeloMatematicoId,
      if (simbolo != null) 'simbolo': simbolo,
      if (rotulo != null) 'rotulo': rotulo,
      if (unidade != null) 'unidade': unidade,
      if (origemValor != null) 'origem_valor': origemValor,
      if (chaveVariavel != null) 'chave_variavel': chaveVariavel,
    });
  }

  VariaveisModeloCompanion copyWith({
    Value<int>? id,
    Value<int>? modeloMatematicoId,
    Value<String>? simbolo,
    Value<String>? rotulo,
    Value<String>? unidade,
    Value<String>? origemValor,
    Value<ChaveVariavelModelo>? chaveVariavel,
  }) {
    return VariaveisModeloCompanion(
      id: id ?? this.id,
      modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
      simbolo: simbolo ?? this.simbolo,
      rotulo: rotulo ?? this.rotulo,
      unidade: unidade ?? this.unidade,
      origemValor: origemValor ?? this.origemValor,
      chaveVariavel: chaveVariavel ?? this.chaveVariavel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloMatematicoId.present) {
      map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId.value);
    }
    if (simbolo.present) {
      map['simbolo'] = Variable<String>(simbolo.value);
    }
    if (rotulo.present) {
      map['rotulo'] = Variable<String>(rotulo.value);
    }
    if (unidade.present) {
      map['unidade'] = Variable<String>(unidade.value);
    }
    if (origemValor.present) {
      map['origem_valor'] = Variable<String>(origemValor.value);
    }
    if (chaveVariavel.present) {
      map['chave_variavel'] = Variable<String>(
        $VariaveisModeloTable.$converterchaveVariavel.toSql(
          chaveVariavel.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariaveisModeloCompanion(')
          ..write('id: $id, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('unidade: $unidade, ')
          ..write('origemValor: $origemValor, ')
          ..write('chaveVariavel: $chaveVariavel')
          ..write(')'))
        .toString();
  }
}

class $CoeficientesModeloTable extends CoeficientesModelo
    with TableInfo<$CoeficientesModeloTable, CoeficienteModelo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoeficientesModeloTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modeloMatematicoIdMeta =
      const VerificationMeta('modeloMatematicoId');
  @override
  late final GeneratedColumn<int> modeloMatematicoId = GeneratedColumn<int>(
    'modelo_matematico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modelos_matematicos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _simboloMeta = const VerificationMeta(
    'simbolo',
  );
  @override
  late final GeneratedColumn<String> simbolo = GeneratedColumn<String>(
    'simbolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotuloMeta = const VerificationMeta('rotulo');
  @override
  late final GeneratedColumn<String> rotulo = GeneratedColumn<String>(
    'rotulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modeloMatematicoId,
    simbolo,
    rotulo,
    valor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coeficientes_modelo';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoeficienteModelo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('modelo_matematico_id')) {
      context.handle(
        _modeloMatematicoIdMeta,
        modeloMatematicoId.isAcceptableOrUnknown(
          data['modelo_matematico_id']!,
          _modeloMatematicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modeloMatematicoIdMeta);
    }
    if (data.containsKey('simbolo')) {
      context.handle(
        _simboloMeta,
        simbolo.isAcceptableOrUnknown(data['simbolo']!, _simboloMeta),
      );
    } else if (isInserting) {
      context.missing(_simboloMeta);
    }
    if (data.containsKey('rotulo')) {
      context.handle(
        _rotuloMeta,
        rotulo.isAcceptableOrUnknown(data['rotulo']!, _rotuloMeta),
      );
    } else if (isInserting) {
      context.missing(_rotuloMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoeficienteModelo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoeficienteModelo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modeloMatematicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modelo_matematico_id'],
      )!,
      simbolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simbolo'],
      )!,
      rotulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotulo'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      ),
    );
  }

  @override
  $CoeficientesModeloTable createAlias(String alias) {
    return $CoeficientesModeloTable(attachedDatabase, alias);
  }
}

class CoeficienteModelo extends DataClass
    implements Insertable<CoeficienteModelo> {
  final int id;
  final int modeloMatematicoId;
  final String simbolo;
  final String rotulo;
  final double? valor;
  const CoeficienteModelo({
    required this.id,
    required this.modeloMatematicoId,
    required this.simbolo,
    required this.rotulo,
    this.valor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId);
    map['simbolo'] = Variable<String>(simbolo);
    map['rotulo'] = Variable<String>(rotulo);
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double>(valor);
    }
    return map;
  }

  CoeficientesModeloCompanion toCompanion(bool nullToAbsent) {
    return CoeficientesModeloCompanion(
      id: Value(id),
      modeloMatematicoId: Value(modeloMatematicoId),
      simbolo: Value(simbolo),
      rotulo: Value(rotulo),
      valor: valor == null && nullToAbsent
          ? const Value.absent()
          : Value(valor),
    );
  }

  factory CoeficienteModelo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoeficienteModelo(
      id: serializer.fromJson<int>(json['id']),
      modeloMatematicoId: serializer.fromJson<int>(json['modeloMatematicoId']),
      simbolo: serializer.fromJson<String>(json['simbolo']),
      rotulo: serializer.fromJson<String>(json['rotulo']),
      valor: serializer.fromJson<double?>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modeloMatematicoId': serializer.toJson<int>(modeloMatematicoId),
      'simbolo': serializer.toJson<String>(simbolo),
      'rotulo': serializer.toJson<String>(rotulo),
      'valor': serializer.toJson<double?>(valor),
    };
  }

  CoeficienteModelo copyWith({
    int? id,
    int? modeloMatematicoId,
    String? simbolo,
    String? rotulo,
    Value<double?> valor = const Value.absent(),
  }) => CoeficienteModelo(
    id: id ?? this.id,
    modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
    simbolo: simbolo ?? this.simbolo,
    rotulo: rotulo ?? this.rotulo,
    valor: valor.present ? valor.value : this.valor,
  );
  CoeficienteModelo copyWithCompanion(CoeficientesModeloCompanion data) {
    return CoeficienteModelo(
      id: data.id.present ? data.id.value : this.id,
      modeloMatematicoId: data.modeloMatematicoId.present
          ? data.modeloMatematicoId.value
          : this.modeloMatematicoId,
      simbolo: data.simbolo.present ? data.simbolo.value : this.simbolo,
      rotulo: data.rotulo.present ? data.rotulo.value : this.rotulo,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoeficienteModelo(')
          ..write('id: $id, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, modeloMatematicoId, simbolo, rotulo, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoeficienteModelo &&
          other.id == this.id &&
          other.modeloMatematicoId == this.modeloMatematicoId &&
          other.simbolo == this.simbolo &&
          other.rotulo == this.rotulo &&
          other.valor == this.valor);
}

class CoeficientesModeloCompanion extends UpdateCompanion<CoeficienteModelo> {
  final Value<int> id;
  final Value<int> modeloMatematicoId;
  final Value<String> simbolo;
  final Value<String> rotulo;
  final Value<double?> valor;
  const CoeficientesModeloCompanion({
    this.id = const Value.absent(),
    this.modeloMatematicoId = const Value.absent(),
    this.simbolo = const Value.absent(),
    this.rotulo = const Value.absent(),
    this.valor = const Value.absent(),
  });
  CoeficientesModeloCompanion.insert({
    this.id = const Value.absent(),
    required int modeloMatematicoId,
    required String simbolo,
    required String rotulo,
    this.valor = const Value.absent(),
  }) : modeloMatematicoId = Value(modeloMatematicoId),
       simbolo = Value(simbolo),
       rotulo = Value(rotulo);
  static Insertable<CoeficienteModelo> custom({
    Expression<int>? id,
    Expression<int>? modeloMatematicoId,
    Expression<String>? simbolo,
    Expression<String>? rotulo,
    Expression<double>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modeloMatematicoId != null)
        'modelo_matematico_id': modeloMatematicoId,
      if (simbolo != null) 'simbolo': simbolo,
      if (rotulo != null) 'rotulo': rotulo,
      if (valor != null) 'valor': valor,
    });
  }

  CoeficientesModeloCompanion copyWith({
    Value<int>? id,
    Value<int>? modeloMatematicoId,
    Value<String>? simbolo,
    Value<String>? rotulo,
    Value<double?>? valor,
  }) {
    return CoeficientesModeloCompanion(
      id: id ?? this.id,
      modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
      simbolo: simbolo ?? this.simbolo,
      rotulo: rotulo ?? this.rotulo,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modeloMatematicoId.present) {
      map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId.value);
    }
    if (simbolo.present) {
      map['simbolo'] = Variable<String>(simbolo.value);
    }
    if (rotulo.present) {
      map['rotulo'] = Variable<String>(rotulo.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoeficientesModeloCompanion(')
          ..write('id: $id, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

class $EspeciesModelosTable extends EspeciesModelos
    with TableInfo<$EspeciesModelosTable, EspecieModelo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EspeciesModelosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _especieIdMeta = const VerificationMeta(
    'especieId',
  );
  @override
  late final GeneratedColumn<int> especieId = GeneratedColumn<int>(
    'especie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES especies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _modeloMatematicoIdMeta =
      const VerificationMeta('modeloMatematicoId');
  @override
  late final GeneratedColumn<int> modeloMatematicoId = GeneratedColumn<int>(
    'modelo_matematico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modelos_matematicos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _padraoMeta = const VerificationMeta('padrao');
  @override
  late final GeneratedColumn<bool> padrao = GeneratedColumn<bool>(
    'padrao',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("padrao" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    especieId,
    modeloMatematicoId,
    padrao,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'especies_modelos';
  @override
  VerificationContext validateIntegrity(
    Insertable<EspecieModelo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('especie_id')) {
      context.handle(
        _especieIdMeta,
        especieId.isAcceptableOrUnknown(data['especie_id']!, _especieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_especieIdMeta);
    }
    if (data.containsKey('modelo_matematico_id')) {
      context.handle(
        _modeloMatematicoIdMeta,
        modeloMatematicoId.isAcceptableOrUnknown(
          data['modelo_matematico_id']!,
          _modeloMatematicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modeloMatematicoIdMeta);
    }
    if (data.containsKey('padrao')) {
      context.handle(
        _padraoMeta,
        padrao.isAcceptableOrUnknown(data['padrao']!, _padraoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {especieId, modeloMatematicoId};
  @override
  EspecieModelo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EspecieModelo(
      especieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}especie_id'],
      )!,
      modeloMatematicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modelo_matematico_id'],
      )!,
      padrao: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}padrao'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $EspeciesModelosTable createAlias(String alias) {
    return $EspeciesModelosTable(attachedDatabase, alias);
  }
}

class EspecieModelo extends DataClass implements Insertable<EspecieModelo> {
  final int especieId;
  final int modeloMatematicoId;
  final bool padrao;
  final DateTime criadoEm;
  const EspecieModelo({
    required this.especieId,
    required this.modeloMatematicoId,
    required this.padrao,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['especie_id'] = Variable<int>(especieId);
    map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId);
    map['padrao'] = Variable<bool>(padrao);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  EspeciesModelosCompanion toCompanion(bool nullToAbsent) {
    return EspeciesModelosCompanion(
      especieId: Value(especieId),
      modeloMatematicoId: Value(modeloMatematicoId),
      padrao: Value(padrao),
      criadoEm: Value(criadoEm),
    );
  }

  factory EspecieModelo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EspecieModelo(
      especieId: serializer.fromJson<int>(json['especieId']),
      modeloMatematicoId: serializer.fromJson<int>(json['modeloMatematicoId']),
      padrao: serializer.fromJson<bool>(json['padrao']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'especieId': serializer.toJson<int>(especieId),
      'modeloMatematicoId': serializer.toJson<int>(modeloMatematicoId),
      'padrao': serializer.toJson<bool>(padrao),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  EspecieModelo copyWith({
    int? especieId,
    int? modeloMatematicoId,
    bool? padrao,
    DateTime? criadoEm,
  }) => EspecieModelo(
    especieId: especieId ?? this.especieId,
    modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
    padrao: padrao ?? this.padrao,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  EspecieModelo copyWithCompanion(EspeciesModelosCompanion data) {
    return EspecieModelo(
      especieId: data.especieId.present ? data.especieId.value : this.especieId,
      modeloMatematicoId: data.modeloMatematicoId.present
          ? data.modeloMatematicoId.value
          : this.modeloMatematicoId,
      padrao: data.padrao.present ? data.padrao.value : this.padrao,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EspecieModelo(')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('padrao: $padrao, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(especieId, modeloMatematicoId, padrao, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EspecieModelo &&
          other.especieId == this.especieId &&
          other.modeloMatematicoId == this.modeloMatematicoId &&
          other.padrao == this.padrao &&
          other.criadoEm == this.criadoEm);
}

class EspeciesModelosCompanion extends UpdateCompanion<EspecieModelo> {
  final Value<int> especieId;
  final Value<int> modeloMatematicoId;
  final Value<bool> padrao;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const EspeciesModelosCompanion({
    this.especieId = const Value.absent(),
    this.modeloMatematicoId = const Value.absent(),
    this.padrao = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EspeciesModelosCompanion.insert({
    required int especieId,
    required int modeloMatematicoId,
    this.padrao = const Value.absent(),
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  }) : especieId = Value(especieId),
       modeloMatematicoId = Value(modeloMatematicoId),
       criadoEm = Value(criadoEm);
  static Insertable<EspecieModelo> custom({
    Expression<int>? especieId,
    Expression<int>? modeloMatematicoId,
    Expression<bool>? padrao,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (especieId != null) 'especie_id': especieId,
      if (modeloMatematicoId != null)
        'modelo_matematico_id': modeloMatematicoId,
      if (padrao != null) 'padrao': padrao,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EspeciesModelosCompanion copyWith({
    Value<int>? especieId,
    Value<int>? modeloMatematicoId,
    Value<bool>? padrao,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return EspeciesModelosCompanion(
      especieId: especieId ?? this.especieId,
      modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
      padrao: padrao ?? this.padrao,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (especieId.present) {
      map['especie_id'] = Variable<int>(especieId.value);
    }
    if (modeloMatematicoId.present) {
      map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId.value);
    }
    if (padrao.present) {
      map['padrao'] = Variable<bool>(padrao.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EspeciesModelosCompanion(')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('padrao: $padrao, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoeficientesEspecieModeloTable extends CoeficientesEspecieModelo
    with TableInfo<$CoeficientesEspecieModeloTable, CoeficienteEspecieModelo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoeficientesEspecieModeloTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _especieIdMeta = const VerificationMeta(
    'especieId',
  );
  @override
  late final GeneratedColumn<int> especieId = GeneratedColumn<int>(
    'especie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES especies (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _modeloMatematicoIdMeta =
      const VerificationMeta('modeloMatematicoId');
  @override
  late final GeneratedColumn<int> modeloMatematicoId = GeneratedColumn<int>(
    'modelo_matematico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modelos_matematicos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _simboloMeta = const VerificationMeta(
    'simbolo',
  );
  @override
  late final GeneratedColumn<String> simbolo = GeneratedColumn<String>(
    'simbolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotuloMeta = const VerificationMeta('rotulo');
  @override
  late final GeneratedColumn<String> rotulo = GeneratedColumn<String>(
    'rotulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    especieId,
    modeloMatematicoId,
    simbolo,
    rotulo,
    valor,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coeficientes_especie_modelo';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoeficienteEspecieModelo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('especie_id')) {
      context.handle(
        _especieIdMeta,
        especieId.isAcceptableOrUnknown(data['especie_id']!, _especieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_especieIdMeta);
    }
    if (data.containsKey('modelo_matematico_id')) {
      context.handle(
        _modeloMatematicoIdMeta,
        modeloMatematicoId.isAcceptableOrUnknown(
          data['modelo_matematico_id']!,
          _modeloMatematicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modeloMatematicoIdMeta);
    }
    if (data.containsKey('simbolo')) {
      context.handle(
        _simboloMeta,
        simbolo.isAcceptableOrUnknown(data['simbolo']!, _simboloMeta),
      );
    } else if (isInserting) {
      context.missing(_simboloMeta);
    }
    if (data.containsKey('rotulo')) {
      context.handle(
        _rotuloMeta,
        rotulo.isAcceptableOrUnknown(data['rotulo']!, _rotuloMeta),
      );
    } else if (isInserting) {
      context.missing(_rotuloMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoeficienteEspecieModelo map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoeficienteEspecieModelo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      especieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}especie_id'],
      )!,
      modeloMatematicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modelo_matematico_id'],
      )!,
      simbolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simbolo'],
      )!,
      rotulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotulo'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      ),
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $CoeficientesEspecieModeloTable createAlias(String alias) {
    return $CoeficientesEspecieModeloTable(attachedDatabase, alias);
  }
}

class CoeficienteEspecieModelo extends DataClass
    implements Insertable<CoeficienteEspecieModelo> {
  final int id;
  final int especieId;
  final int modeloMatematicoId;
  final String simbolo;
  final String rotulo;
  final double? valor;
  final DateTime atualizadoEm;
  const CoeficienteEspecieModelo({
    required this.id,
    required this.especieId,
    required this.modeloMatematicoId,
    required this.simbolo,
    required this.rotulo,
    this.valor,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['especie_id'] = Variable<int>(especieId);
    map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId);
    map['simbolo'] = Variable<String>(simbolo);
    map['rotulo'] = Variable<String>(rotulo);
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double>(valor);
    }
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  CoeficientesEspecieModeloCompanion toCompanion(bool nullToAbsent) {
    return CoeficientesEspecieModeloCompanion(
      id: Value(id),
      especieId: Value(especieId),
      modeloMatematicoId: Value(modeloMatematicoId),
      simbolo: Value(simbolo),
      rotulo: Value(rotulo),
      valor: valor == null && nullToAbsent
          ? const Value.absent()
          : Value(valor),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory CoeficienteEspecieModelo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoeficienteEspecieModelo(
      id: serializer.fromJson<int>(json['id']),
      especieId: serializer.fromJson<int>(json['especieId']),
      modeloMatematicoId: serializer.fromJson<int>(json['modeloMatematicoId']),
      simbolo: serializer.fromJson<String>(json['simbolo']),
      rotulo: serializer.fromJson<String>(json['rotulo']),
      valor: serializer.fromJson<double?>(json['valor']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'especieId': serializer.toJson<int>(especieId),
      'modeloMatematicoId': serializer.toJson<int>(modeloMatematicoId),
      'simbolo': serializer.toJson<String>(simbolo),
      'rotulo': serializer.toJson<String>(rotulo),
      'valor': serializer.toJson<double?>(valor),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  CoeficienteEspecieModelo copyWith({
    int? id,
    int? especieId,
    int? modeloMatematicoId,
    String? simbolo,
    String? rotulo,
    Value<double?> valor = const Value.absent(),
    DateTime? atualizadoEm,
  }) => CoeficienteEspecieModelo(
    id: id ?? this.id,
    especieId: especieId ?? this.especieId,
    modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
    simbolo: simbolo ?? this.simbolo,
    rotulo: rotulo ?? this.rotulo,
    valor: valor.present ? valor.value : this.valor,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  CoeficienteEspecieModelo copyWithCompanion(
    CoeficientesEspecieModeloCompanion data,
  ) {
    return CoeficienteEspecieModelo(
      id: data.id.present ? data.id.value : this.id,
      especieId: data.especieId.present ? data.especieId.value : this.especieId,
      modeloMatematicoId: data.modeloMatematicoId.present
          ? data.modeloMatematicoId.value
          : this.modeloMatematicoId,
      simbolo: data.simbolo.present ? data.simbolo.value : this.simbolo,
      rotulo: data.rotulo.present ? data.rotulo.value : this.rotulo,
      valor: data.valor.present ? data.valor.value : this.valor,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoeficienteEspecieModelo(')
          ..write('id: $id, ')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    especieId,
    modeloMatematicoId,
    simbolo,
    rotulo,
    valor,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoeficienteEspecieModelo &&
          other.id == this.id &&
          other.especieId == this.especieId &&
          other.modeloMatematicoId == this.modeloMatematicoId &&
          other.simbolo == this.simbolo &&
          other.rotulo == this.rotulo &&
          other.valor == this.valor &&
          other.atualizadoEm == this.atualizadoEm);
}

class CoeficientesEspecieModeloCompanion
    extends UpdateCompanion<CoeficienteEspecieModelo> {
  final Value<int> id;
  final Value<int> especieId;
  final Value<int> modeloMatematicoId;
  final Value<String> simbolo;
  final Value<String> rotulo;
  final Value<double?> valor;
  final Value<DateTime> atualizadoEm;
  const CoeficientesEspecieModeloCompanion({
    this.id = const Value.absent(),
    this.especieId = const Value.absent(),
    this.modeloMatematicoId = const Value.absent(),
    this.simbolo = const Value.absent(),
    this.rotulo = const Value.absent(),
    this.valor = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  CoeficientesEspecieModeloCompanion.insert({
    this.id = const Value.absent(),
    required int especieId,
    required int modeloMatematicoId,
    required String simbolo,
    required String rotulo,
    this.valor = const Value.absent(),
    required DateTime atualizadoEm,
  }) : especieId = Value(especieId),
       modeloMatematicoId = Value(modeloMatematicoId),
       simbolo = Value(simbolo),
       rotulo = Value(rotulo),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<CoeficienteEspecieModelo> custom({
    Expression<int>? id,
    Expression<int>? especieId,
    Expression<int>? modeloMatematicoId,
    Expression<String>? simbolo,
    Expression<String>? rotulo,
    Expression<double>? valor,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (especieId != null) 'especie_id': especieId,
      if (modeloMatematicoId != null)
        'modelo_matematico_id': modeloMatematicoId,
      if (simbolo != null) 'simbolo': simbolo,
      if (rotulo != null) 'rotulo': rotulo,
      if (valor != null) 'valor': valor,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  CoeficientesEspecieModeloCompanion copyWith({
    Value<int>? id,
    Value<int>? especieId,
    Value<int>? modeloMatematicoId,
    Value<String>? simbolo,
    Value<String>? rotulo,
    Value<double?>? valor,
    Value<DateTime>? atualizadoEm,
  }) {
    return CoeficientesEspecieModeloCompanion(
      id: id ?? this.id,
      especieId: especieId ?? this.especieId,
      modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
      simbolo: simbolo ?? this.simbolo,
      rotulo: rotulo ?? this.rotulo,
      valor: valor ?? this.valor,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (especieId.present) {
      map['especie_id'] = Variable<int>(especieId.value);
    }
    if (modeloMatematicoId.present) {
      map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId.value);
    }
    if (simbolo.present) {
      map['simbolo'] = Variable<String>(simbolo.value);
    }
    if (rotulo.present) {
      map['rotulo'] = Variable<String>(rotulo.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoeficientesEspecieModeloCompanion(')
          ..write('id: $id, ')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $TalhoesTable extends Talhoes with TableInfo<$TalhoesTable, Talhao> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalhoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _propriedadeIdMeta = const VerificationMeta(
    'propriedadeId',
  );
  @override
  late final GeneratedColumn<int> propriedadeId = GeneratedColumn<int>(
    'propriedade_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES propriedades (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _identificacaoMeta = const VerificationMeta(
    'identificacao',
  );
  @override
  late final GeneratedColumn<String> identificacao = GeneratedColumn<String>(
    'identificacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _especieIdMeta = const VerificationMeta(
    'especieId',
  );
  @override
  late final GeneratedColumn<int> especieId = GeneratedColumn<int>(
    'especie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES especies (id) ON DELETE RESTRICT',
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
  static const VerificationMeta _anoPlantioMeta = const VerificationMeta(
    'anoPlantio',
  );
  @override
  late final GeneratedColumn<int> anoPlantio = GeneratedColumn<int>(
    'ano_plantio',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _espacamentoMeta = const VerificationMeta(
    'espacamento',
  );
  @override
  late final GeneratedColumn<String> espacamento = GeneratedColumn<String>(
    'espacamento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regimeManejoMeta = const VerificationMeta(
    'regimeManejo',
  );
  @override
  late final GeneratedColumn<String> regimeManejo = GeneratedColumn<String>(
    'regime_manejo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _larguraParcelaMMeta = const VerificationMeta(
    'larguraParcelaM',
  );
  @override
  late final GeneratedColumn<double> larguraParcelaM = GeneratedColumn<double>(
    'largura_parcela_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _comprimentoParcelaMMeta =
      const VerificationMeta('comprimentoParcelaM');
  @override
  late final GeneratedColumn<double> comprimentoParcelaM =
      GeneratedColumn<double>(
        'comprimento_parcela_m',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propriedadeId,
    identificacao,
    especieId,
    areaHa,
    anoPlantio,
    espacamento,
    regimeManejo,
    larguraParcelaM,
    comprimentoParcelaM,
    observacoes,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talhoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Talhao> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('propriedade_id')) {
      context.handle(
        _propriedadeIdMeta,
        propriedadeId.isAcceptableOrUnknown(
          data['propriedade_id']!,
          _propriedadeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propriedadeIdMeta);
    }
    if (data.containsKey('identificacao')) {
      context.handle(
        _identificacaoMeta,
        identificacao.isAcceptableOrUnknown(
          data['identificacao']!,
          _identificacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identificacaoMeta);
    }
    if (data.containsKey('especie_id')) {
      context.handle(
        _especieIdMeta,
        especieId.isAcceptableOrUnknown(data['especie_id']!, _especieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_especieIdMeta);
    }
    if (data.containsKey('area_ha')) {
      context.handle(
        _areaHaMeta,
        areaHa.isAcceptableOrUnknown(data['area_ha']!, _areaHaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaHaMeta);
    }
    if (data.containsKey('ano_plantio')) {
      context.handle(
        _anoPlantioMeta,
        anoPlantio.isAcceptableOrUnknown(data['ano_plantio']!, _anoPlantioMeta),
      );
    }
    if (data.containsKey('espacamento')) {
      context.handle(
        _espacamentoMeta,
        espacamento.isAcceptableOrUnknown(
          data['espacamento']!,
          _espacamentoMeta,
        ),
      );
    }
    if (data.containsKey('regime_manejo')) {
      context.handle(
        _regimeManejoMeta,
        regimeManejo.isAcceptableOrUnknown(
          data['regime_manejo']!,
          _regimeManejoMeta,
        ),
      );
    }
    if (data.containsKey('largura_parcela_m')) {
      context.handle(
        _larguraParcelaMMeta,
        larguraParcelaM.isAcceptableOrUnknown(
          data['largura_parcela_m']!,
          _larguraParcelaMMeta,
        ),
      );
    }
    if (data.containsKey('comprimento_parcela_m')) {
      context.handle(
        _comprimentoParcelaMMeta,
        comprimentoParcelaM.isAcceptableOrUnknown(
          data['comprimento_parcela_m']!,
          _comprimentoParcelaMMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Talhao map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Talhao(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      propriedadeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}propriedade_id'],
      )!,
      identificacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identificacao'],
      )!,
      especieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}especie_id'],
      )!,
      areaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_ha'],
      )!,
      anoPlantio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano_plantio'],
      ),
      espacamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}espacamento'],
      ),
      regimeManejo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regime_manejo'],
      ),
      larguraParcelaM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}largura_parcela_m'],
      ),
      comprimentoParcelaM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}comprimento_parcela_m'],
      ),
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $TalhoesTable createAlias(String alias) {
    return $TalhoesTable(attachedDatabase, alias);
  }
}

class Talhao extends DataClass implements Insertable<Talhao> {
  final int id;
  final int propriedadeId;
  final String identificacao;
  final int especieId;
  final double areaHa;
  final int? anoPlantio;
  final String? espacamento;
  final String? regimeManejo;
  final double? larguraParcelaM;
  final double? comprimentoParcelaM;
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Talhao({
    required this.id,
    required this.propriedadeId,
    required this.identificacao,
    required this.especieId,
    required this.areaHa,
    this.anoPlantio,
    this.espacamento,
    this.regimeManejo,
    this.larguraParcelaM,
    this.comprimentoParcelaM,
    this.observacoes,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['propriedade_id'] = Variable<int>(propriedadeId);
    map['identificacao'] = Variable<String>(identificacao);
    map['especie_id'] = Variable<int>(especieId);
    map['area_ha'] = Variable<double>(areaHa);
    if (!nullToAbsent || anoPlantio != null) {
      map['ano_plantio'] = Variable<int>(anoPlantio);
    }
    if (!nullToAbsent || espacamento != null) {
      map['espacamento'] = Variable<String>(espacamento);
    }
    if (!nullToAbsent || regimeManejo != null) {
      map['regime_manejo'] = Variable<String>(regimeManejo);
    }
    if (!nullToAbsent || larguraParcelaM != null) {
      map['largura_parcela_m'] = Variable<double>(larguraParcelaM);
    }
    if (!nullToAbsent || comprimentoParcelaM != null) {
      map['comprimento_parcela_m'] = Variable<double>(comprimentoParcelaM);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  TalhoesCompanion toCompanion(bool nullToAbsent) {
    return TalhoesCompanion(
      id: Value(id),
      propriedadeId: Value(propriedadeId),
      identificacao: Value(identificacao),
      especieId: Value(especieId),
      areaHa: Value(areaHa),
      anoPlantio: anoPlantio == null && nullToAbsent
          ? const Value.absent()
          : Value(anoPlantio),
      espacamento: espacamento == null && nullToAbsent
          ? const Value.absent()
          : Value(espacamento),
      regimeManejo: regimeManejo == null && nullToAbsent
          ? const Value.absent()
          : Value(regimeManejo),
      larguraParcelaM: larguraParcelaM == null && nullToAbsent
          ? const Value.absent()
          : Value(larguraParcelaM),
      comprimentoParcelaM: comprimentoParcelaM == null && nullToAbsent
          ? const Value.absent()
          : Value(comprimentoParcelaM),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Talhao.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Talhao(
      id: serializer.fromJson<int>(json['id']),
      propriedadeId: serializer.fromJson<int>(json['propriedadeId']),
      identificacao: serializer.fromJson<String>(json['identificacao']),
      especieId: serializer.fromJson<int>(json['especieId']),
      areaHa: serializer.fromJson<double>(json['areaHa']),
      anoPlantio: serializer.fromJson<int?>(json['anoPlantio']),
      espacamento: serializer.fromJson<String?>(json['espacamento']),
      regimeManejo: serializer.fromJson<String?>(json['regimeManejo']),
      larguraParcelaM: serializer.fromJson<double?>(json['larguraParcelaM']),
      comprimentoParcelaM: serializer.fromJson<double?>(
        json['comprimentoParcelaM'],
      ),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'propriedadeId': serializer.toJson<int>(propriedadeId),
      'identificacao': serializer.toJson<String>(identificacao),
      'especieId': serializer.toJson<int>(especieId),
      'areaHa': serializer.toJson<double>(areaHa),
      'anoPlantio': serializer.toJson<int?>(anoPlantio),
      'espacamento': serializer.toJson<String?>(espacamento),
      'regimeManejo': serializer.toJson<String?>(regimeManejo),
      'larguraParcelaM': serializer.toJson<double?>(larguraParcelaM),
      'comprimentoParcelaM': serializer.toJson<double?>(comprimentoParcelaM),
      'observacoes': serializer.toJson<String?>(observacoes),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Talhao copyWith({
    int? id,
    int? propriedadeId,
    String? identificacao,
    int? especieId,
    double? areaHa,
    Value<int?> anoPlantio = const Value.absent(),
    Value<String?> espacamento = const Value.absent(),
    Value<String?> regimeManejo = const Value.absent(),
    Value<double?> larguraParcelaM = const Value.absent(),
    Value<double?> comprimentoParcelaM = const Value.absent(),
    Value<String?> observacoes = const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Talhao(
    id: id ?? this.id,
    propriedadeId: propriedadeId ?? this.propriedadeId,
    identificacao: identificacao ?? this.identificacao,
    especieId: especieId ?? this.especieId,
    areaHa: areaHa ?? this.areaHa,
    anoPlantio: anoPlantio.present ? anoPlantio.value : this.anoPlantio,
    espacamento: espacamento.present ? espacamento.value : this.espacamento,
    regimeManejo: regimeManejo.present ? regimeManejo.value : this.regimeManejo,
    larguraParcelaM: larguraParcelaM.present
        ? larguraParcelaM.value
        : this.larguraParcelaM,
    comprimentoParcelaM: comprimentoParcelaM.present
        ? comprimentoParcelaM.value
        : this.comprimentoParcelaM,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Talhao copyWithCompanion(TalhoesCompanion data) {
    return Talhao(
      id: data.id.present ? data.id.value : this.id,
      propriedadeId: data.propriedadeId.present
          ? data.propriedadeId.value
          : this.propriedadeId,
      identificacao: data.identificacao.present
          ? data.identificacao.value
          : this.identificacao,
      especieId: data.especieId.present ? data.especieId.value : this.especieId,
      areaHa: data.areaHa.present ? data.areaHa.value : this.areaHa,
      anoPlantio: data.anoPlantio.present
          ? data.anoPlantio.value
          : this.anoPlantio,
      espacamento: data.espacamento.present
          ? data.espacamento.value
          : this.espacamento,
      regimeManejo: data.regimeManejo.present
          ? data.regimeManejo.value
          : this.regimeManejo,
      larguraParcelaM: data.larguraParcelaM.present
          ? data.larguraParcelaM.value
          : this.larguraParcelaM,
      comprimentoParcelaM: data.comprimentoParcelaM.present
          ? data.comprimentoParcelaM.value
          : this.comprimentoParcelaM,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Talhao(')
          ..write('id: $id, ')
          ..write('propriedadeId: $propriedadeId, ')
          ..write('identificacao: $identificacao, ')
          ..write('especieId: $especieId, ')
          ..write('areaHa: $areaHa, ')
          ..write('anoPlantio: $anoPlantio, ')
          ..write('espacamento: $espacamento, ')
          ..write('regimeManejo: $regimeManejo, ')
          ..write('larguraParcelaM: $larguraParcelaM, ')
          ..write('comprimentoParcelaM: $comprimentoParcelaM, ')
          ..write('observacoes: $observacoes, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propriedadeId,
    identificacao,
    especieId,
    areaHa,
    anoPlantio,
    espacamento,
    regimeManejo,
    larguraParcelaM,
    comprimentoParcelaM,
    observacoes,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Talhao &&
          other.id == this.id &&
          other.propriedadeId == this.propriedadeId &&
          other.identificacao == this.identificacao &&
          other.especieId == this.especieId &&
          other.areaHa == this.areaHa &&
          other.anoPlantio == this.anoPlantio &&
          other.espacamento == this.espacamento &&
          other.regimeManejo == this.regimeManejo &&
          other.larguraParcelaM == this.larguraParcelaM &&
          other.comprimentoParcelaM == this.comprimentoParcelaM &&
          other.observacoes == this.observacoes &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class TalhoesCompanion extends UpdateCompanion<Talhao> {
  final Value<int> id;
  final Value<int> propriedadeId;
  final Value<String> identificacao;
  final Value<int> especieId;
  final Value<double> areaHa;
  final Value<int?> anoPlantio;
  final Value<String?> espacamento;
  final Value<String?> regimeManejo;
  final Value<double?> larguraParcelaM;
  final Value<double?> comprimentoParcelaM;
  final Value<String?> observacoes;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const TalhoesCompanion({
    this.id = const Value.absent(),
    this.propriedadeId = const Value.absent(),
    this.identificacao = const Value.absent(),
    this.especieId = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.anoPlantio = const Value.absent(),
    this.espacamento = const Value.absent(),
    this.regimeManejo = const Value.absent(),
    this.larguraParcelaM = const Value.absent(),
    this.comprimentoParcelaM = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  TalhoesCompanion.insert({
    this.id = const Value.absent(),
    required int propriedadeId,
    required String identificacao,
    required int especieId,
    required double areaHa,
    this.anoPlantio = const Value.absent(),
    this.espacamento = const Value.absent(),
    this.regimeManejo = const Value.absent(),
    this.larguraParcelaM = const Value.absent(),
    this.comprimentoParcelaM = const Value.absent(),
    this.observacoes = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : propriedadeId = Value(propriedadeId),
       identificacao = Value(identificacao),
       especieId = Value(especieId),
       areaHa = Value(areaHa),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Talhao> custom({
    Expression<int>? id,
    Expression<int>? propriedadeId,
    Expression<String>? identificacao,
    Expression<int>? especieId,
    Expression<double>? areaHa,
    Expression<int>? anoPlantio,
    Expression<String>? espacamento,
    Expression<String>? regimeManejo,
    Expression<double>? larguraParcelaM,
    Expression<double>? comprimentoParcelaM,
    Expression<String>? observacoes,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propriedadeId != null) 'propriedade_id': propriedadeId,
      if (identificacao != null) 'identificacao': identificacao,
      if (especieId != null) 'especie_id': especieId,
      if (areaHa != null) 'area_ha': areaHa,
      if (anoPlantio != null) 'ano_plantio': anoPlantio,
      if (espacamento != null) 'espacamento': espacamento,
      if (regimeManejo != null) 'regime_manejo': regimeManejo,
      if (larguraParcelaM != null) 'largura_parcela_m': larguraParcelaM,
      if (comprimentoParcelaM != null)
        'comprimento_parcela_m': comprimentoParcelaM,
      if (observacoes != null) 'observacoes': observacoes,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  TalhoesCompanion copyWith({
    Value<int>? id,
    Value<int>? propriedadeId,
    Value<String>? identificacao,
    Value<int>? especieId,
    Value<double>? areaHa,
    Value<int?>? anoPlantio,
    Value<String?>? espacamento,
    Value<String?>? regimeManejo,
    Value<double?>? larguraParcelaM,
    Value<double?>? comprimentoParcelaM,
    Value<String?>? observacoes,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return TalhoesCompanion(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      identificacao: identificacao ?? this.identificacao,
      especieId: especieId ?? this.especieId,
      areaHa: areaHa ?? this.areaHa,
      anoPlantio: anoPlantio ?? this.anoPlantio,
      espacamento: espacamento ?? this.espacamento,
      regimeManejo: regimeManejo ?? this.regimeManejo,
      larguraParcelaM: larguraParcelaM ?? this.larguraParcelaM,
      comprimentoParcelaM: comprimentoParcelaM ?? this.comprimentoParcelaM,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (propriedadeId.present) {
      map['propriedade_id'] = Variable<int>(propriedadeId.value);
    }
    if (identificacao.present) {
      map['identificacao'] = Variable<String>(identificacao.value);
    }
    if (especieId.present) {
      map['especie_id'] = Variable<int>(especieId.value);
    }
    if (areaHa.present) {
      map['area_ha'] = Variable<double>(areaHa.value);
    }
    if (anoPlantio.present) {
      map['ano_plantio'] = Variable<int>(anoPlantio.value);
    }
    if (espacamento.present) {
      map['espacamento'] = Variable<String>(espacamento.value);
    }
    if (regimeManejo.present) {
      map['regime_manejo'] = Variable<String>(regimeManejo.value);
    }
    if (larguraParcelaM.present) {
      map['largura_parcela_m'] = Variable<double>(larguraParcelaM.value);
    }
    if (comprimentoParcelaM.present) {
      map['comprimento_parcela_m'] = Variable<double>(
        comprimentoParcelaM.value,
      );
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalhoesCompanion(')
          ..write('id: $id, ')
          ..write('propriedadeId: $propriedadeId, ')
          ..write('identificacao: $identificacao, ')
          ..write('especieId: $especieId, ')
          ..write('areaHa: $areaHa, ')
          ..write('anoPlantio: $anoPlantio, ')
          ..write('espacamento: $espacamento, ')
          ..write('regimeManejo: $regimeManejo, ')
          ..write('larguraParcelaM: $larguraParcelaM, ')
          ..write('comprimentoParcelaM: $comprimentoParcelaM, ')
          ..write('observacoes: $observacoes, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $LevantamentosTable extends Levantamentos
    with TableInfo<$LevantamentosTable, Levantamento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevantamentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _propriedadeIdMeta = const VerificationMeta(
    'propriedadeId',
  );
  @override
  late final GeneratedColumn<int> propriedadeId = GeneratedColumn<int>(
    'propriedade_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES propriedades (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SituacaoLevantamento, String>
  situacao = GeneratedColumn<String>(
    'situacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SituacaoLevantamento>($LevantamentosTable.$convertersituacao);
  static const VerificationMeta _iniciadoEmMeta = const VerificationMeta(
    'iniciadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> iniciadoEm = GeneratedColumn<DateTime>(
    'iniciado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _concluidoEmMeta = const VerificationMeta(
    'concluidoEm',
  );
  @override
  late final GeneratedColumn<DateTime> concluidoEm = GeneratedColumn<DateTime>(
    'concluido_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propriedadeId,
    situacao,
    iniciadoEm,
    atualizadoEm,
    concluidoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'levantamentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Levantamento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('propriedade_id')) {
      context.handle(
        _propriedadeIdMeta,
        propriedadeId.isAcceptableOrUnknown(
          data['propriedade_id']!,
          _propriedadeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propriedadeIdMeta);
    }
    if (data.containsKey('iniciado_em')) {
      context.handle(
        _iniciadoEmMeta,
        iniciadoEm.isAcceptableOrUnknown(data['iniciado_em']!, _iniciadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_iniciadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    if (data.containsKey('concluido_em')) {
      context.handle(
        _concluidoEmMeta,
        concluidoEm.isAcceptableOrUnknown(
          data['concluido_em']!,
          _concluidoEmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Levantamento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Levantamento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      propriedadeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}propriedade_id'],
      )!,
      situacao: $LevantamentosTable.$convertersituacao.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}situacao'],
        )!,
      ),
      iniciadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}iniciado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
      concluidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}concluido_em'],
      ),
    );
  }

  @override
  $LevantamentosTable createAlias(String alias) {
    return $LevantamentosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SituacaoLevantamento, String, String>
  $convertersituacao = const EnumNameConverter<SituacaoLevantamento>(
    SituacaoLevantamento.values,
  );
}

class Levantamento extends DataClass implements Insertable<Levantamento> {
  final int id;
  final int propriedadeId;
  final SituacaoLevantamento situacao;
  final DateTime iniciadoEm;
  final DateTime atualizadoEm;
  final DateTime? concluidoEm;
  const Levantamento({
    required this.id,
    required this.propriedadeId,
    required this.situacao,
    required this.iniciadoEm,
    required this.atualizadoEm,
    this.concluidoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['propriedade_id'] = Variable<int>(propriedadeId);
    {
      map['situacao'] = Variable<String>(
        $LevantamentosTable.$convertersituacao.toSql(situacao),
      );
    }
    map['iniciado_em'] = Variable<DateTime>(iniciadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || concluidoEm != null) {
      map['concluido_em'] = Variable<DateTime>(concluidoEm);
    }
    return map;
  }

  LevantamentosCompanion toCompanion(bool nullToAbsent) {
    return LevantamentosCompanion(
      id: Value(id),
      propriedadeId: Value(propriedadeId),
      situacao: Value(situacao),
      iniciadoEm: Value(iniciadoEm),
      atualizadoEm: Value(atualizadoEm),
      concluidoEm: concluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(concluidoEm),
    );
  }

  factory Levantamento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Levantamento(
      id: serializer.fromJson<int>(json['id']),
      propriedadeId: serializer.fromJson<int>(json['propriedadeId']),
      situacao: $LevantamentosTable.$convertersituacao.fromJson(
        serializer.fromJson<String>(json['situacao']),
      ),
      iniciadoEm: serializer.fromJson<DateTime>(json['iniciadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      concluidoEm: serializer.fromJson<DateTime?>(json['concluidoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'propriedadeId': serializer.toJson<int>(propriedadeId),
      'situacao': serializer.toJson<String>(
        $LevantamentosTable.$convertersituacao.toJson(situacao),
      ),
      'iniciadoEm': serializer.toJson<DateTime>(iniciadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'concluidoEm': serializer.toJson<DateTime?>(concluidoEm),
    };
  }

  Levantamento copyWith({
    int? id,
    int? propriedadeId,
    SituacaoLevantamento? situacao,
    DateTime? iniciadoEm,
    DateTime? atualizadoEm,
    Value<DateTime?> concluidoEm = const Value.absent(),
  }) => Levantamento(
    id: id ?? this.id,
    propriedadeId: propriedadeId ?? this.propriedadeId,
    situacao: situacao ?? this.situacao,
    iniciadoEm: iniciadoEm ?? this.iniciadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    concluidoEm: concluidoEm.present ? concluidoEm.value : this.concluidoEm,
  );
  Levantamento copyWithCompanion(LevantamentosCompanion data) {
    return Levantamento(
      id: data.id.present ? data.id.value : this.id,
      propriedadeId: data.propriedadeId.present
          ? data.propriedadeId.value
          : this.propriedadeId,
      situacao: data.situacao.present ? data.situacao.value : this.situacao,
      iniciadoEm: data.iniciadoEm.present
          ? data.iniciadoEm.value
          : this.iniciadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      concluidoEm: data.concluidoEm.present
          ? data.concluidoEm.value
          : this.concluidoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Levantamento(')
          ..write('id: $id, ')
          ..write('propriedadeId: $propriedadeId, ')
          ..write('situacao: $situacao, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('concluidoEm: $concluidoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propriedadeId,
    situacao,
    iniciadoEm,
    atualizadoEm,
    concluidoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Levantamento &&
          other.id == this.id &&
          other.propriedadeId == this.propriedadeId &&
          other.situacao == this.situacao &&
          other.iniciadoEm == this.iniciadoEm &&
          other.atualizadoEm == this.atualizadoEm &&
          other.concluidoEm == this.concluidoEm);
}

class LevantamentosCompanion extends UpdateCompanion<Levantamento> {
  final Value<int> id;
  final Value<int> propriedadeId;
  final Value<SituacaoLevantamento> situacao;
  final Value<DateTime> iniciadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> concluidoEm;
  const LevantamentosCompanion({
    this.id = const Value.absent(),
    this.propriedadeId = const Value.absent(),
    this.situacao = const Value.absent(),
    this.iniciadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.concluidoEm = const Value.absent(),
  });
  LevantamentosCompanion.insert({
    this.id = const Value.absent(),
    required int propriedadeId,
    required SituacaoLevantamento situacao,
    required DateTime iniciadoEm,
    required DateTime atualizadoEm,
    this.concluidoEm = const Value.absent(),
  }) : propriedadeId = Value(propriedadeId),
       situacao = Value(situacao),
       iniciadoEm = Value(iniciadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Levantamento> custom({
    Expression<int>? id,
    Expression<int>? propriedadeId,
    Expression<String>? situacao,
    Expression<DateTime>? iniciadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? concluidoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propriedadeId != null) 'propriedade_id': propriedadeId,
      if (situacao != null) 'situacao': situacao,
      if (iniciadoEm != null) 'iniciado_em': iniciadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (concluidoEm != null) 'concluido_em': concluidoEm,
    });
  }

  LevantamentosCompanion copyWith({
    Value<int>? id,
    Value<int>? propriedadeId,
    Value<SituacaoLevantamento>? situacao,
    Value<DateTime>? iniciadoEm,
    Value<DateTime>? atualizadoEm,
    Value<DateTime?>? concluidoEm,
  }) {
    return LevantamentosCompanion(
      id: id ?? this.id,
      propriedadeId: propriedadeId ?? this.propriedadeId,
      situacao: situacao ?? this.situacao,
      iniciadoEm: iniciadoEm ?? this.iniciadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      concluidoEm: concluidoEm ?? this.concluidoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (propriedadeId.present) {
      map['propriedade_id'] = Variable<int>(propriedadeId.value);
    }
    if (situacao.present) {
      map['situacao'] = Variable<String>(
        $LevantamentosTable.$convertersituacao.toSql(situacao.value),
      );
    }
    if (iniciadoEm.present) {
      map['iniciado_em'] = Variable<DateTime>(iniciadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (concluidoEm.present) {
      map['concluido_em'] = Variable<DateTime>(concluidoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevantamentosCompanion(')
          ..write('id: $id, ')
          ..write('propriedadeId: $propriedadeId, ')
          ..write('situacao: $situacao, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('concluidoEm: $concluidoEm')
          ..write(')'))
        .toString();
  }
}

class $TalhaoLevantamentosTable extends TalhaoLevantamentos
    with TableInfo<$TalhaoLevantamentosTable, TalhaoLevantamento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalhaoLevantamentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levantamentoIdMeta = const VerificationMeta(
    'levantamentoId',
  );
  @override
  late final GeneratedColumn<int> levantamentoId = GeneratedColumn<int>(
    'levantamento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES levantamentos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _talhaoIdMeta = const VerificationMeta(
    'talhaoId',
  );
  @override
  late final GeneratedColumn<int> talhaoId = GeneratedColumn<int>(
    'talhao_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES talhoes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _especieIdMeta = const VerificationMeta(
    'especieId',
  );
  @override
  late final GeneratedColumn<int> especieId = GeneratedColumn<int>(
    'especie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES especies (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _modeloMatematicoIdMeta =
      const VerificationMeta('modeloMatematicoId');
  @override
  late final GeneratedColumn<int> modeloMatematicoId = GeneratedColumn<int>(
    'modelo_matematico_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES modelos_matematicos (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _areaPadraoParcelaHaMeta =
      const VerificationMeta('areaPadraoParcelaHa');
  @override
  late final GeneratedColumn<double> areaPadraoParcelaHa =
      GeneratedColumn<double>(
        'area_padrao_parcela_ha',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    levantamentoId,
    talhaoId,
    especieId,
    modeloMatematicoId,
    areaPadraoParcelaHa,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talhao_levantamentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<TalhaoLevantamento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('levantamento_id')) {
      context.handle(
        _levantamentoIdMeta,
        levantamentoId.isAcceptableOrUnknown(
          data['levantamento_id']!,
          _levantamentoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levantamentoIdMeta);
    }
    if (data.containsKey('talhao_id')) {
      context.handle(
        _talhaoIdMeta,
        talhaoId.isAcceptableOrUnknown(data['talhao_id']!, _talhaoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_talhaoIdMeta);
    }
    if (data.containsKey('especie_id')) {
      context.handle(
        _especieIdMeta,
        especieId.isAcceptableOrUnknown(data['especie_id']!, _especieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_especieIdMeta);
    }
    if (data.containsKey('modelo_matematico_id')) {
      context.handle(
        _modeloMatematicoIdMeta,
        modeloMatematicoId.isAcceptableOrUnknown(
          data['modelo_matematico_id']!,
          _modeloMatematicoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modeloMatematicoIdMeta);
    }
    if (data.containsKey('area_padrao_parcela_ha')) {
      context.handle(
        _areaPadraoParcelaHaMeta,
        areaPadraoParcelaHa.isAcceptableOrUnknown(
          data['area_padrao_parcela_ha']!,
          _areaPadraoParcelaHaMeta,
        ),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TalhaoLevantamento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TalhaoLevantamento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      levantamentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}levantamento_id'],
      )!,
      talhaoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}talhao_id'],
      )!,
      especieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}especie_id'],
      )!,
      modeloMatematicoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modelo_matematico_id'],
      )!,
      areaPadraoParcelaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_padrao_parcela_ha'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $TalhaoLevantamentosTable createAlias(String alias) {
    return $TalhaoLevantamentosTable(attachedDatabase, alias);
  }
}

class TalhaoLevantamento extends DataClass
    implements Insertable<TalhaoLevantamento> {
  final int id;
  final int levantamentoId;
  final int talhaoId;
  final int especieId;
  final int modeloMatematicoId;
  final double? areaPadraoParcelaHa;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const TalhaoLevantamento({
    required this.id,
    required this.levantamentoId,
    required this.talhaoId,
    required this.especieId,
    required this.modeloMatematicoId,
    this.areaPadraoParcelaHa,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['levantamento_id'] = Variable<int>(levantamentoId);
    map['talhao_id'] = Variable<int>(talhaoId);
    map['especie_id'] = Variable<int>(especieId);
    map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId);
    if (!nullToAbsent || areaPadraoParcelaHa != null) {
      map['area_padrao_parcela_ha'] = Variable<double>(areaPadraoParcelaHa);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  TalhaoLevantamentosCompanion toCompanion(bool nullToAbsent) {
    return TalhaoLevantamentosCompanion(
      id: Value(id),
      levantamentoId: Value(levantamentoId),
      talhaoId: Value(talhaoId),
      especieId: Value(especieId),
      modeloMatematicoId: Value(modeloMatematicoId),
      areaPadraoParcelaHa: areaPadraoParcelaHa == null && nullToAbsent
          ? const Value.absent()
          : Value(areaPadraoParcelaHa),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory TalhaoLevantamento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TalhaoLevantamento(
      id: serializer.fromJson<int>(json['id']),
      levantamentoId: serializer.fromJson<int>(json['levantamentoId']),
      talhaoId: serializer.fromJson<int>(json['talhaoId']),
      especieId: serializer.fromJson<int>(json['especieId']),
      modeloMatematicoId: serializer.fromJson<int>(json['modeloMatematicoId']),
      areaPadraoParcelaHa: serializer.fromJson<double?>(
        json['areaPadraoParcelaHa'],
      ),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'levantamentoId': serializer.toJson<int>(levantamentoId),
      'talhaoId': serializer.toJson<int>(talhaoId),
      'especieId': serializer.toJson<int>(especieId),
      'modeloMatematicoId': serializer.toJson<int>(modeloMatematicoId),
      'areaPadraoParcelaHa': serializer.toJson<double?>(areaPadraoParcelaHa),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  TalhaoLevantamento copyWith({
    int? id,
    int? levantamentoId,
    int? talhaoId,
    int? especieId,
    int? modeloMatematicoId,
    Value<double?> areaPadraoParcelaHa = const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => TalhaoLevantamento(
    id: id ?? this.id,
    levantamentoId: levantamentoId ?? this.levantamentoId,
    talhaoId: talhaoId ?? this.talhaoId,
    especieId: especieId ?? this.especieId,
    modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
    areaPadraoParcelaHa: areaPadraoParcelaHa.present
        ? areaPadraoParcelaHa.value
        : this.areaPadraoParcelaHa,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  TalhaoLevantamento copyWithCompanion(TalhaoLevantamentosCompanion data) {
    return TalhaoLevantamento(
      id: data.id.present ? data.id.value : this.id,
      levantamentoId: data.levantamentoId.present
          ? data.levantamentoId.value
          : this.levantamentoId,
      talhaoId: data.talhaoId.present ? data.talhaoId.value : this.talhaoId,
      especieId: data.especieId.present ? data.especieId.value : this.especieId,
      modeloMatematicoId: data.modeloMatematicoId.present
          ? data.modeloMatematicoId.value
          : this.modeloMatematicoId,
      areaPadraoParcelaHa: data.areaPadraoParcelaHa.present
          ? data.areaPadraoParcelaHa.value
          : this.areaPadraoParcelaHa,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TalhaoLevantamento(')
          ..write('id: $id, ')
          ..write('levantamentoId: $levantamentoId, ')
          ..write('talhaoId: $talhaoId, ')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('areaPadraoParcelaHa: $areaPadraoParcelaHa, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    levantamentoId,
    talhaoId,
    especieId,
    modeloMatematicoId,
    areaPadraoParcelaHa,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TalhaoLevantamento &&
          other.id == this.id &&
          other.levantamentoId == this.levantamentoId &&
          other.talhaoId == this.talhaoId &&
          other.especieId == this.especieId &&
          other.modeloMatematicoId == this.modeloMatematicoId &&
          other.areaPadraoParcelaHa == this.areaPadraoParcelaHa &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class TalhaoLevantamentosCompanion extends UpdateCompanion<TalhaoLevantamento> {
  final Value<int> id;
  final Value<int> levantamentoId;
  final Value<int> talhaoId;
  final Value<int> especieId;
  final Value<int> modeloMatematicoId;
  final Value<double?> areaPadraoParcelaHa;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const TalhaoLevantamentosCompanion({
    this.id = const Value.absent(),
    this.levantamentoId = const Value.absent(),
    this.talhaoId = const Value.absent(),
    this.especieId = const Value.absent(),
    this.modeloMatematicoId = const Value.absent(),
    this.areaPadraoParcelaHa = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  TalhaoLevantamentosCompanion.insert({
    this.id = const Value.absent(),
    required int levantamentoId,
    required int talhaoId,
    required int especieId,
    required int modeloMatematicoId,
    this.areaPadraoParcelaHa = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : levantamentoId = Value(levantamentoId),
       talhaoId = Value(talhaoId),
       especieId = Value(especieId),
       modeloMatematicoId = Value(modeloMatematicoId),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<TalhaoLevantamento> custom({
    Expression<int>? id,
    Expression<int>? levantamentoId,
    Expression<int>? talhaoId,
    Expression<int>? especieId,
    Expression<int>? modeloMatematicoId,
    Expression<double>? areaPadraoParcelaHa,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levantamentoId != null) 'levantamento_id': levantamentoId,
      if (talhaoId != null) 'talhao_id': talhaoId,
      if (especieId != null) 'especie_id': especieId,
      if (modeloMatematicoId != null)
        'modelo_matematico_id': modeloMatematicoId,
      if (areaPadraoParcelaHa != null)
        'area_padrao_parcela_ha': areaPadraoParcelaHa,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  TalhaoLevantamentosCompanion copyWith({
    Value<int>? id,
    Value<int>? levantamentoId,
    Value<int>? talhaoId,
    Value<int>? especieId,
    Value<int>? modeloMatematicoId,
    Value<double?>? areaPadraoParcelaHa,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return TalhaoLevantamentosCompanion(
      id: id ?? this.id,
      levantamentoId: levantamentoId ?? this.levantamentoId,
      talhaoId: talhaoId ?? this.talhaoId,
      especieId: especieId ?? this.especieId,
      modeloMatematicoId: modeloMatematicoId ?? this.modeloMatematicoId,
      areaPadraoParcelaHa: areaPadraoParcelaHa ?? this.areaPadraoParcelaHa,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (levantamentoId.present) {
      map['levantamento_id'] = Variable<int>(levantamentoId.value);
    }
    if (talhaoId.present) {
      map['talhao_id'] = Variable<int>(talhaoId.value);
    }
    if (especieId.present) {
      map['especie_id'] = Variable<int>(especieId.value);
    }
    if (modeloMatematicoId.present) {
      map['modelo_matematico_id'] = Variable<int>(modeloMatematicoId.value);
    }
    if (areaPadraoParcelaHa.present) {
      map['area_padrao_parcela_ha'] = Variable<double>(
        areaPadraoParcelaHa.value,
      );
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalhaoLevantamentosCompanion(')
          ..write('id: $id, ')
          ..write('levantamentoId: $levantamentoId, ')
          ..write('talhaoId: $talhaoId, ')
          ..write('especieId: $especieId, ')
          ..write('modeloMatematicoId: $modeloMatematicoId, ')
          ..write('areaPadraoParcelaHa: $areaPadraoParcelaHa, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $CoeficientesTalhaoLevantamentoTable
    extends CoeficientesTalhaoLevantamento
    with
        TableInfo<
          $CoeficientesTalhaoLevantamentoTable,
          CoeficienteTalhaoLevantamento
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoeficientesTalhaoLevantamentoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _talhaoLevantamentoIdMeta =
      const VerificationMeta('talhaoLevantamentoId');
  @override
  late final GeneratedColumn<int> talhaoLevantamentoId = GeneratedColumn<int>(
    'talhao_levantamento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES talhao_levantamentos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _simboloMeta = const VerificationMeta(
    'simbolo',
  );
  @override
  late final GeneratedColumn<String> simbolo = GeneratedColumn<String>(
    'simbolo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rotuloMeta = const VerificationMeta('rotulo');
  @override
  late final GeneratedColumn<String> rotulo = GeneratedColumn<String>(
    'rotulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    talhaoLevantamentoId,
    simbolo,
    rotulo,
    valor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coeficientes_talhao_levantamento';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoeficienteTalhaoLevantamento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('simbolo')) {
      context.handle(
        _simboloMeta,
        simbolo.isAcceptableOrUnknown(data['simbolo']!, _simboloMeta),
      );
    } else if (isInserting) {
      context.missing(_simboloMeta);
    }
    if (data.containsKey('rotulo')) {
      context.handle(
        _rotuloMeta,
        rotulo.isAcceptableOrUnknown(data['rotulo']!, _rotuloMeta),
      );
    } else if (isInserting) {
      context.missing(_rotuloMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoeficienteTalhaoLevantamento map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoeficienteTalhaoLevantamento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      talhaoLevantamentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}talhao_levantamento_id'],
      )!,
      simbolo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simbolo'],
      )!,
      rotulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rotulo'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      ),
    );
  }

  @override
  $CoeficientesTalhaoLevantamentoTable createAlias(String alias) {
    return $CoeficientesTalhaoLevantamentoTable(attachedDatabase, alias);
  }
}

class CoeficienteTalhaoLevantamento extends DataClass
    implements Insertable<CoeficienteTalhaoLevantamento> {
  final int id;
  final int talhaoLevantamentoId;
  final String simbolo;
  final String rotulo;
  final double? valor;
  const CoeficienteTalhaoLevantamento({
    required this.id,
    required this.talhaoLevantamentoId,
    required this.simbolo,
    required this.rotulo,
    this.valor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['talhao_levantamento_id'] = Variable<int>(talhaoLevantamentoId);
    map['simbolo'] = Variable<String>(simbolo);
    map['rotulo'] = Variable<String>(rotulo);
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double>(valor);
    }
    return map;
  }

  CoeficientesTalhaoLevantamentoCompanion toCompanion(bool nullToAbsent) {
    return CoeficientesTalhaoLevantamentoCompanion(
      id: Value(id),
      talhaoLevantamentoId: Value(talhaoLevantamentoId),
      simbolo: Value(simbolo),
      rotulo: Value(rotulo),
      valor: valor == null && nullToAbsent
          ? const Value.absent()
          : Value(valor),
    );
  }

  factory CoeficienteTalhaoLevantamento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoeficienteTalhaoLevantamento(
      id: serializer.fromJson<int>(json['id']),
      talhaoLevantamentoId: serializer.fromJson<int>(
        json['talhaoLevantamentoId'],
      ),
      simbolo: serializer.fromJson<String>(json['simbolo']),
      rotulo: serializer.fromJson<String>(json['rotulo']),
      valor: serializer.fromJson<double?>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'talhaoLevantamentoId': serializer.toJson<int>(talhaoLevantamentoId),
      'simbolo': serializer.toJson<String>(simbolo),
      'rotulo': serializer.toJson<String>(rotulo),
      'valor': serializer.toJson<double?>(valor),
    };
  }

  CoeficienteTalhaoLevantamento copyWith({
    int? id,
    int? talhaoLevantamentoId,
    String? simbolo,
    String? rotulo,
    Value<double?> valor = const Value.absent(),
  }) => CoeficienteTalhaoLevantamento(
    id: id ?? this.id,
    talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
    simbolo: simbolo ?? this.simbolo,
    rotulo: rotulo ?? this.rotulo,
    valor: valor.present ? valor.value : this.valor,
  );
  CoeficienteTalhaoLevantamento copyWithCompanion(
    CoeficientesTalhaoLevantamentoCompanion data,
  ) {
    return CoeficienteTalhaoLevantamento(
      id: data.id.present ? data.id.value : this.id,
      talhaoLevantamentoId: data.talhaoLevantamentoId.present
          ? data.talhaoLevantamentoId.value
          : this.talhaoLevantamentoId,
      simbolo: data.simbolo.present ? data.simbolo.value : this.simbolo,
      rotulo: data.rotulo.present ? data.rotulo.value : this.rotulo,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoeficienteTalhaoLevantamento(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, talhaoLevantamentoId, simbolo, rotulo, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoeficienteTalhaoLevantamento &&
          other.id == this.id &&
          other.talhaoLevantamentoId == this.talhaoLevantamentoId &&
          other.simbolo == this.simbolo &&
          other.rotulo == this.rotulo &&
          other.valor == this.valor);
}

class CoeficientesTalhaoLevantamentoCompanion
    extends UpdateCompanion<CoeficienteTalhaoLevantamento> {
  final Value<int> id;
  final Value<int> talhaoLevantamentoId;
  final Value<String> simbolo;
  final Value<String> rotulo;
  final Value<double?> valor;
  const CoeficientesTalhaoLevantamentoCompanion({
    this.id = const Value.absent(),
    this.talhaoLevantamentoId = const Value.absent(),
    this.simbolo = const Value.absent(),
    this.rotulo = const Value.absent(),
    this.valor = const Value.absent(),
  });
  CoeficientesTalhaoLevantamentoCompanion.insert({
    this.id = const Value.absent(),
    required int talhaoLevantamentoId,
    required String simbolo,
    required String rotulo,
    this.valor = const Value.absent(),
  }) : talhaoLevantamentoId = Value(talhaoLevantamentoId),
       simbolo = Value(simbolo),
       rotulo = Value(rotulo);
  static Insertable<CoeficienteTalhaoLevantamento> custom({
    Expression<int>? id,
    Expression<int>? talhaoLevantamentoId,
    Expression<String>? simbolo,
    Expression<String>? rotulo,
    Expression<double>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (talhaoLevantamentoId != null)
        'talhao_levantamento_id': talhaoLevantamentoId,
      if (simbolo != null) 'simbolo': simbolo,
      if (rotulo != null) 'rotulo': rotulo,
      if (valor != null) 'valor': valor,
    });
  }

  CoeficientesTalhaoLevantamentoCompanion copyWith({
    Value<int>? id,
    Value<int>? talhaoLevantamentoId,
    Value<String>? simbolo,
    Value<String>? rotulo,
    Value<double?>? valor,
  }) {
    return CoeficientesTalhaoLevantamentoCompanion(
      id: id ?? this.id,
      talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
      simbolo: simbolo ?? this.simbolo,
      rotulo: rotulo ?? this.rotulo,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (talhaoLevantamentoId.present) {
      map['talhao_levantamento_id'] = Variable<int>(talhaoLevantamentoId.value);
    }
    if (simbolo.present) {
      map['simbolo'] = Variable<String>(simbolo.value);
    }
    if (rotulo.present) {
      map['rotulo'] = Variable<String>(rotulo.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoeficientesTalhaoLevantamentoCompanion(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('simbolo: $simbolo, ')
          ..write('rotulo: $rotulo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

class $ParcelasTable extends Parcelas with TableInfo<$ParcelasTable, Parcela> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParcelasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _talhaoLevantamentoIdMeta =
      const VerificationMeta('talhaoLevantamentoId');
  @override
  late final GeneratedColumn<int> talhaoLevantamentoId = GeneratedColumn<int>(
    'talhao_levantamento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES talhao_levantamentos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _identificacaoMeta = const VerificationMeta(
    'identificacao',
  );
  @override
  late final GeneratedColumn<String> identificacao = GeneratedColumn<String>(
    'identificacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SituacaoParcela, String>
  situacao = GeneratedColumn<String>(
    'situacao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SituacaoParcela>($ParcelasTable.$convertersituacao);
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
  late final GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  posicaoReferencia =
      GeneratedColumn<String>(
        'posicao_referencia',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PosicaoReferenciaParcela?>(
        $ParcelasTable.$converterposicaoReferencian,
      );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    talhaoLevantamentoId,
    identificacao,
    situacao,
    areaHa,
    posicaoReferencia,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parcelas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Parcela> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('identificacao')) {
      context.handle(
        _identificacaoMeta,
        identificacao.isAcceptableOrUnknown(
          data['identificacao']!,
          _identificacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identificacaoMeta);
    }
    if (data.containsKey('area_ha')) {
      context.handle(
        _areaHaMeta,
        areaHa.isAcceptableOrUnknown(data['area_ha']!, _areaHaMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Parcela map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Parcela(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      talhaoLevantamentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}talhao_levantamento_id'],
      )!,
      identificacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identificacao'],
      )!,
      situacao: $ParcelasTable.$convertersituacao.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}situacao'],
        )!,
      ),
      areaHa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_ha'],
      ),
      posicaoReferencia: $ParcelasTable.$converterposicaoReferencian.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}posicao_referencia'],
        ),
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $ParcelasTable createAlias(String alias) {
    return $ParcelasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SituacaoParcela, String, String>
  $convertersituacao = const EnumNameConverter<SituacaoParcela>(
    SituacaoParcela.values,
  );
  static JsonTypeConverter2<PosicaoReferenciaParcela, String, String>
  $converterposicaoReferencia =
      const EnumNameConverter<PosicaoReferenciaParcela>(
        PosicaoReferenciaParcela.values,
      );
  static JsonTypeConverter2<PosicaoReferenciaParcela?, String?, String?>
  $converterposicaoReferencian = JsonTypeConverter2.asNullable(
    $converterposicaoReferencia,
  );
}

class Parcela extends DataClass implements Insertable<Parcela> {
  final int id;
  final int talhaoLevantamentoId;
  final String identificacao;
  final SituacaoParcela situacao;
  final double? areaHa;
  final PosicaoReferenciaParcela? posicaoReferencia;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Parcela({
    required this.id,
    required this.talhaoLevantamentoId,
    required this.identificacao,
    required this.situacao,
    this.areaHa,
    this.posicaoReferencia,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['talhao_levantamento_id'] = Variable<int>(talhaoLevantamentoId);
    map['identificacao'] = Variable<String>(identificacao);
    {
      map['situacao'] = Variable<String>(
        $ParcelasTable.$convertersituacao.toSql(situacao),
      );
    }
    if (!nullToAbsent || areaHa != null) {
      map['area_ha'] = Variable<double>(areaHa);
    }
    if (!nullToAbsent || posicaoReferencia != null) {
      map['posicao_referencia'] = Variable<String>(
        $ParcelasTable.$converterposicaoReferencian.toSql(posicaoReferencia),
      );
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ParcelasCompanion toCompanion(bool nullToAbsent) {
    return ParcelasCompanion(
      id: Value(id),
      talhaoLevantamentoId: Value(talhaoLevantamentoId),
      identificacao: Value(identificacao),
      situacao: Value(situacao),
      areaHa: areaHa == null && nullToAbsent
          ? const Value.absent()
          : Value(areaHa),
      posicaoReferencia: posicaoReferencia == null && nullToAbsent
          ? const Value.absent()
          : Value(posicaoReferencia),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Parcela.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Parcela(
      id: serializer.fromJson<int>(json['id']),
      talhaoLevantamentoId: serializer.fromJson<int>(
        json['talhaoLevantamentoId'],
      ),
      identificacao: serializer.fromJson<String>(json['identificacao']),
      situacao: $ParcelasTable.$convertersituacao.fromJson(
        serializer.fromJson<String>(json['situacao']),
      ),
      areaHa: serializer.fromJson<double?>(json['areaHa']),
      posicaoReferencia: $ParcelasTable.$converterposicaoReferencian.fromJson(
        serializer.fromJson<String?>(json['posicaoReferencia']),
      ),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'talhaoLevantamentoId': serializer.toJson<int>(talhaoLevantamentoId),
      'identificacao': serializer.toJson<String>(identificacao),
      'situacao': serializer.toJson<String>(
        $ParcelasTable.$convertersituacao.toJson(situacao),
      ),
      'areaHa': serializer.toJson<double?>(areaHa),
      'posicaoReferencia': serializer.toJson<String?>(
        $ParcelasTable.$converterposicaoReferencian.toJson(posicaoReferencia),
      ),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Parcela copyWith({
    int? id,
    int? talhaoLevantamentoId,
    String? identificacao,
    SituacaoParcela? situacao,
    Value<double?> areaHa = const Value.absent(),
    Value<PosicaoReferenciaParcela?> posicaoReferencia = const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Parcela(
    id: id ?? this.id,
    talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
    identificacao: identificacao ?? this.identificacao,
    situacao: situacao ?? this.situacao,
    areaHa: areaHa.present ? areaHa.value : this.areaHa,
    posicaoReferencia: posicaoReferencia.present
        ? posicaoReferencia.value
        : this.posicaoReferencia,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Parcela copyWithCompanion(ParcelasCompanion data) {
    return Parcela(
      id: data.id.present ? data.id.value : this.id,
      talhaoLevantamentoId: data.talhaoLevantamentoId.present
          ? data.talhaoLevantamentoId.value
          : this.talhaoLevantamentoId,
      identificacao: data.identificacao.present
          ? data.identificacao.value
          : this.identificacao,
      situacao: data.situacao.present ? data.situacao.value : this.situacao,
      areaHa: data.areaHa.present ? data.areaHa.value : this.areaHa,
      posicaoReferencia: data.posicaoReferencia.present
          ? data.posicaoReferencia.value
          : this.posicaoReferencia,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Parcela(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('identificacao: $identificacao, ')
          ..write('situacao: $situacao, ')
          ..write('areaHa: $areaHa, ')
          ..write('posicaoReferencia: $posicaoReferencia, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    talhaoLevantamentoId,
    identificacao,
    situacao,
    areaHa,
    posicaoReferencia,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Parcela &&
          other.id == this.id &&
          other.talhaoLevantamentoId == this.talhaoLevantamentoId &&
          other.identificacao == this.identificacao &&
          other.situacao == this.situacao &&
          other.areaHa == this.areaHa &&
          other.posicaoReferencia == this.posicaoReferencia &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ParcelasCompanion extends UpdateCompanion<Parcela> {
  final Value<int> id;
  final Value<int> talhaoLevantamentoId;
  final Value<String> identificacao;
  final Value<SituacaoParcela> situacao;
  final Value<double?> areaHa;
  final Value<PosicaoReferenciaParcela?> posicaoReferencia;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const ParcelasCompanion({
    this.id = const Value.absent(),
    this.talhaoLevantamentoId = const Value.absent(),
    this.identificacao = const Value.absent(),
    this.situacao = const Value.absent(),
    this.areaHa = const Value.absent(),
    this.posicaoReferencia = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  ParcelasCompanion.insert({
    this.id = const Value.absent(),
    required int talhaoLevantamentoId,
    required String identificacao,
    required SituacaoParcela situacao,
    this.areaHa = const Value.absent(),
    this.posicaoReferencia = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : talhaoLevantamentoId = Value(talhaoLevantamentoId),
       identificacao = Value(identificacao),
       situacao = Value(situacao),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Parcela> custom({
    Expression<int>? id,
    Expression<int>? talhaoLevantamentoId,
    Expression<String>? identificacao,
    Expression<String>? situacao,
    Expression<double>? areaHa,
    Expression<String>? posicaoReferencia,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (talhaoLevantamentoId != null)
        'talhao_levantamento_id': talhaoLevantamentoId,
      if (identificacao != null) 'identificacao': identificacao,
      if (situacao != null) 'situacao': situacao,
      if (areaHa != null) 'area_ha': areaHa,
      if (posicaoReferencia != null) 'posicao_referencia': posicaoReferencia,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  ParcelasCompanion copyWith({
    Value<int>? id,
    Value<int>? talhaoLevantamentoId,
    Value<String>? identificacao,
    Value<SituacaoParcela>? situacao,
    Value<double?>? areaHa,
    Value<PosicaoReferenciaParcela?>? posicaoReferencia,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return ParcelasCompanion(
      id: id ?? this.id,
      talhaoLevantamentoId: talhaoLevantamentoId ?? this.talhaoLevantamentoId,
      identificacao: identificacao ?? this.identificacao,
      situacao: situacao ?? this.situacao,
      areaHa: areaHa ?? this.areaHa,
      posicaoReferencia: posicaoReferencia ?? this.posicaoReferencia,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (talhaoLevantamentoId.present) {
      map['talhao_levantamento_id'] = Variable<int>(talhaoLevantamentoId.value);
    }
    if (identificacao.present) {
      map['identificacao'] = Variable<String>(identificacao.value);
    }
    if (situacao.present) {
      map['situacao'] = Variable<String>(
        $ParcelasTable.$convertersituacao.toSql(situacao.value),
      );
    }
    if (areaHa.present) {
      map['area_ha'] = Variable<double>(areaHa.value);
    }
    if (posicaoReferencia.present) {
      map['posicao_referencia'] = Variable<String>(
        $ParcelasTable.$converterposicaoReferencian.toSql(
          posicaoReferencia.value,
        ),
      );
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParcelasCompanion(')
          ..write('id: $id, ')
          ..write('talhaoLevantamentoId: $talhaoLevantamentoId, ')
          ..write('identificacao: $identificacao, ')
          ..write('situacao: $situacao, ')
          ..write('areaHa: $areaHa, ')
          ..write('posicaoReferencia: $posicaoReferencia, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $PontosGeograficosParcelaTable extends PontosGeograficosParcela
    with TableInfo<$PontosGeograficosParcelaTable, PontoGeograficoParcela> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PontosGeograficosParcelaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parcelaIdMeta = const VerificationMeta(
    'parcelaId',
  );
  @override
  late final GeneratedColumn<int> parcelaId = GeneratedColumn<int>(
    'parcela_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parcelas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ordemPontoMeta = const VerificationMeta(
    'ordemPonto',
  );
  @override
  late final GeneratedColumn<int> ordemPonto = GeneratedColumn<int>(
    'ordem_ponto',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  posicaoReferencia =
      GeneratedColumn<String>(
        'posicao_referencia',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PosicaoReferenciaParcela?>(
        $PontosGeograficosParcelaTable.$converterposicaoReferencian,
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
  static const VerificationMeta _precisaoMetrosMeta = const VerificationMeta(
    'precisaoMetros',
  );
  @override
  late final GeneratedColumn<double> precisaoMetros = GeneratedColumn<double>(
    'precisao_metros',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturadoEmMeta = const VerificationMeta(
    'capturadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> capturadoEm = GeneratedColumn<DateTime>(
    'capturado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parcelaId,
    ordemPonto,
    posicaoReferencia,
    latitude,
    longitude,
    precisaoMetros,
    capturadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pontos_geograficos_parcela';
  @override
  VerificationContext validateIntegrity(
    Insertable<PontoGeograficoParcela> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parcela_id')) {
      context.handle(
        _parcelaIdMeta,
        parcelaId.isAcceptableOrUnknown(data['parcela_id']!, _parcelaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelaIdMeta);
    }
    if (data.containsKey('ordem_ponto')) {
      context.handle(
        _ordemPontoMeta,
        ordemPonto.isAcceptableOrUnknown(data['ordem_ponto']!, _ordemPontoMeta),
      );
    } else if (isInserting) {
      context.missing(_ordemPontoMeta);
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
    if (data.containsKey('precisao_metros')) {
      context.handle(
        _precisaoMetrosMeta,
        precisaoMetros.isAcceptableOrUnknown(
          data['precisao_metros']!,
          _precisaoMetrosMeta,
        ),
      );
    }
    if (data.containsKey('capturado_em')) {
      context.handle(
        _capturadoEmMeta,
        capturadoEm.isAcceptableOrUnknown(
          data['capturado_em']!,
          _capturadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_capturadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PontoGeograficoParcela map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PontoGeograficoParcela(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parcelaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parcela_id'],
      )!,
      ordemPonto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem_ponto'],
      )!,
      posicaoReferencia: $PontosGeograficosParcelaTable
          .$converterposicaoReferencian
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}posicao_referencia'],
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
      precisaoMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precisao_metros'],
      ),
      capturadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}capturado_em'],
      )!,
    );
  }

  @override
  $PontosGeograficosParcelaTable createAlias(String alias) {
    return $PontosGeograficosParcelaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PosicaoReferenciaParcela, String, String>
  $converterposicaoReferencia =
      const EnumNameConverter<PosicaoReferenciaParcela>(
        PosicaoReferenciaParcela.values,
      );
  static JsonTypeConverter2<PosicaoReferenciaParcela?, String?, String?>
  $converterposicaoReferencian = JsonTypeConverter2.asNullable(
    $converterposicaoReferencia,
  );
}

class PontoGeograficoParcela extends DataClass
    implements Insertable<PontoGeograficoParcela> {
  final int id;
  final int parcelaId;
  final int ordemPonto;
  final PosicaoReferenciaParcela? posicaoReferencia;
  final double latitude;
  final double longitude;
  final double? precisaoMetros;
  final DateTime capturadoEm;
  const PontoGeograficoParcela({
    required this.id,
    required this.parcelaId,
    required this.ordemPonto,
    this.posicaoReferencia,
    required this.latitude,
    required this.longitude,
    this.precisaoMetros,
    required this.capturadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parcela_id'] = Variable<int>(parcelaId);
    map['ordem_ponto'] = Variable<int>(ordemPonto);
    if (!nullToAbsent || posicaoReferencia != null) {
      map['posicao_referencia'] = Variable<String>(
        $PontosGeograficosParcelaTable.$converterposicaoReferencian.toSql(
          posicaoReferencia,
        ),
      );
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || precisaoMetros != null) {
      map['precisao_metros'] = Variable<double>(precisaoMetros);
    }
    map['capturado_em'] = Variable<DateTime>(capturadoEm);
    return map;
  }

  PontosGeograficosParcelaCompanion toCompanion(bool nullToAbsent) {
    return PontosGeograficosParcelaCompanion(
      id: Value(id),
      parcelaId: Value(parcelaId),
      ordemPonto: Value(ordemPonto),
      posicaoReferencia: posicaoReferencia == null && nullToAbsent
          ? const Value.absent()
          : Value(posicaoReferencia),
      latitude: Value(latitude),
      longitude: Value(longitude),
      precisaoMetros: precisaoMetros == null && nullToAbsent
          ? const Value.absent()
          : Value(precisaoMetros),
      capturadoEm: Value(capturadoEm),
    );
  }

  factory PontoGeograficoParcela.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PontoGeograficoParcela(
      id: serializer.fromJson<int>(json['id']),
      parcelaId: serializer.fromJson<int>(json['parcelaId']),
      ordemPonto: serializer.fromJson<int>(json['ordemPonto']),
      posicaoReferencia: $PontosGeograficosParcelaTable
          .$converterposicaoReferencian
          .fromJson(serializer.fromJson<String?>(json['posicaoReferencia'])),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      precisaoMetros: serializer.fromJson<double?>(json['precisaoMetros']),
      capturadoEm: serializer.fromJson<DateTime>(json['capturadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parcelaId': serializer.toJson<int>(parcelaId),
      'ordemPonto': serializer.toJson<int>(ordemPonto),
      'posicaoReferencia': serializer.toJson<String?>(
        $PontosGeograficosParcelaTable.$converterposicaoReferencian.toJson(
          posicaoReferencia,
        ),
      ),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'precisaoMetros': serializer.toJson<double?>(precisaoMetros),
      'capturadoEm': serializer.toJson<DateTime>(capturadoEm),
    };
  }

  PontoGeograficoParcela copyWith({
    int? id,
    int? parcelaId,
    int? ordemPonto,
    Value<PosicaoReferenciaParcela?> posicaoReferencia = const Value.absent(),
    double? latitude,
    double? longitude,
    Value<double?> precisaoMetros = const Value.absent(),
    DateTime? capturadoEm,
  }) => PontoGeograficoParcela(
    id: id ?? this.id,
    parcelaId: parcelaId ?? this.parcelaId,
    ordemPonto: ordemPonto ?? this.ordemPonto,
    posicaoReferencia: posicaoReferencia.present
        ? posicaoReferencia.value
        : this.posicaoReferencia,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    precisaoMetros: precisaoMetros.present
        ? precisaoMetros.value
        : this.precisaoMetros,
    capturadoEm: capturadoEm ?? this.capturadoEm,
  );
  PontoGeograficoParcela copyWithCompanion(
    PontosGeograficosParcelaCompanion data,
  ) {
    return PontoGeograficoParcela(
      id: data.id.present ? data.id.value : this.id,
      parcelaId: data.parcelaId.present ? data.parcelaId.value : this.parcelaId,
      ordemPonto: data.ordemPonto.present
          ? data.ordemPonto.value
          : this.ordemPonto,
      posicaoReferencia: data.posicaoReferencia.present
          ? data.posicaoReferencia.value
          : this.posicaoReferencia,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      precisaoMetros: data.precisaoMetros.present
          ? data.precisaoMetros.value
          : this.precisaoMetros,
      capturadoEm: data.capturadoEm.present
          ? data.capturadoEm.value
          : this.capturadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PontoGeograficoParcela(')
          ..write('id: $id, ')
          ..write('parcelaId: $parcelaId, ')
          ..write('ordemPonto: $ordemPonto, ')
          ..write('posicaoReferencia: $posicaoReferencia, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoMetros: $precisaoMetros, ')
          ..write('capturadoEm: $capturadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parcelaId,
    ordemPonto,
    posicaoReferencia,
    latitude,
    longitude,
    precisaoMetros,
    capturadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PontoGeograficoParcela &&
          other.id == this.id &&
          other.parcelaId == this.parcelaId &&
          other.ordemPonto == this.ordemPonto &&
          other.posicaoReferencia == this.posicaoReferencia &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.precisaoMetros == this.precisaoMetros &&
          other.capturadoEm == this.capturadoEm);
}

class PontosGeograficosParcelaCompanion
    extends UpdateCompanion<PontoGeograficoParcela> {
  final Value<int> id;
  final Value<int> parcelaId;
  final Value<int> ordemPonto;
  final Value<PosicaoReferenciaParcela?> posicaoReferencia;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> precisaoMetros;
  final Value<DateTime> capturadoEm;
  const PontosGeograficosParcelaCompanion({
    this.id = const Value.absent(),
    this.parcelaId = const Value.absent(),
    this.ordemPonto = const Value.absent(),
    this.posicaoReferencia = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.precisaoMetros = const Value.absent(),
    this.capturadoEm = const Value.absent(),
  });
  PontosGeograficosParcelaCompanion.insert({
    this.id = const Value.absent(),
    required int parcelaId,
    required int ordemPonto,
    this.posicaoReferencia = const Value.absent(),
    required double latitude,
    required double longitude,
    this.precisaoMetros = const Value.absent(),
    required DateTime capturadoEm,
  }) : parcelaId = Value(parcelaId),
       ordemPonto = Value(ordemPonto),
       latitude = Value(latitude),
       longitude = Value(longitude),
       capturadoEm = Value(capturadoEm);
  static Insertable<PontoGeograficoParcela> custom({
    Expression<int>? id,
    Expression<int>? parcelaId,
    Expression<int>? ordemPonto,
    Expression<String>? posicaoReferencia,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? precisaoMetros,
    Expression<DateTime>? capturadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parcelaId != null) 'parcela_id': parcelaId,
      if (ordemPonto != null) 'ordem_ponto': ordemPonto,
      if (posicaoReferencia != null) 'posicao_referencia': posicaoReferencia,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (precisaoMetros != null) 'precisao_metros': precisaoMetros,
      if (capturadoEm != null) 'capturado_em': capturadoEm,
    });
  }

  PontosGeograficosParcelaCompanion copyWith({
    Value<int>? id,
    Value<int>? parcelaId,
    Value<int>? ordemPonto,
    Value<PosicaoReferenciaParcela?>? posicaoReferencia,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? precisaoMetros,
    Value<DateTime>? capturadoEm,
  }) {
    return PontosGeograficosParcelaCompanion(
      id: id ?? this.id,
      parcelaId: parcelaId ?? this.parcelaId,
      ordemPonto: ordemPonto ?? this.ordemPonto,
      posicaoReferencia: posicaoReferencia ?? this.posicaoReferencia,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      precisaoMetros: precisaoMetros ?? this.precisaoMetros,
      capturadoEm: capturadoEm ?? this.capturadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parcelaId.present) {
      map['parcela_id'] = Variable<int>(parcelaId.value);
    }
    if (ordemPonto.present) {
      map['ordem_ponto'] = Variable<int>(ordemPonto.value);
    }
    if (posicaoReferencia.present) {
      map['posicao_referencia'] = Variable<String>(
        $PontosGeograficosParcelaTable.$converterposicaoReferencian.toSql(
          posicaoReferencia.value,
        ),
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (precisaoMetros.present) {
      map['precisao_metros'] = Variable<double>(precisaoMetros.value);
    }
    if (capturadoEm.present) {
      map['capturado_em'] = Variable<DateTime>(capturadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PontosGeograficosParcelaCompanion(')
          ..write('id: $id, ')
          ..write('parcelaId: $parcelaId, ')
          ..write('ordemPonto: $ordemPonto, ')
          ..write('posicaoReferencia: $posicaoReferencia, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoMetros: $precisaoMetros, ')
          ..write('capturadoEm: $capturadoEm')
          ..write(')'))
        .toString();
  }
}

class $ArvoresTable extends Arvores with TableInfo<$ArvoresTable, Arvore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArvoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parcelaIdMeta = const VerificationMeta(
    'parcelaId',
  );
  @override
  late final GeneratedColumn<int> parcelaId = GeneratedColumn<int>(
    'parcela_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parcelas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
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
  static const VerificationMeta _alturaMMeta = const VerificationMeta(
    'alturaM',
  );
  @override
  late final GeneratedColumn<double> alturaM = GeneratedColumn<double>(
    'altura_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _possuiTroncoTortuosoMeta =
      const VerificationMeta('possuiTroncoTortuoso');
  @override
  late final GeneratedColumn<bool> possuiTroncoTortuoso = GeneratedColumn<bool>(
    'possui_tronco_tortuoso',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("possui_tronco_tortuoso" IN (0, 1))',
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
  static const VerificationMeta _precisaoMetrosMeta = const VerificationMeta(
    'precisaoMetros',
  );
  @override
  late final GeneratedColumn<double> precisaoMetros = GeneratedColumn<double>(
    'precisao_metros',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localizacaoCapturadaEmMeta =
      const VerificationMeta('localizacaoCapturadaEm');
  @override
  late final GeneratedColumn<DateTime> localizacaoCapturadaEm =
      GeneratedColumn<DateTime>(
        'localizacao_capturada_em',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  posicaoReferenciaParcela =
      GeneratedColumn<String>(
        'posicao_referencia_parcela',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PosicaoReferenciaParcela?>(
        $ArvoresTable.$converterposicaoReferenciaParcelan,
      );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parcelaId,
    numero,
    dapCm,
    alturaM,
    possuiTroncoTortuoso,
    latitude,
    longitude,
    precisaoMetros,
    localizacaoCapturadaEm,
    posicaoReferenciaParcela,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'arvores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Arvore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parcela_id')) {
      context.handle(
        _parcelaIdMeta,
        parcelaId.isAcceptableOrUnknown(data['parcela_id']!, _parcelaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelaIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('dap_cm')) {
      context.handle(
        _dapCmMeta,
        dapCm.isAcceptableOrUnknown(data['dap_cm']!, _dapCmMeta),
      );
    } else if (isInserting) {
      context.missing(_dapCmMeta);
    }
    if (data.containsKey('altura_m')) {
      context.handle(
        _alturaMMeta,
        alturaM.isAcceptableOrUnknown(data['altura_m']!, _alturaMMeta),
      );
    } else if (isInserting) {
      context.missing(_alturaMMeta);
    }
    if (data.containsKey('possui_tronco_tortuoso')) {
      context.handle(
        _possuiTroncoTortuosoMeta,
        possuiTroncoTortuoso.isAcceptableOrUnknown(
          data['possui_tronco_tortuoso']!,
          _possuiTroncoTortuosoMeta,
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
    if (data.containsKey('precisao_metros')) {
      context.handle(
        _precisaoMetrosMeta,
        precisaoMetros.isAcceptableOrUnknown(
          data['precisao_metros']!,
          _precisaoMetrosMeta,
        ),
      );
    }
    if (data.containsKey('localizacao_capturada_em')) {
      context.handle(
        _localizacaoCapturadaEmMeta,
        localizacaoCapturadaEm.isAcceptableOrUnknown(
          data['localizacao_capturada_em']!,
          _localizacaoCapturadaEmMeta,
        ),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Arvore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Arvore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parcelaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parcela_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      dapCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dap_cm'],
      )!,
      alturaM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altura_m'],
      )!,
      possuiTroncoTortuoso: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}possui_tronco_tortuoso'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      precisaoMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precisao_metros'],
      ),
      localizacaoCapturadaEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}localizacao_capturada_em'],
      ),
      posicaoReferenciaParcela: $ArvoresTable
          .$converterposicaoReferenciaParcelan
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}posicao_referencia_parcela'],
            ),
          ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      )!,
    );
  }

  @override
  $ArvoresTable createAlias(String alias) {
    return $ArvoresTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PosicaoReferenciaParcela, String, String>
  $converterposicaoReferenciaParcela =
      const EnumNameConverter<PosicaoReferenciaParcela>(
        PosicaoReferenciaParcela.values,
      );
  static JsonTypeConverter2<PosicaoReferenciaParcela?, String?, String?>
  $converterposicaoReferenciaParcelan = JsonTypeConverter2.asNullable(
    $converterposicaoReferenciaParcela,
  );
}

class Arvore extends DataClass implements Insertable<Arvore> {
  final int id;
  final int parcelaId;
  final int numero;
  final double dapCm;
  final double alturaM;
  final bool possuiTroncoTortuoso;
  final double? latitude;
  final double? longitude;
  final double? precisaoMetros;
  final DateTime? localizacaoCapturadaEm;
  final PosicaoReferenciaParcela? posicaoReferenciaParcela;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  const Arvore({
    required this.id,
    required this.parcelaId,
    required this.numero,
    required this.dapCm,
    required this.alturaM,
    required this.possuiTroncoTortuoso,
    this.latitude,
    this.longitude,
    this.precisaoMetros,
    this.localizacaoCapturadaEm,
    this.posicaoReferenciaParcela,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parcela_id'] = Variable<int>(parcelaId);
    map['numero'] = Variable<int>(numero);
    map['dap_cm'] = Variable<double>(dapCm);
    map['altura_m'] = Variable<double>(alturaM);
    map['possui_tronco_tortuoso'] = Variable<bool>(possuiTroncoTortuoso);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || precisaoMetros != null) {
      map['precisao_metros'] = Variable<double>(precisaoMetros);
    }
    if (!nullToAbsent || localizacaoCapturadaEm != null) {
      map['localizacao_capturada_em'] = Variable<DateTime>(
        localizacaoCapturadaEm,
      );
    }
    if (!nullToAbsent || posicaoReferenciaParcela != null) {
      map['posicao_referencia_parcela'] = Variable<String>(
        $ArvoresTable.$converterposicaoReferenciaParcelan.toSql(
          posicaoReferenciaParcela,
        ),
      );
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    return map;
  }

  ArvoresCompanion toCompanion(bool nullToAbsent) {
    return ArvoresCompanion(
      id: Value(id),
      parcelaId: Value(parcelaId),
      numero: Value(numero),
      dapCm: Value(dapCm),
      alturaM: Value(alturaM),
      possuiTroncoTortuoso: Value(possuiTroncoTortuoso),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      precisaoMetros: precisaoMetros == null && nullToAbsent
          ? const Value.absent()
          : Value(precisaoMetros),
      localizacaoCapturadaEm: localizacaoCapturadaEm == null && nullToAbsent
          ? const Value.absent()
          : Value(localizacaoCapturadaEm),
      posicaoReferenciaParcela: posicaoReferenciaParcela == null && nullToAbsent
          ? const Value.absent()
          : Value(posicaoReferenciaParcela),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
    );
  }

  factory Arvore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Arvore(
      id: serializer.fromJson<int>(json['id']),
      parcelaId: serializer.fromJson<int>(json['parcelaId']),
      numero: serializer.fromJson<int>(json['numero']),
      dapCm: serializer.fromJson<double>(json['dapCm']),
      alturaM: serializer.fromJson<double>(json['alturaM']),
      possuiTroncoTortuoso: serializer.fromJson<bool>(
        json['possuiTroncoTortuoso'],
      ),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      precisaoMetros: serializer.fromJson<double?>(json['precisaoMetros']),
      localizacaoCapturadaEm: serializer.fromJson<DateTime?>(
        json['localizacaoCapturadaEm'],
      ),
      posicaoReferenciaParcela: $ArvoresTable
          .$converterposicaoReferenciaParcelan
          .fromJson(
            serializer.fromJson<String?>(json['posicaoReferenciaParcela']),
          ),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parcelaId': serializer.toJson<int>(parcelaId),
      'numero': serializer.toJson<int>(numero),
      'dapCm': serializer.toJson<double>(dapCm),
      'alturaM': serializer.toJson<double>(alturaM),
      'possuiTroncoTortuoso': serializer.toJson<bool>(possuiTroncoTortuoso),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'precisaoMetros': serializer.toJson<double?>(precisaoMetros),
      'localizacaoCapturadaEm': serializer.toJson<DateTime?>(
        localizacaoCapturadaEm,
      ),
      'posicaoReferenciaParcela': serializer.toJson<String?>(
        $ArvoresTable.$converterposicaoReferenciaParcelan.toJson(
          posicaoReferenciaParcela,
        ),
      ),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
    };
  }

  Arvore copyWith({
    int? id,
    int? parcelaId,
    int? numero,
    double? dapCm,
    double? alturaM,
    bool? possuiTroncoTortuoso,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> precisaoMetros = const Value.absent(),
    Value<DateTime?> localizacaoCapturadaEm = const Value.absent(),
    Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela =
        const Value.absent(),
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) => Arvore(
    id: id ?? this.id,
    parcelaId: parcelaId ?? this.parcelaId,
    numero: numero ?? this.numero,
    dapCm: dapCm ?? this.dapCm,
    alturaM: alturaM ?? this.alturaM,
    possuiTroncoTortuoso: possuiTroncoTortuoso ?? this.possuiTroncoTortuoso,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    precisaoMetros: precisaoMetros.present
        ? precisaoMetros.value
        : this.precisaoMetros,
    localizacaoCapturadaEm: localizacaoCapturadaEm.present
        ? localizacaoCapturadaEm.value
        : this.localizacaoCapturadaEm,
    posicaoReferenciaParcela: posicaoReferenciaParcela.present
        ? posicaoReferenciaParcela.value
        : this.posicaoReferenciaParcela,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm ?? this.atualizadoEm,
  );
  Arvore copyWithCompanion(ArvoresCompanion data) {
    return Arvore(
      id: data.id.present ? data.id.value : this.id,
      parcelaId: data.parcelaId.present ? data.parcelaId.value : this.parcelaId,
      numero: data.numero.present ? data.numero.value : this.numero,
      dapCm: data.dapCm.present ? data.dapCm.value : this.dapCm,
      alturaM: data.alturaM.present ? data.alturaM.value : this.alturaM,
      possuiTroncoTortuoso: data.possuiTroncoTortuoso.present
          ? data.possuiTroncoTortuoso.value
          : this.possuiTroncoTortuoso,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      precisaoMetros: data.precisaoMetros.present
          ? data.precisaoMetros.value
          : this.precisaoMetros,
      localizacaoCapturadaEm: data.localizacaoCapturadaEm.present
          ? data.localizacaoCapturadaEm.value
          : this.localizacaoCapturadaEm,
      posicaoReferenciaParcela: data.posicaoReferenciaParcela.present
          ? data.posicaoReferenciaParcela.value
          : this.posicaoReferenciaParcela,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Arvore(')
          ..write('id: $id, ')
          ..write('parcelaId: $parcelaId, ')
          ..write('numero: $numero, ')
          ..write('dapCm: $dapCm, ')
          ..write('alturaM: $alturaM, ')
          ..write('possuiTroncoTortuoso: $possuiTroncoTortuoso, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoMetros: $precisaoMetros, ')
          ..write('localizacaoCapturadaEm: $localizacaoCapturadaEm, ')
          ..write('posicaoReferenciaParcela: $posicaoReferenciaParcela, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parcelaId,
    numero,
    dapCm,
    alturaM,
    possuiTroncoTortuoso,
    latitude,
    longitude,
    precisaoMetros,
    localizacaoCapturadaEm,
    posicaoReferenciaParcela,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Arvore &&
          other.id == this.id &&
          other.parcelaId == this.parcelaId &&
          other.numero == this.numero &&
          other.dapCm == this.dapCm &&
          other.alturaM == this.alturaM &&
          other.possuiTroncoTortuoso == this.possuiTroncoTortuoso &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.precisaoMetros == this.precisaoMetros &&
          other.localizacaoCapturadaEm == this.localizacaoCapturadaEm &&
          other.posicaoReferenciaParcela == this.posicaoReferenciaParcela &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ArvoresCompanion extends UpdateCompanion<Arvore> {
  final Value<int> id;
  final Value<int> parcelaId;
  final Value<int> numero;
  final Value<double> dapCm;
  final Value<double> alturaM;
  final Value<bool> possuiTroncoTortuoso;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> precisaoMetros;
  final Value<DateTime?> localizacaoCapturadaEm;
  final Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  const ArvoresCompanion({
    this.id = const Value.absent(),
    this.parcelaId = const Value.absent(),
    this.numero = const Value.absent(),
    this.dapCm = const Value.absent(),
    this.alturaM = const Value.absent(),
    this.possuiTroncoTortuoso = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.precisaoMetros = const Value.absent(),
    this.localizacaoCapturadaEm = const Value.absent(),
    this.posicaoReferenciaParcela = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  ArvoresCompanion.insert({
    this.id = const Value.absent(),
    required int parcelaId,
    required int numero,
    required double dapCm,
    required double alturaM,
    this.possuiTroncoTortuoso = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.precisaoMetros = const Value.absent(),
    this.localizacaoCapturadaEm = const Value.absent(),
    this.posicaoReferenciaParcela = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
  }) : parcelaId = Value(parcelaId),
       numero = Value(numero),
       dapCm = Value(dapCm),
       alturaM = Value(alturaM),
       criadoEm = Value(criadoEm),
       atualizadoEm = Value(atualizadoEm);
  static Insertable<Arvore> custom({
    Expression<int>? id,
    Expression<int>? parcelaId,
    Expression<int>? numero,
    Expression<double>? dapCm,
    Expression<double>? alturaM,
    Expression<bool>? possuiTroncoTortuoso,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? precisaoMetros,
    Expression<DateTime>? localizacaoCapturadaEm,
    Expression<String>? posicaoReferenciaParcela,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parcelaId != null) 'parcela_id': parcelaId,
      if (numero != null) 'numero': numero,
      if (dapCm != null) 'dap_cm': dapCm,
      if (alturaM != null) 'altura_m': alturaM,
      if (possuiTroncoTortuoso != null)
        'possui_tronco_tortuoso': possuiTroncoTortuoso,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (precisaoMetros != null) 'precisao_metros': precisaoMetros,
      if (localizacaoCapturadaEm != null)
        'localizacao_capturada_em': localizacaoCapturadaEm,
      if (posicaoReferenciaParcela != null)
        'posicao_referencia_parcela': posicaoReferenciaParcela,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  ArvoresCompanion copyWith({
    Value<int>? id,
    Value<int>? parcelaId,
    Value<int>? numero,
    Value<double>? dapCm,
    Value<double>? alturaM,
    Value<bool>? possuiTroncoTortuoso,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? precisaoMetros,
    Value<DateTime?>? localizacaoCapturadaEm,
    Value<PosicaoReferenciaParcela?>? posicaoReferenciaParcela,
    Value<DateTime>? criadoEm,
    Value<DateTime>? atualizadoEm,
  }) {
    return ArvoresCompanion(
      id: id ?? this.id,
      parcelaId: parcelaId ?? this.parcelaId,
      numero: numero ?? this.numero,
      dapCm: dapCm ?? this.dapCm,
      alturaM: alturaM ?? this.alturaM,
      possuiTroncoTortuoso: possuiTroncoTortuoso ?? this.possuiTroncoTortuoso,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      precisaoMetros: precisaoMetros ?? this.precisaoMetros,
      localizacaoCapturadaEm:
          localizacaoCapturadaEm ?? this.localizacaoCapturadaEm,
      posicaoReferenciaParcela:
          posicaoReferenciaParcela ?? this.posicaoReferenciaParcela,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parcelaId.present) {
      map['parcela_id'] = Variable<int>(parcelaId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (dapCm.present) {
      map['dap_cm'] = Variable<double>(dapCm.value);
    }
    if (alturaM.present) {
      map['altura_m'] = Variable<double>(alturaM.value);
    }
    if (possuiTroncoTortuoso.present) {
      map['possui_tronco_tortuoso'] = Variable<bool>(
        possuiTroncoTortuoso.value,
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (precisaoMetros.present) {
      map['precisao_metros'] = Variable<double>(precisaoMetros.value);
    }
    if (localizacaoCapturadaEm.present) {
      map['localizacao_capturada_em'] = Variable<DateTime>(
        localizacaoCapturadaEm.value,
      );
    }
    if (posicaoReferenciaParcela.present) {
      map['posicao_referencia_parcela'] = Variable<String>(
        $ArvoresTable.$converterposicaoReferenciaParcelan.toSql(
          posicaoReferenciaParcela.value,
        ),
      );
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArvoresCompanion(')
          ..write('id: $id, ')
          ..write('parcelaId: $parcelaId, ')
          ..write('numero: $numero, ')
          ..write('dapCm: $dapCm, ')
          ..write('alturaM: $alturaM, ')
          ..write('possuiTroncoTortuoso: $possuiTroncoTortuoso, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('precisaoMetros: $precisaoMetros, ')
          ..write('localizacaoCapturadaEm: $localizacaoCapturadaEm, ')
          ..write('posicaoReferenciaParcela: $posicaoReferenciaParcela, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $RegistrosAtividadeTable extends RegistrosAtividade
    with TableInfo<$RegistrosAtividadeTable, AtividadeBanco> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosAtividadeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtituloMeta = const VerificationMeta(
    'subtitulo',
  );
  @override
  late final GeneratedColumn<String> subtitulo = GeneratedColumn<String>(
    'subtitulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipoEntidadeMeta = const VerificationMeta(
    'tipoEntidade',
  );
  @override
  late final GeneratedColumn<String> tipoEntidade = GeneratedColumn<String>(
    'tipo_entidade',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entidadeIdMeta = const VerificationMeta(
    'entidadeId',
  );
  @override
  late final GeneratedColumn<int> entidadeId = GeneratedColumn<int>(
    'entidade_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ocorridoEmMeta = const VerificationMeta(
    'ocorridoEm',
  );
  @override
  late final GeneratedColumn<DateTime> ocorridoEm = GeneratedColumn<DateTime>(
    'ocorrido_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    titulo,
    subtitulo,
    tipoEntidade,
    entidadeId,
    ocorridoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros_atividade';
  @override
  VerificationContext validateIntegrity(
    Insertable<AtividadeBanco> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('subtitulo')) {
      context.handle(
        _subtituloMeta,
        subtitulo.isAcceptableOrUnknown(data['subtitulo']!, _subtituloMeta),
      );
    }
    if (data.containsKey('tipo_entidade')) {
      context.handle(
        _tipoEntidadeMeta,
        tipoEntidade.isAcceptableOrUnknown(
          data['tipo_entidade']!,
          _tipoEntidadeMeta,
        ),
      );
    }
    if (data.containsKey('entidade_id')) {
      context.handle(
        _entidadeIdMeta,
        entidadeId.isAcceptableOrUnknown(data['entidade_id']!, _entidadeIdMeta),
      );
    }
    if (data.containsKey('ocorrido_em')) {
      context.handle(
        _ocorridoEmMeta,
        ocorridoEm.isAcceptableOrUnknown(data['ocorrido_em']!, _ocorridoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_ocorridoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AtividadeBanco map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AtividadeBanco(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      subtitulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitulo'],
      )!,
      tipoEntidade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_entidade'],
      ),
      entidadeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entidade_id'],
      ),
      ocorridoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ocorrido_em'],
      )!,
    );
  }

  @override
  $RegistrosAtividadeTable createAlias(String alias) {
    return $RegistrosAtividadeTable(attachedDatabase, alias);
  }
}

class AtividadeBanco extends DataClass implements Insertable<AtividadeBanco> {
  final int id;
  final String tipo;
  final String titulo;
  final String subtitulo;
  final String? tipoEntidade;
  final int? entidadeId;
  final DateTime ocorridoEm;
  const AtividadeBanco({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.subtitulo,
    this.tipoEntidade,
    this.entidadeId,
    required this.ocorridoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo'] = Variable<String>(tipo);
    map['titulo'] = Variable<String>(titulo);
    map['subtitulo'] = Variable<String>(subtitulo);
    if (!nullToAbsent || tipoEntidade != null) {
      map['tipo_entidade'] = Variable<String>(tipoEntidade);
    }
    if (!nullToAbsent || entidadeId != null) {
      map['entidade_id'] = Variable<int>(entidadeId);
    }
    map['ocorrido_em'] = Variable<DateTime>(ocorridoEm);
    return map;
  }

  RegistrosAtividadeCompanion toCompanion(bool nullToAbsent) {
    return RegistrosAtividadeCompanion(
      id: Value(id),
      tipo: Value(tipo),
      titulo: Value(titulo),
      subtitulo: Value(subtitulo),
      tipoEntidade: tipoEntidade == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoEntidade),
      entidadeId: entidadeId == null && nullToAbsent
          ? const Value.absent()
          : Value(entidadeId),
      ocorridoEm: Value(ocorridoEm),
    );
  }

  factory AtividadeBanco.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AtividadeBanco(
      id: serializer.fromJson<int>(json['id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      titulo: serializer.fromJson<String>(json['titulo']),
      subtitulo: serializer.fromJson<String>(json['subtitulo']),
      tipoEntidade: serializer.fromJson<String?>(json['tipoEntidade']),
      entidadeId: serializer.fromJson<int?>(json['entidadeId']),
      ocorridoEm: serializer.fromJson<DateTime>(json['ocorridoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(tipo),
      'titulo': serializer.toJson<String>(titulo),
      'subtitulo': serializer.toJson<String>(subtitulo),
      'tipoEntidade': serializer.toJson<String?>(tipoEntidade),
      'entidadeId': serializer.toJson<int?>(entidadeId),
      'ocorridoEm': serializer.toJson<DateTime>(ocorridoEm),
    };
  }

  AtividadeBanco copyWith({
    int? id,
    String? tipo,
    String? titulo,
    String? subtitulo,
    Value<String?> tipoEntidade = const Value.absent(),
    Value<int?> entidadeId = const Value.absent(),
    DateTime? ocorridoEm,
  }) => AtividadeBanco(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    titulo: titulo ?? this.titulo,
    subtitulo: subtitulo ?? this.subtitulo,
    tipoEntidade: tipoEntidade.present ? tipoEntidade.value : this.tipoEntidade,
    entidadeId: entidadeId.present ? entidadeId.value : this.entidadeId,
    ocorridoEm: ocorridoEm ?? this.ocorridoEm,
  );
  AtividadeBanco copyWithCompanion(RegistrosAtividadeCompanion data) {
    return AtividadeBanco(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      subtitulo: data.subtitulo.present ? data.subtitulo.value : this.subtitulo,
      tipoEntidade: data.tipoEntidade.present
          ? data.tipoEntidade.value
          : this.tipoEntidade,
      entidadeId: data.entidadeId.present
          ? data.entidadeId.value
          : this.entidadeId,
      ocorridoEm: data.ocorridoEm.present
          ? data.ocorridoEm.value
          : this.ocorridoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AtividadeBanco(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('subtitulo: $subtitulo, ')
          ..write('tipoEntidade: $tipoEntidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('ocorridoEm: $ocorridoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    titulo,
    subtitulo,
    tipoEntidade,
    entidadeId,
    ocorridoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AtividadeBanco &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.titulo == this.titulo &&
          other.subtitulo == this.subtitulo &&
          other.tipoEntidade == this.tipoEntidade &&
          other.entidadeId == this.entidadeId &&
          other.ocorridoEm == this.ocorridoEm);
}

class RegistrosAtividadeCompanion extends UpdateCompanion<AtividadeBanco> {
  final Value<int> id;
  final Value<String> tipo;
  final Value<String> titulo;
  final Value<String> subtitulo;
  final Value<String?> tipoEntidade;
  final Value<int?> entidadeId;
  final Value<DateTime> ocorridoEm;
  const RegistrosAtividadeCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.titulo = const Value.absent(),
    this.subtitulo = const Value.absent(),
    this.tipoEntidade = const Value.absent(),
    this.entidadeId = const Value.absent(),
    this.ocorridoEm = const Value.absent(),
  });
  RegistrosAtividadeCompanion.insert({
    this.id = const Value.absent(),
    required String tipo,
    required String titulo,
    this.subtitulo = const Value.absent(),
    this.tipoEntidade = const Value.absent(),
    this.entidadeId = const Value.absent(),
    required DateTime ocorridoEm,
  }) : tipo = Value(tipo),
       titulo = Value(titulo),
       ocorridoEm = Value(ocorridoEm);
  static Insertable<AtividadeBanco> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<String>? titulo,
    Expression<String>? subtitulo,
    Expression<String>? tipoEntidade,
    Expression<int>? entidadeId,
    Expression<DateTime>? ocorridoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (titulo != null) 'titulo': titulo,
      if (subtitulo != null) 'subtitulo': subtitulo,
      if (tipoEntidade != null) 'tipo_entidade': tipoEntidade,
      if (entidadeId != null) 'entidade_id': entidadeId,
      if (ocorridoEm != null) 'ocorrido_em': ocorridoEm,
    });
  }

  RegistrosAtividadeCompanion copyWith({
    Value<int>? id,
    Value<String>? tipo,
    Value<String>? titulo,
    Value<String>? subtitulo,
    Value<String?>? tipoEntidade,
    Value<int?>? entidadeId,
    Value<DateTime>? ocorridoEm,
  }) {
    return RegistrosAtividadeCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      subtitulo: subtitulo ?? this.subtitulo,
      tipoEntidade: tipoEntidade ?? this.tipoEntidade,
      entidadeId: entidadeId ?? this.entidadeId,
      ocorridoEm: ocorridoEm ?? this.ocorridoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (subtitulo.present) {
      map['subtitulo'] = Variable<String>(subtitulo.value);
    }
    if (tipoEntidade.present) {
      map['tipo_entidade'] = Variable<String>(tipoEntidade.value);
    }
    if (entidadeId.present) {
      map['entidade_id'] = Variable<int>(entidadeId.value);
    }
    if (ocorridoEm.present) {
      map['ocorrido_em'] = Variable<DateTime>(ocorridoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosAtividadeCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('titulo: $titulo, ')
          ..write('subtitulo: $subtitulo, ')
          ..write('tipoEntidade: $tipoEntidade, ')
          ..write('entidadeId: $entidadeId, ')
          ..write('ocorridoEm: $ocorridoEm')
          ..write(')'))
        .toString();
  }
}

abstract class _$BancoDendro extends GeneratedDatabase {
  _$BancoDendro(QueryExecutor e) : super(e);
  $BancoDendroManager get managers => $BancoDendroManager(this);
  late final $PropriedadesTable propriedades = $PropriedadesTable(this);
  late final $EspeciesTable especies = $EspeciesTable(this);
  late final $ModelosMatematicosTable modelosMatematicos =
      $ModelosMatematicosTable(this);
  late final $VariaveisModeloTable variaveisModelo = $VariaveisModeloTable(
    this,
  );
  late final $CoeficientesModeloTable coeficientesModelo =
      $CoeficientesModeloTable(this);
  late final $EspeciesModelosTable especiesModelos = $EspeciesModelosTable(
    this,
  );
  late final $CoeficientesEspecieModeloTable coeficientesEspecieModelo =
      $CoeficientesEspecieModeloTable(this);
  late final $TalhoesTable talhoes = $TalhoesTable(this);
  late final $LevantamentosTable levantamentos = $LevantamentosTable(this);
  late final $TalhaoLevantamentosTable talhaoLevantamentos =
      $TalhaoLevantamentosTable(this);
  late final $CoeficientesTalhaoLevantamentoTable
  coeficientesTalhaoLevantamento = $CoeficientesTalhaoLevantamentoTable(this);
  late final $ParcelasTable parcelas = $ParcelasTable(this);
  late final $PontosGeograficosParcelaTable pontosGeograficosParcela =
      $PontosGeograficosParcelaTable(this);
  late final $ArvoresTable arvores = $ArvoresTable(this);
  late final $RegistrosAtividadeTable registrosAtividade =
      $RegistrosAtividadeTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    propriedades,
    especies,
    modelosMatematicos,
    variaveisModelo,
    coeficientesModelo,
    especiesModelos,
    coeficientesEspecieModelo,
    talhoes,
    levantamentos,
    talhaoLevantamentos,
    coeficientesTalhaoLevantamento,
    parcelas,
    pontosGeograficosParcela,
    arvores,
    registrosAtividade,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'modelos_matematicos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('variaveis_modelo', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'modelos_matematicos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('coeficientes_modelo', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'especies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('especies_modelos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'modelos_matematicos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('especies_modelos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'especies',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('coeficientes_especie_modelo', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'modelos_matematicos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('coeficientes_especie_modelo', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'propriedades',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('talhoes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'propriedades',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('levantamentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'levantamentos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('talhao_levantamentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'talhoes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('talhao_levantamentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'talhao_levantamentos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate(
          'coeficientes_talhao_levantamento',
          kind: UpdateKind.delete,
        ),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'talhao_levantamentos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('parcelas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parcelas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('pontos_geograficos_parcela', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parcelas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('arvores', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PropriedadesTableCreateCompanionBuilder =
    PropriedadesCompanion Function({
      Value<int> id,
      required String nome,
      required String municipio,
      Value<String> estado,
      required double areaTotalHa,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$PropriedadesTableUpdateCompanionBuilder =
    PropriedadesCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> municipio,
      Value<String> estado,
      Value<double> areaTotalHa,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$PropriedadesTableReferences
    extends BaseReferences<_$BancoDendro, $PropriedadesTable, Propriedade> {
  $$PropriedadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TalhoesTable, List<Talhao>> _talhoesRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.talhoes,
    aliasName: 'propriedades__id__talhoes__propriedade_id',
  );

  $$TalhoesTableProcessedTableManager get talhoesRefs {
    final manager = $$TalhoesTableTableManager(
      $_db,
      $_db.talhoes,
    ).filter((f) => f.propriedadeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_talhoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LevantamentosTable, List<Levantamento>>
  _levantamentosRefsTable(_$BancoDendro db) => MultiTypedResultKey.fromTable(
    db.levantamentos,
    aliasName: 'propriedades__id__levantamentos__propriedade_id',
  );

  $$LevantamentosTableProcessedTableManager get levantamentosRefs {
    final manager = $$LevantamentosTableTableManager(
      $_db,
      $_db.levantamentos,
    ).filter((f) => f.propriedadeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_levantamentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropriedadesTableFilterComposer
    extends Composer<_$BancoDendro, $PropriedadesTable> {
  $$PropriedadesTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get municipio => $composableBuilder(
    column: $table.municipio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaTotalHa => $composableBuilder(
    column: $table.areaTotalHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> talhoesRefs(
    Expression<bool> Function($$TalhoesTableFilterComposer f) f,
  ) {
    final $$TalhoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.propriedadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableFilterComposer(
            $db: $db,
            $table: $db.talhoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> levantamentosRefs(
    Expression<bool> Function($$LevantamentosTableFilterComposer f) f,
  ) {
    final $$LevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levantamentos,
      getReferencedColumn: (t) => t.propriedadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.levantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropriedadesTableOrderingComposer
    extends Composer<_$BancoDendro, $PropriedadesTable> {
  $$PropriedadesTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get municipio => $composableBuilder(
    column: $table.municipio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaTotalHa => $composableBuilder(
    column: $table.areaTotalHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropriedadesTableAnnotationComposer
    extends Composer<_$BancoDendro, $PropriedadesTable> {
  $$PropriedadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get municipio =>
      $composableBuilder(column: $table.municipio, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<double> get areaTotalHa => $composableBuilder(
    column: $table.areaTotalHa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> talhoesRefs<T extends Object>(
    Expression<T> Function($$TalhoesTableAnnotationComposer a) f,
  ) {
    final $$TalhoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.propriedadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableAnnotationComposer(
            $db: $db,
            $table: $db.talhoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> levantamentosRefs<T extends Object>(
    Expression<T> Function($$LevantamentosTableAnnotationComposer a) f,
  ) {
    final $$LevantamentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.levantamentos,
      getReferencedColumn: (t) => t.propriedadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevantamentosTableAnnotationComposer(
            $db: $db,
            $table: $db.levantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropriedadesTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $PropriedadesTable,
          Propriedade,
          $$PropriedadesTableFilterComposer,
          $$PropriedadesTableOrderingComposer,
          $$PropriedadesTableAnnotationComposer,
          $$PropriedadesTableCreateCompanionBuilder,
          $$PropriedadesTableUpdateCompanionBuilder,
          (Propriedade, $$PropriedadesTableReferences),
          Propriedade,
          PrefetchHooks Function({bool talhoesRefs, bool levantamentosRefs})
        > {
  $$PropriedadesTableTableManager(_$BancoDendro db, $PropriedadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropriedadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropriedadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropriedadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> municipio = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<double> areaTotalHa = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => PropriedadesCompanion(
                id: id,
                nome: nome,
                municipio: municipio,
                estado: estado,
                areaTotalHa: areaTotalHa,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String municipio,
                Value<String> estado = const Value.absent(),
                required double areaTotalHa,
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => PropriedadesCompanion.insert(
                id: id,
                nome: nome,
                municipio: municipio,
                estado: estado,
                areaTotalHa: areaTotalHa,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PropriedadesTable, Propriedade>(table),
                  $$PropriedadesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({talhoesRefs = false, levantamentosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (talhoesRefs) db.talhoes,
                    if (levantamentosRefs) db.levantamentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (talhoesRefs)
                        await $_getPrefetchedData<
                          Propriedade,
                          $PropriedadesTable,
                          Talhao
                        >(
                          currentTable: table,
                          referencedTable: $$PropriedadesTableReferences
                              ._talhoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PropriedadesTableReferences(
                                db,
                                table,
                                p0,
                              ).talhoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.propriedadeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (levantamentosRefs)
                        await $_getPrefetchedData<
                          Propriedade,
                          $PropriedadesTable,
                          Levantamento
                        >(
                          currentTable: table,
                          referencedTable: $$PropriedadesTableReferences
                              ._levantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PropriedadesTableReferences(
                                db,
                                table,
                                p0,
                              ).levantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.propriedadeId == item.id,
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

typedef $$PropriedadesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $PropriedadesTable,
      Propriedade,
      $$PropriedadesTableFilterComposer,
      $$PropriedadesTableOrderingComposer,
      $$PropriedadesTableAnnotationComposer,
      $$PropriedadesTableCreateCompanionBuilder,
      $$PropriedadesTableUpdateCompanionBuilder,
      (Propriedade, $$PropriedadesTableReferences),
      Propriedade,
      PrefetchHooks Function({bool talhoesRefs, bool levantamentosRefs})
    >;
typedef $$EspeciesTableCreateCompanionBuilder =
    EspeciesCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      required String nome,
      Value<String?> nomeCientifico,
      Value<String?> descricao,
      Value<bool> ativo,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$EspeciesTableUpdateCompanionBuilder =
    EspeciesCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      Value<String> nome,
      Value<String?> nomeCientifico,
      Value<String?> descricao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$EspeciesTableReferences
    extends BaseReferences<_$BancoDendro, $EspeciesTable, Especie> {
  $$EspeciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EspeciesModelosTable, List<EspecieModelo>>
  _especiesModelosRefsTable(_$BancoDendro db) => MultiTypedResultKey.fromTable(
    db.especiesModelos,
    aliasName: 'especies__id__especies_modelos__especie_id',
  );

  $$EspeciesModelosTableProcessedTableManager get especiesModelosRefs {
    final manager = $$EspeciesModelosTableTableManager(
      $_db,
      $_db.especiesModelos,
    ).filter((f) => f.especieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _especiesModelosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CoeficientesEspecieModeloTable,
    List<CoeficienteEspecieModelo>
  >
  _coeficientesEspecieModeloRefsTable(_$BancoDendro db) =>
      MultiTypedResultKey.fromTable(
        db.coeficientesEspecieModelo,
        aliasName: 'especies__id__coeficientes_especie_modelo__especie_id',
      );

  $$CoeficientesEspecieModeloTableProcessedTableManager
  get coeficientesEspecieModeloRefs {
    final manager = $$CoeficientesEspecieModeloTableTableManager(
      $_db,
      $_db.coeficientesEspecieModelo,
    ).filter((f) => f.especieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _coeficientesEspecieModeloRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TalhoesTable, List<Talhao>> _talhoesRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.talhoes,
    aliasName: 'especies__id__talhoes__especie_id',
  );

  $$TalhoesTableProcessedTableManager get talhoesRefs {
    final manager = $$TalhoesTableTableManager(
      $_db,
      $_db.talhoes,
    ).filter((f) => f.especieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_talhoesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamento>
  >
  _talhaoLevantamentosRefsTable(_$BancoDendro db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'especies__id__talhao_levantamentos__especie_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.especieId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EspeciesTableFilterComposer
    extends Composer<_$BancoDendro, $EspeciesTable> {
  $$EspeciesTableFilterComposer({
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

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> especiesModelosRefs(
    Expression<bool> Function($$EspeciesModelosTableFilterComposer f) f,
  ) {
    final $$EspeciesModelosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.especiesModelos,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesModelosTableFilterComposer(
            $db: $db,
            $table: $db.especiesModelos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> coeficientesEspecieModeloRefs(
    Expression<bool> Function($$CoeficientesEspecieModeloTableFilterComposer f)
    f,
  ) {
    final $$CoeficientesEspecieModeloTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesEspecieModelo,
          getReferencedColumn: (t) => t.especieId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesEspecieModeloTableFilterComposer(
                $db: $db,
                $table: $db.coeficientesEspecieModelo,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> talhoesRefs(
    Expression<bool> Function($$TalhoesTableFilterComposer f) f,
  ) {
    final $$TalhoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableFilterComposer(
            $db: $db,
            $table: $db.talhoes,
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
      getReferencedColumn: (t) => t.especieId,
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

class $$EspeciesTableOrderingComposer
    extends Composer<_$BancoDendro, $EspeciesTable> {
  $$EspeciesTableOrderingComposer({
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

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EspeciesTableAnnotationComposer
    extends Composer<_$BancoDendro, $EspeciesTable> {
  $$EspeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get nomeCientifico => $composableBuilder(
    column: $table.nomeCientifico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> especiesModelosRefs<T extends Object>(
    Expression<T> Function($$EspeciesModelosTableAnnotationComposer a) f,
  ) {
    final $$EspeciesModelosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.especiesModelos,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesModelosTableAnnotationComposer(
            $db: $db,
            $table: $db.especiesModelos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> coeficientesEspecieModeloRefs<T extends Object>(
    Expression<T> Function($$CoeficientesEspecieModeloTableAnnotationComposer a)
    f,
  ) {
    final $$CoeficientesEspecieModeloTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesEspecieModelo,
          getReferencedColumn: (t) => t.especieId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesEspecieModeloTableAnnotationComposer(
                $db: $db,
                $table: $db.coeficientesEspecieModelo,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> talhoesRefs<T extends Object>(
    Expression<T> Function($$TalhoesTableAnnotationComposer a) f,
  ) {
    final $$TalhoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.especieId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableAnnotationComposer(
            $db: $db,
            $table: $db.talhoes,
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
          getReferencedColumn: (t) => t.especieId,
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

class $$EspeciesTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $EspeciesTable,
          Especie,
          $$EspeciesTableFilterComposer,
          $$EspeciesTableOrderingComposer,
          $$EspeciesTableAnnotationComposer,
          $$EspeciesTableCreateCompanionBuilder,
          $$EspeciesTableUpdateCompanionBuilder,
          (Especie, $$EspeciesTableReferences),
          Especie,
          PrefetchHooks Function({
            bool especiesModelosRefs,
            bool coeficientesEspecieModeloRefs,
            bool talhoesRefs,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$EspeciesTableTableManager(_$BancoDendro db, $EspeciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EspeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EspeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EspeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> nomeCientifico = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => EspeciesCompanion(
                id: id,
                codigo: codigo,
                nome: nome,
                nomeCientifico: nomeCientifico,
                descricao: descricao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                required String nome,
                Value<String?> nomeCientifico = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => EspeciesCompanion.insert(
                id: id,
                codigo: codigo,
                nome: nome,
                nomeCientifico: nomeCientifico,
                descricao: descricao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EspeciesTable, Especie>(table),
                  $$EspeciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                especiesModelosRefs = false,
                coeficientesEspecieModeloRefs = false,
                talhoesRefs = false,
                talhaoLevantamentosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (especiesModelosRefs) db.especiesModelos,
                    if (coeficientesEspecieModeloRefs)
                      db.coeficientesEspecieModelo,
                    if (talhoesRefs) db.talhoes,
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (especiesModelosRefs)
                        await $_getPrefetchedData<
                          Especie,
                          $EspeciesTable,
                          EspecieModelo
                        >(
                          currentTable: table,
                          referencedTable: $$EspeciesTableReferences
                              ._especiesModelosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EspeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).especiesModelosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.especieId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (coeficientesEspecieModeloRefs)
                        await $_getPrefetchedData<
                          Especie,
                          $EspeciesTable,
                          CoeficienteEspecieModelo
                        >(
                          currentTable: table,
                          referencedTable: $$EspeciesTableReferences
                              ._coeficientesEspecieModeloRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EspeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).coeficientesEspecieModeloRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.especieId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talhoesRefs)
                        await $_getPrefetchedData<
                          Especie,
                          $EspeciesTable,
                          Talhao
                        >(
                          currentTable: table,
                          referencedTable: $$EspeciesTableReferences
                              ._talhoesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EspeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).talhoesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.especieId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          Especie,
                          $EspeciesTable,
                          TalhaoLevantamento
                        >(
                          currentTable: table,
                          referencedTable: $$EspeciesTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EspeciesTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.especieId == item.id,
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

typedef $$EspeciesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $EspeciesTable,
      Especie,
      $$EspeciesTableFilterComposer,
      $$EspeciesTableOrderingComposer,
      $$EspeciesTableAnnotationComposer,
      $$EspeciesTableCreateCompanionBuilder,
      $$EspeciesTableUpdateCompanionBuilder,
      (Especie, $$EspeciesTableReferences),
      Especie,
      PrefetchHooks Function({
        bool especiesModelosRefs,
        bool coeficientesEspecieModeloRefs,
        bool talhoesRefs,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$ModelosMatematicosTableCreateCompanionBuilder =
    ModelosMatematicosCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      required String nome,
      Value<String?> descricao,
      required String expressao,
      Value<bool> ativo,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$ModelosMatematicosTableUpdateCompanionBuilder =
    ModelosMatematicosCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      Value<String> nome,
      Value<String?> descricao,
      Value<String> expressao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$ModelosMatematicosTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $ModelosMatematicosTable,
          ModeloMatematico
        > {
  $$ModelosMatematicosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$VariaveisModeloTable, List<VariavelModelo>>
  _variaveisModeloRefsTable(_$BancoDendro db) => MultiTypedResultKey.fromTable(
    db.variaveisModelo,
    aliasName:
        'modelos_matematicos__id__variaveis_modelo__modelo_matematico_id',
  );

  $$VariaveisModeloTableProcessedTableManager get variaveisModeloRefs {
    final manager =
        $$VariaveisModeloTableTableManager($_db, $_db.variaveisModelo).filter(
          (f) => f.modeloMatematicoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _variaveisModeloRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CoeficientesModeloTable, List<CoeficienteModelo>>
  _coeficientesModeloRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.coeficientesModelo,
    aliasName:
        'modelos_matematicos__id__coeficientes_modelo__modelo_matematico_id',
  );

  $$CoeficientesModeloTableProcessedTableManager get coeficientesModeloRefs {
    final manager =
        $$CoeficientesModeloTableTableManager(
          $_db,
          $_db.coeficientesModelo,
        ).filter(
          (f) => f.modeloMatematicoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _coeficientesModeloRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EspeciesModelosTable, List<EspecieModelo>>
  _especiesModelosRefsTable(_$BancoDendro db) => MultiTypedResultKey.fromTable(
    db.especiesModelos,
    aliasName:
        'modelos_matematicos__id__especies_modelos__modelo_matematico_id',
  );

  $$EspeciesModelosTableProcessedTableManager get especiesModelosRefs {
    final manager =
        $$EspeciesModelosTableTableManager($_db, $_db.especiesModelos).filter(
          (f) => f.modeloMatematicoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _especiesModelosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CoeficientesEspecieModeloTable,
    List<CoeficienteEspecieModelo>
  >
  _coeficientesEspecieModeloRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.coeficientesEspecieModelo,
    aliasName:
        'modelos_matematicos__id__coeficientes_especie_modelo__modelo_matematico_id',
  );

  $$CoeficientesEspecieModeloTableProcessedTableManager
  get coeficientesEspecieModeloRefs {
    final manager =
        $$CoeficientesEspecieModeloTableTableManager(
          $_db,
          $_db.coeficientesEspecieModelo,
        ).filter(
          (f) => f.modeloMatematicoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _coeficientesEspecieModeloRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamento>
  >
  _talhaoLevantamentosRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.talhaoLevantamentos,
    aliasName:
        'modelos_matematicos__id__talhao_levantamentos__modelo_matematico_id',
  );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager =
        $$TalhaoLevantamentosTableTableManager(
          $_db,
          $_db.talhaoLevantamentos,
        ).filter(
          (f) => f.modeloMatematicoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ModelosMatematicosTableFilterComposer
    extends Composer<_$BancoDendro, $ModelosMatematicosTable> {
  $$ModelosMatematicosTableFilterComposer({
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

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expressao => $composableBuilder(
    column: $table.expressao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> variaveisModeloRefs(
    Expression<bool> Function($$VariaveisModeloTableFilterComposer f) f,
  ) {
    final $$VariaveisModeloTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variaveisModelo,
      getReferencedColumn: (t) => t.modeloMatematicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariaveisModeloTableFilterComposer(
            $db: $db,
            $table: $db.variaveisModelo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> coeficientesModeloRefs(
    Expression<bool> Function($$CoeficientesModeloTableFilterComposer f) f,
  ) {
    final $$CoeficientesModeloTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.coeficientesModelo,
      getReferencedColumn: (t) => t.modeloMatematicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoeficientesModeloTableFilterComposer(
            $db: $db,
            $table: $db.coeficientesModelo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> especiesModelosRefs(
    Expression<bool> Function($$EspeciesModelosTableFilterComposer f) f,
  ) {
    final $$EspeciesModelosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.especiesModelos,
      getReferencedColumn: (t) => t.modeloMatematicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesModelosTableFilterComposer(
            $db: $db,
            $table: $db.especiesModelos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> coeficientesEspecieModeloRefs(
    Expression<bool> Function($$CoeficientesEspecieModeloTableFilterComposer f)
    f,
  ) {
    final $$CoeficientesEspecieModeloTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesEspecieModelo,
          getReferencedColumn: (t) => t.modeloMatematicoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesEspecieModeloTableFilterComposer(
                $db: $db,
                $table: $db.coeficientesEspecieModelo,
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
      getReferencedColumn: (t) => t.modeloMatematicoId,
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

class $$ModelosMatematicosTableOrderingComposer
    extends Composer<_$BancoDendro, $ModelosMatematicosTable> {
  $$ModelosMatematicosTableOrderingComposer({
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

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expressao => $composableBuilder(
    column: $table.expressao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelosMatematicosTableAnnotationComposer
    extends Composer<_$BancoDendro, $ModelosMatematicosTable> {
  $$ModelosMatematicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<String> get expressao =>
      $composableBuilder(column: $table.expressao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> variaveisModeloRefs<T extends Object>(
    Expression<T> Function($$VariaveisModeloTableAnnotationComposer a) f,
  ) {
    final $$VariaveisModeloTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variaveisModelo,
      getReferencedColumn: (t) => t.modeloMatematicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariaveisModeloTableAnnotationComposer(
            $db: $db,
            $table: $db.variaveisModelo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> coeficientesModeloRefs<T extends Object>(
    Expression<T> Function($$CoeficientesModeloTableAnnotationComposer a) f,
  ) {
    final $$CoeficientesModeloTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesModelo,
          getReferencedColumn: (t) => t.modeloMatematicoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesModeloTableAnnotationComposer(
                $db: $db,
                $table: $db.coeficientesModelo,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> especiesModelosRefs<T extends Object>(
    Expression<T> Function($$EspeciesModelosTableAnnotationComposer a) f,
  ) {
    final $$EspeciesModelosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.especiesModelos,
      getReferencedColumn: (t) => t.modeloMatematicoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesModelosTableAnnotationComposer(
            $db: $db,
            $table: $db.especiesModelos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> coeficientesEspecieModeloRefs<T extends Object>(
    Expression<T> Function($$CoeficientesEspecieModeloTableAnnotationComposer a)
    f,
  ) {
    final $$CoeficientesEspecieModeloTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesEspecieModelo,
          getReferencedColumn: (t) => t.modeloMatematicoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesEspecieModeloTableAnnotationComposer(
                $db: $db,
                $table: $db.coeficientesEspecieModelo,
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
          getReferencedColumn: (t) => t.modeloMatematicoId,
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

class $$ModelosMatematicosTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $ModelosMatematicosTable,
          ModeloMatematico,
          $$ModelosMatematicosTableFilterComposer,
          $$ModelosMatematicosTableOrderingComposer,
          $$ModelosMatematicosTableAnnotationComposer,
          $$ModelosMatematicosTableCreateCompanionBuilder,
          $$ModelosMatematicosTableUpdateCompanionBuilder,
          (ModeloMatematico, $$ModelosMatematicosTableReferences),
          ModeloMatematico,
          PrefetchHooks Function({
            bool variaveisModeloRefs,
            bool coeficientesModeloRefs,
            bool especiesModelosRefs,
            bool coeficientesEspecieModeloRefs,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$ModelosMatematicosTableTableManager(
    _$BancoDendro db,
    $ModelosMatematicosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelosMatematicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelosMatematicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelosMatematicosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> descricao = const Value.absent(),
                Value<String> expressao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => ModelosMatematicosCompanion(
                id: id,
                codigo: codigo,
                nome: nome,
                descricao: descricao,
                expressao: expressao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                required String nome,
                Value<String?> descricao = const Value.absent(),
                required String expressao,
                Value<bool> ativo = const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => ModelosMatematicosCompanion.insert(
                id: id,
                codigo: codigo,
                nome: nome,
                descricao: descricao,
                expressao: expressao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ModelosMatematicosTable, ModeloMatematico>(
                    table,
                  ),
                  $$ModelosMatematicosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                variaveisModeloRefs = false,
                coeficientesModeloRefs = false,
                especiesModelosRefs = false,
                coeficientesEspecieModeloRefs = false,
                talhaoLevantamentosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (variaveisModeloRefs) db.variaveisModelo,
                    if (coeficientesModeloRefs) db.coeficientesModelo,
                    if (especiesModelosRefs) db.especiesModelos,
                    if (coeficientesEspecieModeloRefs)
                      db.coeficientesEspecieModelo,
                    if (talhaoLevantamentosRefs) db.talhaoLevantamentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (variaveisModeloRefs)
                        await $_getPrefetchedData<
                          ModeloMatematico,
                          $ModelosMatematicosTable,
                          VariavelModelo
                        >(
                          currentTable: table,
                          referencedTable: $$ModelosMatematicosTableReferences
                              ._variaveisModeloRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelosMatematicosTableReferences(
                                db,
                                table,
                                p0,
                              ).variaveisModeloRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modeloMatematicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (coeficientesModeloRefs)
                        await $_getPrefetchedData<
                          ModeloMatematico,
                          $ModelosMatematicosTable,
                          CoeficienteModelo
                        >(
                          currentTable: table,
                          referencedTable: $$ModelosMatematicosTableReferences
                              ._coeficientesModeloRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelosMatematicosTableReferences(
                                db,
                                table,
                                p0,
                              ).coeficientesModeloRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modeloMatematicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (especiesModelosRefs)
                        await $_getPrefetchedData<
                          ModeloMatematico,
                          $ModelosMatematicosTable,
                          EspecieModelo
                        >(
                          currentTable: table,
                          referencedTable: $$ModelosMatematicosTableReferences
                              ._especiesModelosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelosMatematicosTableReferences(
                                db,
                                table,
                                p0,
                              ).especiesModelosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modeloMatematicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (coeficientesEspecieModeloRefs)
                        await $_getPrefetchedData<
                          ModeloMatematico,
                          $ModelosMatematicosTable,
                          CoeficienteEspecieModelo
                        >(
                          currentTable: table,
                          referencedTable: $$ModelosMatematicosTableReferences
                              ._coeficientesEspecieModeloRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelosMatematicosTableReferences(
                                db,
                                table,
                                p0,
                              ).coeficientesEspecieModeloRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modeloMatematicoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talhaoLevantamentosRefs)
                        await $_getPrefetchedData<
                          ModeloMatematico,
                          $ModelosMatematicosTable,
                          TalhaoLevantamento
                        >(
                          currentTable: table,
                          referencedTable: $$ModelosMatematicosTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ModelosMatematicosTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.modeloMatematicoId == item.id,
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

typedef $$ModelosMatematicosTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $ModelosMatematicosTable,
      ModeloMatematico,
      $$ModelosMatematicosTableFilterComposer,
      $$ModelosMatematicosTableOrderingComposer,
      $$ModelosMatematicosTableAnnotationComposer,
      $$ModelosMatematicosTableCreateCompanionBuilder,
      $$ModelosMatematicosTableUpdateCompanionBuilder,
      (ModeloMatematico, $$ModelosMatematicosTableReferences),
      ModeloMatematico,
      PrefetchHooks Function({
        bool variaveisModeloRefs,
        bool coeficientesModeloRefs,
        bool especiesModelosRefs,
        bool coeficientesEspecieModeloRefs,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$VariaveisModeloTableCreateCompanionBuilder =
    VariaveisModeloCompanion Function({
      Value<int> id,
      required int modeloMatematicoId,
      required String simbolo,
      required String rotulo,
      required String unidade,
      required String origemValor,
      required ChaveVariavelModelo chaveVariavel,
    });
typedef $$VariaveisModeloTableUpdateCompanionBuilder =
    VariaveisModeloCompanion Function({
      Value<int> id,
      Value<int> modeloMatematicoId,
      Value<String> simbolo,
      Value<String> rotulo,
      Value<String> unidade,
      Value<String> origemValor,
      Value<ChaveVariavelModelo> chaveVariavel,
    });

final class $$VariaveisModeloTableReferences
    extends
        BaseReferences<_$BancoDendro, $VariaveisModeloTable, VariavelModelo> {
  $$VariaveisModeloTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModelosMatematicosTable _modeloMatematicoIdTable(_$BancoDendro db) =>
      db.modelosMatematicos.createAlias(
        'variaveis_modelo__modelo_matematico_id__modelos_matematicos__id',
      );

  $$ModelosMatematicosTableProcessedTableManager get modeloMatematicoId {
    final $_column = $_itemColumn<int>('modelo_matematico_id')!;

    final manager = $$ModelosMatematicosTableTableManager(
      $_db,
      $_db.modelosMatematicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeloMatematicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VariaveisModeloTableFilterComposer
    extends Composer<_$BancoDendro, $VariaveisModeloTable> {
  $$VariaveisModeloTableFilterComposer({
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

  ColumnFilters<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origemValor => $composableBuilder(
    column: $table.origemValor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    ChaveVariavelModelo,
    ChaveVariavelModelo,
    String
  >
  get chaveVariavel => $composableBuilder(
    column: $table.chaveVariavel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ModelosMatematicosTableFilterComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableFilterComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariaveisModeloTableOrderingComposer
    extends Composer<_$BancoDendro, $VariaveisModeloTable> {
  $$VariaveisModeloTableOrderingComposer({
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

  ColumnOrderings<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidade => $composableBuilder(
    column: $table.unidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origemValor => $composableBuilder(
    column: $table.origemValor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chaveVariavel => $composableBuilder(
    column: $table.chaveVariavel,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModelosMatematicosTableOrderingComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableOrderingComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariaveisModeloTableAnnotationComposer
    extends Composer<_$BancoDendro, $VariaveisModeloTable> {
  $$VariaveisModeloTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get simbolo =>
      $composableBuilder(column: $table.simbolo, builder: (column) => column);

  GeneratedColumn<String> get rotulo =>
      $composableBuilder(column: $table.rotulo, builder: (column) => column);

  GeneratedColumn<String> get unidade =>
      $composableBuilder(column: $table.unidade, builder: (column) => column);

  GeneratedColumn<String> get origemValor => $composableBuilder(
    column: $table.origemValor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ChaveVariavelModelo, String>
  get chaveVariavel => $composableBuilder(
    column: $table.chaveVariavel,
    builder: (column) => column,
  );

  $$ModelosMatematicosTableAnnotationComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.modeloMatematicoId,
          referencedTable: $db.modelosMatematicos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModelosMatematicosTableAnnotationComposer(
                $db: $db,
                $table: $db.modelosMatematicos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$VariaveisModeloTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $VariaveisModeloTable,
          VariavelModelo,
          $$VariaveisModeloTableFilterComposer,
          $$VariaveisModeloTableOrderingComposer,
          $$VariaveisModeloTableAnnotationComposer,
          $$VariaveisModeloTableCreateCompanionBuilder,
          $$VariaveisModeloTableUpdateCompanionBuilder,
          (VariavelModelo, $$VariaveisModeloTableReferences),
          VariavelModelo,
          PrefetchHooks Function({bool modeloMatematicoId})
        > {
  $$VariaveisModeloTableTableManager(
    _$BancoDendro db,
    $VariaveisModeloTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariaveisModeloTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariaveisModeloTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariaveisModeloTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> modeloMatematicoId = const Value.absent(),
                Value<String> simbolo = const Value.absent(),
                Value<String> rotulo = const Value.absent(),
                Value<String> unidade = const Value.absent(),
                Value<String> origemValor = const Value.absent(),
                Value<ChaveVariavelModelo> chaveVariavel = const Value.absent(),
              }) => VariaveisModeloCompanion(
                id: id,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                unidade: unidade,
                origemValor: origemValor,
                chaveVariavel: chaveVariavel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int modeloMatematicoId,
                required String simbolo,
                required String rotulo,
                required String unidade,
                required String origemValor,
                required ChaveVariavelModelo chaveVariavel,
              }) => VariaveisModeloCompanion.insert(
                id: id,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                unidade: unidade,
                origemValor: origemValor,
                chaveVariavel: chaveVariavel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VariaveisModeloTable, VariavelModelo>(table),
                  $$VariaveisModeloTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({modeloMatematicoId = false}) {
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
                    if (modeloMatematicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modeloMatematicoId,
                                referencedTable:
                                    $$VariaveisModeloTableReferences
                                        ._modeloMatematicoIdTable(db),
                                referencedColumn:
                                    $$VariaveisModeloTableReferences
                                        ._modeloMatematicoIdTable(db)
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

typedef $$VariaveisModeloTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $VariaveisModeloTable,
      VariavelModelo,
      $$VariaveisModeloTableFilterComposer,
      $$VariaveisModeloTableOrderingComposer,
      $$VariaveisModeloTableAnnotationComposer,
      $$VariaveisModeloTableCreateCompanionBuilder,
      $$VariaveisModeloTableUpdateCompanionBuilder,
      (VariavelModelo, $$VariaveisModeloTableReferences),
      VariavelModelo,
      PrefetchHooks Function({bool modeloMatematicoId})
    >;
typedef $$CoeficientesModeloTableCreateCompanionBuilder =
    CoeficientesModeloCompanion Function({
      Value<int> id,
      required int modeloMatematicoId,
      required String simbolo,
      required String rotulo,
      Value<double?> valor,
    });
typedef $$CoeficientesModeloTableUpdateCompanionBuilder =
    CoeficientesModeloCompanion Function({
      Value<int> id,
      Value<int> modeloMatematicoId,
      Value<String> simbolo,
      Value<String> rotulo,
      Value<double?> valor,
    });

final class $$CoeficientesModeloTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $CoeficientesModeloTable,
          CoeficienteModelo
        > {
  $$CoeficientesModeloTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ModelosMatematicosTable _modeloMatematicoIdTable(_$BancoDendro db) =>
      db.modelosMatematicos.createAlias(
        'coeficientes_modelo__modelo_matematico_id__modelos_matematicos__id',
      );

  $$ModelosMatematicosTableProcessedTableManager get modeloMatematicoId {
    final $_column = $_itemColumn<int>('modelo_matematico_id')!;

    final manager = $$ModelosMatematicosTableTableManager(
      $_db,
      $_db.modelosMatematicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeloMatematicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CoeficientesModeloTableFilterComposer
    extends Composer<_$BancoDendro, $CoeficientesModeloTable> {
  $$CoeficientesModeloTableFilterComposer({
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

  ColumnFilters<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  $$ModelosMatematicosTableFilterComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableFilterComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CoeficientesModeloTableOrderingComposer
    extends Composer<_$BancoDendro, $CoeficientesModeloTable> {
  $$CoeficientesModeloTableOrderingComposer({
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

  ColumnOrderings<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ModelosMatematicosTableOrderingComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableOrderingComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CoeficientesModeloTableAnnotationComposer
    extends Composer<_$BancoDendro, $CoeficientesModeloTable> {
  $$CoeficientesModeloTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get simbolo =>
      $composableBuilder(column: $table.simbolo, builder: (column) => column);

  GeneratedColumn<String> get rotulo =>
      $composableBuilder(column: $table.rotulo, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  $$ModelosMatematicosTableAnnotationComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.modeloMatematicoId,
          referencedTable: $db.modelosMatematicos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModelosMatematicosTableAnnotationComposer(
                $db: $db,
                $table: $db.modelosMatematicos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CoeficientesModeloTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $CoeficientesModeloTable,
          CoeficienteModelo,
          $$CoeficientesModeloTableFilterComposer,
          $$CoeficientesModeloTableOrderingComposer,
          $$CoeficientesModeloTableAnnotationComposer,
          $$CoeficientesModeloTableCreateCompanionBuilder,
          $$CoeficientesModeloTableUpdateCompanionBuilder,
          (CoeficienteModelo, $$CoeficientesModeloTableReferences),
          CoeficienteModelo,
          PrefetchHooks Function({bool modeloMatematicoId})
        > {
  $$CoeficientesModeloTableTableManager(
    _$BancoDendro db,
    $CoeficientesModeloTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoeficientesModeloTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoeficientesModeloTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoeficientesModeloTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> modeloMatematicoId = const Value.absent(),
                Value<String> simbolo = const Value.absent(),
                Value<String> rotulo = const Value.absent(),
                Value<double?> valor = const Value.absent(),
              }) => CoeficientesModeloCompanion(
                id: id,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int modeloMatematicoId,
                required String simbolo,
                required String rotulo,
                Value<double?> valor = const Value.absent(),
              }) => CoeficientesModeloCompanion.insert(
                id: id,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoeficientesModeloTable, CoeficienteModelo>(
                    table,
                  ),
                  $$CoeficientesModeloTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({modeloMatematicoId = false}) {
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
                    if (modeloMatematicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modeloMatematicoId,
                                referencedTable:
                                    $$CoeficientesModeloTableReferences
                                        ._modeloMatematicoIdTable(db),
                                referencedColumn:
                                    $$CoeficientesModeloTableReferences
                                        ._modeloMatematicoIdTable(db)
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

typedef $$CoeficientesModeloTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $CoeficientesModeloTable,
      CoeficienteModelo,
      $$CoeficientesModeloTableFilterComposer,
      $$CoeficientesModeloTableOrderingComposer,
      $$CoeficientesModeloTableAnnotationComposer,
      $$CoeficientesModeloTableCreateCompanionBuilder,
      $$CoeficientesModeloTableUpdateCompanionBuilder,
      (CoeficienteModelo, $$CoeficientesModeloTableReferences),
      CoeficienteModelo,
      PrefetchHooks Function({bool modeloMatematicoId})
    >;
typedef $$EspeciesModelosTableCreateCompanionBuilder =
    EspeciesModelosCompanion Function({
      required int especieId,
      required int modeloMatematicoId,
      Value<bool> padrao,
      required DateTime criadoEm,
      Value<int> rowid,
    });
typedef $$EspeciesModelosTableUpdateCompanionBuilder =
    EspeciesModelosCompanion Function({
      Value<int> especieId,
      Value<int> modeloMatematicoId,
      Value<bool> padrao,
      Value<DateTime> criadoEm,
      Value<int> rowid,
    });

final class $$EspeciesModelosTableReferences
    extends
        BaseReferences<_$BancoDendro, $EspeciesModelosTable, EspecieModelo> {
  $$EspeciesModelosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EspeciesTable _especieIdTable(_$BancoDendro db) =>
      db.especies.createAlias('especies_modelos__especie_id__especies__id');

  $$EspeciesTableProcessedTableManager get especieId {
    final $_column = $_itemColumn<int>('especie_id')!;

    final manager = $$EspeciesTableTableManager(
      $_db,
      $_db.especies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_especieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelosMatematicosTable _modeloMatematicoIdTable(_$BancoDendro db) =>
      db.modelosMatematicos.createAlias(
        'especies_modelos__modelo_matematico_id__modelos_matematicos__id',
      );

  $$ModelosMatematicosTableProcessedTableManager get modeloMatematicoId {
    final $_column = $_itemColumn<int>('modelo_matematico_id')!;

    final manager = $$ModelosMatematicosTableTableManager(
      $_db,
      $_db.modelosMatematicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeloMatematicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EspeciesModelosTableFilterComposer
    extends Composer<_$BancoDendro, $EspeciesModelosTable> {
  $$EspeciesModelosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$EspeciesTableFilterComposer get especieId {
    final $$EspeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableFilterComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableFilterComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableFilterComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EspeciesModelosTableOrderingComposer
    extends Composer<_$BancoDendro, $EspeciesModelosTable> {
  $$EspeciesModelosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get padrao => $composableBuilder(
    column: $table.padrao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$EspeciesTableOrderingComposer get especieId {
    final $$EspeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableOrderingComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableOrderingComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableOrderingComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EspeciesModelosTableAnnotationComposer
    extends Composer<_$BancoDendro, $EspeciesModelosTable> {
  $$EspeciesModelosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get padrao =>
      $composableBuilder(column: $table.padrao, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  $$EspeciesTableAnnotationComposer get especieId {
    final $$EspeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableAnnotationComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.modeloMatematicoId,
          referencedTable: $db.modelosMatematicos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModelosMatematicosTableAnnotationComposer(
                $db: $db,
                $table: $db.modelosMatematicos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$EspeciesModelosTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $EspeciesModelosTable,
          EspecieModelo,
          $$EspeciesModelosTableFilterComposer,
          $$EspeciesModelosTableOrderingComposer,
          $$EspeciesModelosTableAnnotationComposer,
          $$EspeciesModelosTableCreateCompanionBuilder,
          $$EspeciesModelosTableUpdateCompanionBuilder,
          (EspecieModelo, $$EspeciesModelosTableReferences),
          EspecieModelo,
          PrefetchHooks Function({bool especieId, bool modeloMatematicoId})
        > {
  $$EspeciesModelosTableTableManager(
    _$BancoDendro db,
    $EspeciesModelosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EspeciesModelosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EspeciesModelosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EspeciesModelosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> especieId = const Value.absent(),
                Value<int> modeloMatematicoId = const Value.absent(),
                Value<bool> padrao = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EspeciesModelosCompanion(
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                padrao: padrao,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int especieId,
                required int modeloMatematicoId,
                Value<bool> padrao = const Value.absent(),
                required DateTime criadoEm,
                Value<int> rowid = const Value.absent(),
              }) => EspeciesModelosCompanion.insert(
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                padrao: padrao,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EspeciesModelosTable, EspecieModelo>(table),
                  $$EspeciesModelosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({especieId = false, modeloMatematicoId = false}) {
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
                        if (especieId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.especieId,
                                    referencedTable:
                                        $$EspeciesModelosTableReferences
                                            ._especieIdTable(db),
                                    referencedColumn:
                                        $$EspeciesModelosTableReferences
                                            ._especieIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (modeloMatematicoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modeloMatematicoId,
                                    referencedTable:
                                        $$EspeciesModelosTableReferences
                                            ._modeloMatematicoIdTable(db),
                                    referencedColumn:
                                        $$EspeciesModelosTableReferences
                                            ._modeloMatematicoIdTable(db)
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

typedef $$EspeciesModelosTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $EspeciesModelosTable,
      EspecieModelo,
      $$EspeciesModelosTableFilterComposer,
      $$EspeciesModelosTableOrderingComposer,
      $$EspeciesModelosTableAnnotationComposer,
      $$EspeciesModelosTableCreateCompanionBuilder,
      $$EspeciesModelosTableUpdateCompanionBuilder,
      (EspecieModelo, $$EspeciesModelosTableReferences),
      EspecieModelo,
      PrefetchHooks Function({bool especieId, bool modeloMatematicoId})
    >;
typedef $$CoeficientesEspecieModeloTableCreateCompanionBuilder =
    CoeficientesEspecieModeloCompanion Function({
      Value<int> id,
      required int especieId,
      required int modeloMatematicoId,
      required String simbolo,
      required String rotulo,
      Value<double?> valor,
      required DateTime atualizadoEm,
    });
typedef $$CoeficientesEspecieModeloTableUpdateCompanionBuilder =
    CoeficientesEspecieModeloCompanion Function({
      Value<int> id,
      Value<int> especieId,
      Value<int> modeloMatematicoId,
      Value<String> simbolo,
      Value<String> rotulo,
      Value<double?> valor,
      Value<DateTime> atualizadoEm,
    });

final class $$CoeficientesEspecieModeloTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $CoeficientesEspecieModeloTable,
          CoeficienteEspecieModelo
        > {
  $$CoeficientesEspecieModeloTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EspeciesTable _especieIdTable(_$BancoDendro db) => db.especies
      .createAlias('coeficientes_especie_modelo__especie_id__especies__id');

  $$EspeciesTableProcessedTableManager get especieId {
    final $_column = $_itemColumn<int>('especie_id')!;

    final manager = $$EspeciesTableTableManager(
      $_db,
      $_db.especies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_especieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelosMatematicosTable _modeloMatematicoIdTable(
    _$BancoDendro db,
  ) => db.modelosMatematicos.createAlias(
    'coeficientes_especie_modelo__modelo_matematico_id__modelos_matematicos__id',
  );

  $$ModelosMatematicosTableProcessedTableManager get modeloMatematicoId {
    final $_column = $_itemColumn<int>('modelo_matematico_id')!;

    final manager = $$ModelosMatematicosTableTableManager(
      $_db,
      $_db.modelosMatematicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeloMatematicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CoeficientesEspecieModeloTableFilterComposer
    extends Composer<_$BancoDendro, $CoeficientesEspecieModeloTable> {
  $$CoeficientesEspecieModeloTableFilterComposer({
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

  ColumnFilters<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$EspeciesTableFilterComposer get especieId {
    final $$EspeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableFilterComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableFilterComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableFilterComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CoeficientesEspecieModeloTableOrderingComposer
    extends Composer<_$BancoDendro, $CoeficientesEspecieModeloTable> {
  $$CoeficientesEspecieModeloTableOrderingComposer({
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

  ColumnOrderings<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$EspeciesTableOrderingComposer get especieId {
    final $$EspeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableOrderingComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableOrderingComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableOrderingComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CoeficientesEspecieModeloTableAnnotationComposer
    extends Composer<_$BancoDendro, $CoeficientesEspecieModeloTable> {
  $$CoeficientesEspecieModeloTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get simbolo =>
      $composableBuilder(column: $table.simbolo, builder: (column) => column);

  GeneratedColumn<String> get rotulo =>
      $composableBuilder(column: $table.rotulo, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  $$EspeciesTableAnnotationComposer get especieId {
    final $$EspeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableAnnotationComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.modeloMatematicoId,
          referencedTable: $db.modelosMatematicos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModelosMatematicosTableAnnotationComposer(
                $db: $db,
                $table: $db.modelosMatematicos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CoeficientesEspecieModeloTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $CoeficientesEspecieModeloTable,
          CoeficienteEspecieModelo,
          $$CoeficientesEspecieModeloTableFilterComposer,
          $$CoeficientesEspecieModeloTableOrderingComposer,
          $$CoeficientesEspecieModeloTableAnnotationComposer,
          $$CoeficientesEspecieModeloTableCreateCompanionBuilder,
          $$CoeficientesEspecieModeloTableUpdateCompanionBuilder,
          (
            CoeficienteEspecieModelo,
            $$CoeficientesEspecieModeloTableReferences,
          ),
          CoeficienteEspecieModelo,
          PrefetchHooks Function({bool especieId, bool modeloMatematicoId})
        > {
  $$CoeficientesEspecieModeloTableTableManager(
    _$BancoDendro db,
    $CoeficientesEspecieModeloTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoeficientesEspecieModeloTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CoeficientesEspecieModeloTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CoeficientesEspecieModeloTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> especieId = const Value.absent(),
                Value<int> modeloMatematicoId = const Value.absent(),
                Value<String> simbolo = const Value.absent(),
                Value<String> rotulo = const Value.absent(),
                Value<double?> valor = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => CoeficientesEspecieModeloCompanion(
                id: id,
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int especieId,
                required int modeloMatematicoId,
                required String simbolo,
                required String rotulo,
                Value<double?> valor = const Value.absent(),
                required DateTime atualizadoEm,
              }) => CoeficientesEspecieModeloCompanion.insert(
                id: id,
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CoeficientesEspecieModeloTable,
                    CoeficienteEspecieModelo
                  >(table),
                  $$CoeficientesEspecieModeloTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({especieId = false, modeloMatematicoId = false}) {
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
                    if (especieId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.especieId,
                                referencedTable:
                                    $$CoeficientesEspecieModeloTableReferences
                                        ._especieIdTable(db),
                                referencedColumn:
                                    $$CoeficientesEspecieModeloTableReferences
                                        ._especieIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (modeloMatematicoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.modeloMatematicoId,
                                referencedTable:
                                    $$CoeficientesEspecieModeloTableReferences
                                        ._modeloMatematicoIdTable(db),
                                referencedColumn:
                                    $$CoeficientesEspecieModeloTableReferences
                                        ._modeloMatematicoIdTable(db)
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

typedef $$CoeficientesEspecieModeloTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $CoeficientesEspecieModeloTable,
      CoeficienteEspecieModelo,
      $$CoeficientesEspecieModeloTableFilterComposer,
      $$CoeficientesEspecieModeloTableOrderingComposer,
      $$CoeficientesEspecieModeloTableAnnotationComposer,
      $$CoeficientesEspecieModeloTableCreateCompanionBuilder,
      $$CoeficientesEspecieModeloTableUpdateCompanionBuilder,
      (CoeficienteEspecieModelo, $$CoeficientesEspecieModeloTableReferences),
      CoeficienteEspecieModelo,
      PrefetchHooks Function({bool especieId, bool modeloMatematicoId})
    >;
typedef $$TalhoesTableCreateCompanionBuilder =
    TalhoesCompanion Function({
      Value<int> id,
      required int propriedadeId,
      required String identificacao,
      required int especieId,
      required double areaHa,
      Value<int?> anoPlantio,
      Value<String?> espacamento,
      Value<String?> regimeManejo,
      Value<double?> larguraParcelaM,
      Value<double?> comprimentoParcelaM,
      Value<String?> observacoes,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$TalhoesTableUpdateCompanionBuilder =
    TalhoesCompanion Function({
      Value<int> id,
      Value<int> propriedadeId,
      Value<String> identificacao,
      Value<int> especieId,
      Value<double> areaHa,
      Value<int?> anoPlantio,
      Value<String?> espacamento,
      Value<String?> regimeManejo,
      Value<double?> larguraParcelaM,
      Value<double?> comprimentoParcelaM,
      Value<String?> observacoes,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$TalhoesTableReferences
    extends BaseReferences<_$BancoDendro, $TalhoesTable, Talhao> {
  $$TalhoesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropriedadesTable _propriedadeIdTable(_$BancoDendro db) =>
      db.propriedades.createAlias('talhoes__propriedade_id__propriedades__id');

  $$PropriedadesTableProcessedTableManager get propriedadeId {
    final $_column = $_itemColumn<int>('propriedade_id')!;

    final manager = $$PropriedadesTableTableManager(
      $_db,
      $_db.propriedades,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propriedadeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EspeciesTable _especieIdTable(_$BancoDendro db) =>
      db.especies.createAlias('talhoes__especie_id__especies__id');

  $$EspeciesTableProcessedTableManager get especieId {
    final $_column = $_itemColumn<int>('especie_id')!;

    final manager = $$EspeciesTableTableManager(
      $_db,
      $_db.especies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_especieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamento>
  >
  _talhaoLevantamentosRefsTable(_$BancoDendro db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'talhoes__id__talhao_levantamentos__talhao_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.talhaoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TalhoesTableFilterComposer
    extends Composer<_$BancoDendro, $TalhoesTable> {
  $$TalhoesTableFilterComposer({
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

  ColumnFilters<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anoPlantio => $composableBuilder(
    column: $table.anoPlantio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get espacamento => $composableBuilder(
    column: $table.espacamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regimeManejo => $composableBuilder(
    column: $table.regimeManejo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get larguraParcelaM => $composableBuilder(
    column: $table.larguraParcelaM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get comprimentoParcelaM => $composableBuilder(
    column: $table.comprimentoParcelaM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$PropriedadesTableFilterComposer get propriedadeId {
    final $$PropriedadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableFilterComposer(
            $db: $db,
            $table: $db.propriedades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableFilterComposer get especieId {
    final $$EspeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableFilterComposer(
            $db: $db,
            $table: $db.especies,
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
      getReferencedColumn: (t) => t.talhaoId,
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

class $$TalhoesTableOrderingComposer
    extends Composer<_$BancoDendro, $TalhoesTable> {
  $$TalhoesTableOrderingComposer({
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

  ColumnOrderings<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anoPlantio => $composableBuilder(
    column: $table.anoPlantio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get espacamento => $composableBuilder(
    column: $table.espacamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regimeManejo => $composableBuilder(
    column: $table.regimeManejo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get larguraParcelaM => $composableBuilder(
    column: $table.larguraParcelaM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get comprimentoParcelaM => $composableBuilder(
    column: $table.comprimentoParcelaM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropriedadesTableOrderingComposer get propriedadeId {
    final $$PropriedadesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableOrderingComposer(
            $db: $db,
            $table: $db.propriedades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableOrderingComposer get especieId {
    final $$EspeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableOrderingComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TalhoesTableAnnotationComposer
    extends Composer<_$BancoDendro, $TalhoesTable> {
  $$TalhoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaHa =>
      $composableBuilder(column: $table.areaHa, builder: (column) => column);

  GeneratedColumn<int> get anoPlantio => $composableBuilder(
    column: $table.anoPlantio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get espacamento => $composableBuilder(
    column: $table.espacamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get regimeManejo => $composableBuilder(
    column: $table.regimeManejo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get larguraParcelaM => $composableBuilder(
    column: $table.larguraParcelaM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get comprimentoParcelaM => $composableBuilder(
    column: $table.comprimentoParcelaM,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  $$PropriedadesTableAnnotationComposer get propriedadeId {
    final $$PropriedadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableAnnotationComposer(
            $db: $db,
            $table: $db.propriedades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableAnnotationComposer get especieId {
    final $$EspeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.especies,
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
          getReferencedColumn: (t) => t.talhaoId,
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

class $$TalhoesTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $TalhoesTable,
          Talhao,
          $$TalhoesTableFilterComposer,
          $$TalhoesTableOrderingComposer,
          $$TalhoesTableAnnotationComposer,
          $$TalhoesTableCreateCompanionBuilder,
          $$TalhoesTableUpdateCompanionBuilder,
          (Talhao, $$TalhoesTableReferences),
          Talhao,
          PrefetchHooks Function({
            bool propriedadeId,
            bool especieId,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$TalhoesTableTableManager(_$BancoDendro db, $TalhoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TalhoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TalhoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TalhoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> propriedadeId = const Value.absent(),
                Value<String> identificacao = const Value.absent(),
                Value<int> especieId = const Value.absent(),
                Value<double> areaHa = const Value.absent(),
                Value<int?> anoPlantio = const Value.absent(),
                Value<String?> espacamento = const Value.absent(),
                Value<String?> regimeManejo = const Value.absent(),
                Value<double?> larguraParcelaM = const Value.absent(),
                Value<double?> comprimentoParcelaM = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => TalhoesCompanion(
                id: id,
                propriedadeId: propriedadeId,
                identificacao: identificacao,
                especieId: especieId,
                areaHa: areaHa,
                anoPlantio: anoPlantio,
                espacamento: espacamento,
                regimeManejo: regimeManejo,
                larguraParcelaM: larguraParcelaM,
                comprimentoParcelaM: comprimentoParcelaM,
                observacoes: observacoes,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int propriedadeId,
                required String identificacao,
                required int especieId,
                required double areaHa,
                Value<int?> anoPlantio = const Value.absent(),
                Value<String?> espacamento = const Value.absent(),
                Value<String?> regimeManejo = const Value.absent(),
                Value<double?> larguraParcelaM = const Value.absent(),
                Value<double?> comprimentoParcelaM = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => TalhoesCompanion.insert(
                id: id,
                propriedadeId: propriedadeId,
                identificacao: identificacao,
                especieId: especieId,
                areaHa: areaHa,
                anoPlantio: anoPlantio,
                espacamento: espacamento,
                regimeManejo: regimeManejo,
                larguraParcelaM: larguraParcelaM,
                comprimentoParcelaM: comprimentoParcelaM,
                observacoes: observacoes,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TalhoesTable, Talhao>(table),
                  $$TalhoesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propriedadeId = false,
                especieId = false,
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
                        if (propriedadeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.propriedadeId,
                                    referencedTable: $$TalhoesTableReferences
                                        ._propriedadeIdTable(db),
                                    referencedColumn: $$TalhoesTableReferences
                                        ._propriedadeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (especieId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.especieId,
                                    referencedTable: $$TalhoesTableReferences
                                        ._especieIdTable(db),
                                    referencedColumn: $$TalhoesTableReferences
                                        ._especieIdTable(db)
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
                          Talhao,
                          $TalhoesTable,
                          TalhaoLevantamento
                        >(
                          currentTable: table,
                          referencedTable: $$TalhoesTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TalhoesTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.talhaoId == item.id,
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

typedef $$TalhoesTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $TalhoesTable,
      Talhao,
      $$TalhoesTableFilterComposer,
      $$TalhoesTableOrderingComposer,
      $$TalhoesTableAnnotationComposer,
      $$TalhoesTableCreateCompanionBuilder,
      $$TalhoesTableUpdateCompanionBuilder,
      (Talhao, $$TalhoesTableReferences),
      Talhao,
      PrefetchHooks Function({
        bool propriedadeId,
        bool especieId,
        bool talhaoLevantamentosRefs,
      })
    >;
typedef $$LevantamentosTableCreateCompanionBuilder =
    LevantamentosCompanion Function({
      Value<int> id,
      required int propriedadeId,
      required SituacaoLevantamento situacao,
      required DateTime iniciadoEm,
      required DateTime atualizadoEm,
      Value<DateTime?> concluidoEm,
    });
typedef $$LevantamentosTableUpdateCompanionBuilder =
    LevantamentosCompanion Function({
      Value<int> id,
      Value<int> propriedadeId,
      Value<SituacaoLevantamento> situacao,
      Value<DateTime> iniciadoEm,
      Value<DateTime> atualizadoEm,
      Value<DateTime?> concluidoEm,
    });

final class $$LevantamentosTableReferences
    extends BaseReferences<_$BancoDendro, $LevantamentosTable, Levantamento> {
  $$LevantamentosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PropriedadesTable _propriedadeIdTable(_$BancoDendro db) => db
      .propriedades
      .createAlias('levantamentos__propriedade_id__propriedades__id');

  $$PropriedadesTableProcessedTableManager get propriedadeId {
    final $_column = $_itemColumn<int>('propriedade_id')!;

    final manager = $$PropriedadesTableTableManager(
      $_db,
      $_db.propriedades,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propriedadeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TalhaoLevantamentosTable,
    List<TalhaoLevantamento>
  >
  _talhaoLevantamentosRefsTable(_$BancoDendro db) =>
      MultiTypedResultKey.fromTable(
        db.talhaoLevantamentos,
        aliasName: 'levantamentos__id__talhao_levantamentos__levantamento_id',
      );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentosRefs {
    final manager = $$TalhaoLevantamentosTableTableManager(
      $_db,
      $_db.talhaoLevantamentos,
    ).filter((f) => f.levantamentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _talhaoLevantamentosRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LevantamentosTableFilterComposer
    extends Composer<_$BancoDendro, $LevantamentosTable> {
  $$LevantamentosTableFilterComposer({
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

  ColumnWithTypeConverterFilters<
    SituacaoLevantamento,
    SituacaoLevantamento,
    String
  >
  get situacao => $composableBuilder(
    column: $table.situacao,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get concluidoEm => $composableBuilder(
    column: $table.concluidoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$PropriedadesTableFilterComposer get propriedadeId {
    final $$PropriedadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableFilterComposer(
            $db: $db,
            $table: $db.propriedades,
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
      getReferencedColumn: (t) => t.levantamentoId,
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

class $$LevantamentosTableOrderingComposer
    extends Composer<_$BancoDendro, $LevantamentosTable> {
  $$LevantamentosTableOrderingComposer({
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

  ColumnOrderings<String> get situacao => $composableBuilder(
    column: $table.situacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get concluidoEm => $composableBuilder(
    column: $table.concluidoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropriedadesTableOrderingComposer get propriedadeId {
    final $$PropriedadesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableOrderingComposer(
            $db: $db,
            $table: $db.propriedades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LevantamentosTableAnnotationComposer
    extends Composer<_$BancoDendro, $LevantamentosTable> {
  $$LevantamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SituacaoLevantamento, String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => column);

  GeneratedColumn<DateTime> get iniciadoEm => $composableBuilder(
    column: $table.iniciadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get concluidoEm => $composableBuilder(
    column: $table.concluidoEm,
    builder: (column) => column,
  );

  $$PropriedadesTableAnnotationComposer get propriedadeId {
    final $$PropriedadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propriedadeId,
      referencedTable: $db.propriedades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropriedadesTableAnnotationComposer(
            $db: $db,
            $table: $db.propriedades,
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
          getReferencedColumn: (t) => t.levantamentoId,
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

class $$LevantamentosTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $LevantamentosTable,
          Levantamento,
          $$LevantamentosTableFilterComposer,
          $$LevantamentosTableOrderingComposer,
          $$LevantamentosTableAnnotationComposer,
          $$LevantamentosTableCreateCompanionBuilder,
          $$LevantamentosTableUpdateCompanionBuilder,
          (Levantamento, $$LevantamentosTableReferences),
          Levantamento,
          PrefetchHooks Function({
            bool propriedadeId,
            bool talhaoLevantamentosRefs,
          })
        > {
  $$LevantamentosTableTableManager(_$BancoDendro db, $LevantamentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevantamentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevantamentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevantamentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> propriedadeId = const Value.absent(),
                Value<SituacaoLevantamento> situacao = const Value.absent(),
                Value<DateTime> iniciadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
                Value<DateTime?> concluidoEm = const Value.absent(),
              }) => LevantamentosCompanion(
                id: id,
                propriedadeId: propriedadeId,
                situacao: situacao,
                iniciadoEm: iniciadoEm,
                atualizadoEm: atualizadoEm,
                concluidoEm: concluidoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int propriedadeId,
                required SituacaoLevantamento situacao,
                required DateTime iniciadoEm,
                required DateTime atualizadoEm,
                Value<DateTime?> concluidoEm = const Value.absent(),
              }) => LevantamentosCompanion.insert(
                id: id,
                propriedadeId: propriedadeId,
                situacao: situacao,
                iniciadoEm: iniciadoEm,
                atualizadoEm: atualizadoEm,
                concluidoEm: concluidoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevantamentosTable, Levantamento>(table),
                  $$LevantamentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({propriedadeId = false, talhaoLevantamentosRefs = false}) {
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
                        if (propriedadeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.propriedadeId,
                                    referencedTable:
                                        $$LevantamentosTableReferences
                                            ._propriedadeIdTable(db),
                                    referencedColumn:
                                        $$LevantamentosTableReferences
                                            ._propriedadeIdTable(db)
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
                          Levantamento,
                          $LevantamentosTable,
                          TalhaoLevantamento
                        >(
                          currentTable: table,
                          referencedTable: $$LevantamentosTableReferences
                              ._talhaoLevantamentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LevantamentosTableReferences(
                                db,
                                table,
                                p0,
                              ).talhaoLevantamentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.levantamentoId == item.id,
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

typedef $$LevantamentosTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $LevantamentosTable,
      Levantamento,
      $$LevantamentosTableFilterComposer,
      $$LevantamentosTableOrderingComposer,
      $$LevantamentosTableAnnotationComposer,
      $$LevantamentosTableCreateCompanionBuilder,
      $$LevantamentosTableUpdateCompanionBuilder,
      (Levantamento, $$LevantamentosTableReferences),
      Levantamento,
      PrefetchHooks Function({bool propriedadeId, bool talhaoLevantamentosRefs})
    >;
typedef $$TalhaoLevantamentosTableCreateCompanionBuilder =
    TalhaoLevantamentosCompanion Function({
      Value<int> id,
      required int levantamentoId,
      required int talhaoId,
      required int especieId,
      required int modeloMatematicoId,
      Value<double?> areaPadraoParcelaHa,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$TalhaoLevantamentosTableUpdateCompanionBuilder =
    TalhaoLevantamentosCompanion Function({
      Value<int> id,
      Value<int> levantamentoId,
      Value<int> talhaoId,
      Value<int> especieId,
      Value<int> modeloMatematicoId,
      Value<double?> areaPadraoParcelaHa,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$TalhaoLevantamentosTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $TalhaoLevantamentosTable,
          TalhaoLevantamento
        > {
  $$TalhaoLevantamentosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LevantamentosTable _levantamentoIdTable(_$BancoDendro db) => db
      .levantamentos
      .createAlias('talhao_levantamentos__levantamento_id__levantamentos__id');

  $$LevantamentosTableProcessedTableManager get levantamentoId {
    final $_column = $_itemColumn<int>('levantamento_id')!;

    final manager = $$LevantamentosTableTableManager(
      $_db,
      $_db.levantamentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_levantamentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TalhoesTable _talhaoIdTable(_$BancoDendro db) =>
      db.talhoes.createAlias('talhao_levantamentos__talhao_id__talhoes__id');

  $$TalhoesTableProcessedTableManager get talhaoId {
    final $_column = $_itemColumn<int>('talhao_id')!;

    final manager = $$TalhoesTableTableManager(
      $_db,
      $_db.talhoes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_talhaoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EspeciesTable _especieIdTable(_$BancoDendro db) =>
      db.especies.createAlias('talhao_levantamentos__especie_id__especies__id');

  $$EspeciesTableProcessedTableManager get especieId {
    final $_column = $_itemColumn<int>('especie_id')!;

    final manager = $$EspeciesTableTableManager(
      $_db,
      $_db.especies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_especieIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ModelosMatematicosTable _modeloMatematicoIdTable(_$BancoDendro db) =>
      db.modelosMatematicos.createAlias(
        'talhao_levantamentos__modelo_matematico_id__modelos_matematicos__id',
      );

  $$ModelosMatematicosTableProcessedTableManager get modeloMatematicoId {
    final $_column = $_itemColumn<int>('modelo_matematico_id')!;

    final manager = $$ModelosMatematicosTableTableManager(
      $_db,
      $_db.modelosMatematicos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_modeloMatematicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $CoeficientesTalhaoLevantamentoTable,
    List<CoeficienteTalhaoLevantamento>
  >
  _coeficientesTalhaoLevantamentoRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.coeficientesTalhaoLevantamento,
    aliasName:
        'talhao_levantamentos__id__coeficientes_talhao_levantamento__talhao_levantamento_id',
  );

  $$CoeficientesTalhaoLevantamentoTableProcessedTableManager
  get coeficientesTalhaoLevantamentoRefs {
    final manager =
        $$CoeficientesTalhaoLevantamentoTableTableManager(
          $_db,
          $_db.coeficientesTalhaoLevantamento,
        ).filter(
          (f) => f.talhaoLevantamentoId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _coeficientesTalhaoLevantamentoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ParcelasTable, List<Parcela>> _parcelasRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.parcelas,
    aliasName: 'talhao_levantamentos__id__parcelas__talhao_levantamento_id',
  );

  $$ParcelasTableProcessedTableManager get parcelasRefs {
    final manager = $$ParcelasTableTableManager($_db, $_db.parcelas).filter(
      (f) => f.talhaoLevantamentoId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_parcelasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TalhaoLevantamentosTableFilterComposer
    extends Composer<_$BancoDendro, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableFilterComposer({
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

  ColumnFilters<double> get areaPadraoParcelaHa => $composableBuilder(
    column: $table.areaPadraoParcelaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$LevantamentosTableFilterComposer get levantamentoId {
    final $$LevantamentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levantamentoId,
      referencedTable: $db.levantamentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevantamentosTableFilterComposer(
            $db: $db,
            $table: $db.levantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TalhoesTableFilterComposer get talhaoId {
    final $$TalhoesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talhaoId,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableFilterComposer(
            $db: $db,
            $table: $db.talhoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableFilterComposer get especieId {
    final $$EspeciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableFilterComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableFilterComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableFilterComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> coeficientesTalhaoLevantamentoRefs(
    Expression<bool> Function(
      $$CoeficientesTalhaoLevantamentoTableFilterComposer f,
    )
    f,
  ) {
    final $$CoeficientesTalhaoLevantamentoTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesTalhaoLevantamento,
          getReferencedColumn: (t) => t.talhaoLevantamentoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesTalhaoLevantamentoTableFilterComposer(
                $db: $db,
                $table: $db.coeficientesTalhaoLevantamento,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> parcelasRefs(
    Expression<bool> Function($$ParcelasTableFilterComposer f) f,
  ) {
    final $$ParcelasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.talhaoLevantamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableFilterComposer(
            $db: $db,
            $table: $db.parcelas,
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
    extends Composer<_$BancoDendro, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableOrderingComposer({
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

  ColumnOrderings<double> get areaPadraoParcelaHa => $composableBuilder(
    column: $table.areaPadraoParcelaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$LevantamentosTableOrderingComposer get levantamentoId {
    final $$LevantamentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levantamentoId,
      referencedTable: $db.levantamentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevantamentosTableOrderingComposer(
            $db: $db,
            $table: $db.levantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TalhoesTableOrderingComposer get talhaoId {
    final $$TalhoesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talhaoId,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableOrderingComposer(
            $db: $db,
            $table: $db.talhoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableOrderingComposer get especieId {
    final $$EspeciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableOrderingComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableOrderingComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.modeloMatematicoId,
      referencedTable: $db.modelosMatematicos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ModelosMatematicosTableOrderingComposer(
            $db: $db,
            $table: $db.modelosMatematicos,
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
    extends Composer<_$BancoDendro, $TalhaoLevantamentosTable> {
  $$TalhaoLevantamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get areaPadraoParcelaHa => $composableBuilder(
    column: $table.areaPadraoParcelaHa,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  $$LevantamentosTableAnnotationComposer get levantamentoId {
    final $$LevantamentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.levantamentoId,
      referencedTable: $db.levantamentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LevantamentosTableAnnotationComposer(
            $db: $db,
            $table: $db.levantamentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TalhoesTableAnnotationComposer get talhaoId {
    final $$TalhoesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talhaoId,
      referencedTable: $db.talhoes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalhoesTableAnnotationComposer(
            $db: $db,
            $table: $db.talhoes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EspeciesTableAnnotationComposer get especieId {
    final $$EspeciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.especieId,
      referencedTable: $db.especies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EspeciesTableAnnotationComposer(
            $db: $db,
            $table: $db.especies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ModelosMatematicosTableAnnotationComposer get modeloMatematicoId {
    final $$ModelosMatematicosTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.modeloMatematicoId,
          referencedTable: $db.modelosMatematicos,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ModelosMatematicosTableAnnotationComposer(
                $db: $db,
                $table: $db.modelosMatematicos,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> coeficientesTalhaoLevantamentoRefs<T extends Object>(
    Expression<T> Function(
      $$CoeficientesTalhaoLevantamentoTableAnnotationComposer a,
    )
    f,
  ) {
    final $$CoeficientesTalhaoLevantamentoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.coeficientesTalhaoLevantamento,
          getReferencedColumn: (t) => t.talhaoLevantamentoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CoeficientesTalhaoLevantamentoTableAnnotationComposer(
                $db: $db,
                $table: $db.coeficientesTalhaoLevantamento,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> parcelasRefs<T extends Object>(
    Expression<T> Function($$ParcelasTableAnnotationComposer a) f,
  ) {
    final $$ParcelasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.talhaoLevantamentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableAnnotationComposer(
            $db: $db,
            $table: $db.parcelas,
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
          _$BancoDendro,
          $TalhaoLevantamentosTable,
          TalhaoLevantamento,
          $$TalhaoLevantamentosTableFilterComposer,
          $$TalhaoLevantamentosTableOrderingComposer,
          $$TalhaoLevantamentosTableAnnotationComposer,
          $$TalhaoLevantamentosTableCreateCompanionBuilder,
          $$TalhaoLevantamentosTableUpdateCompanionBuilder,
          (TalhaoLevantamento, $$TalhaoLevantamentosTableReferences),
          TalhaoLevantamento,
          PrefetchHooks Function({
            bool levantamentoId,
            bool talhaoId,
            bool especieId,
            bool modeloMatematicoId,
            bool coeficientesTalhaoLevantamentoRefs,
            bool parcelasRefs,
          })
        > {
  $$TalhaoLevantamentosTableTableManager(
    _$BancoDendro db,
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
                Value<int> id = const Value.absent(),
                Value<int> levantamentoId = const Value.absent(),
                Value<int> talhaoId = const Value.absent(),
                Value<int> especieId = const Value.absent(),
                Value<int> modeloMatematicoId = const Value.absent(),
                Value<double?> areaPadraoParcelaHa = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => TalhaoLevantamentosCompanion(
                id: id,
                levantamentoId: levantamentoId,
                talhaoId: talhaoId,
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                areaPadraoParcelaHa: areaPadraoParcelaHa,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int levantamentoId,
                required int talhaoId,
                required int especieId,
                required int modeloMatematicoId,
                Value<double?> areaPadraoParcelaHa = const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => TalhaoLevantamentosCompanion.insert(
                id: id,
                levantamentoId: levantamentoId,
                talhaoId: talhaoId,
                especieId: especieId,
                modeloMatematicoId: modeloMatematicoId,
                areaPadraoParcelaHa: areaPadraoParcelaHa,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TalhaoLevantamentosTable, TalhaoLevantamento>(
                    table,
                  ),
                  $$TalhaoLevantamentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                levantamentoId = false,
                talhaoId = false,
                especieId = false,
                modeloMatematicoId = false,
                coeficientesTalhaoLevantamentoRefs = false,
                parcelasRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (coeficientesTalhaoLevantamentoRefs)
                      db.coeficientesTalhaoLevantamento,
                    if (parcelasRefs) db.parcelas,
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
                        if (levantamentoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.levantamentoId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._levantamentoIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._levantamentoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (talhaoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.talhaoId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._talhaoIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._talhaoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (especieId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.especieId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._especieIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._especieIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (modeloMatematicoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.modeloMatematicoId,
                                    referencedTable:
                                        $$TalhaoLevantamentosTableReferences
                                            ._modeloMatematicoIdTable(db),
                                    referencedColumn:
                                        $$TalhaoLevantamentosTableReferences
                                            ._modeloMatematicoIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (coeficientesTalhaoLevantamentoRefs)
                        await $_getPrefetchedData<
                          TalhaoLevantamento,
                          $TalhaoLevantamentosTable,
                          CoeficienteTalhaoLevantamento
                        >(
                          currentTable: table,
                          referencedTable: $$TalhaoLevantamentosTableReferences
                              ._coeficientesTalhaoLevantamentoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TalhaoLevantamentosTableReferences(
                                db,
                                table,
                                p0,
                              ).coeficientesTalhaoLevantamentoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.talhaoLevantamentoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (parcelasRefs)
                        await $_getPrefetchedData<
                          TalhaoLevantamento,
                          $TalhaoLevantamentosTable,
                          Parcela
                        >(
                          currentTable: table,
                          referencedTable: $$TalhaoLevantamentosTableReferences
                              ._parcelasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TalhaoLevantamentosTableReferences(
                                db,
                                table,
                                p0,
                              ).parcelasRefs,
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
      _$BancoDendro,
      $TalhaoLevantamentosTable,
      TalhaoLevantamento,
      $$TalhaoLevantamentosTableFilterComposer,
      $$TalhaoLevantamentosTableOrderingComposer,
      $$TalhaoLevantamentosTableAnnotationComposer,
      $$TalhaoLevantamentosTableCreateCompanionBuilder,
      $$TalhaoLevantamentosTableUpdateCompanionBuilder,
      (TalhaoLevantamento, $$TalhaoLevantamentosTableReferences),
      TalhaoLevantamento,
      PrefetchHooks Function({
        bool levantamentoId,
        bool talhaoId,
        bool especieId,
        bool modeloMatematicoId,
        bool coeficientesTalhaoLevantamentoRefs,
        bool parcelasRefs,
      })
    >;
typedef $$CoeficientesTalhaoLevantamentoTableCreateCompanionBuilder =
    CoeficientesTalhaoLevantamentoCompanion Function({
      Value<int> id,
      required int talhaoLevantamentoId,
      required String simbolo,
      required String rotulo,
      Value<double?> valor,
    });
typedef $$CoeficientesTalhaoLevantamentoTableUpdateCompanionBuilder =
    CoeficientesTalhaoLevantamentoCompanion Function({
      Value<int> id,
      Value<int> talhaoLevantamentoId,
      Value<String> simbolo,
      Value<String> rotulo,
      Value<double?> valor,
    });

final class $$CoeficientesTalhaoLevantamentoTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $CoeficientesTalhaoLevantamentoTable,
          CoeficienteTalhaoLevantamento
        > {
  $$CoeficientesTalhaoLevantamentoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TalhaoLevantamentosTable _talhaoLevantamentoIdTable(
    _$BancoDendro db,
  ) => db.talhaoLevantamentos.createAlias(
    'coeficientes_talhao_levantamento__talhao_levantamento_id__talhao_levantamentos__id',
  );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentoId {
    final $_column = $_itemColumn<int>('talhao_levantamento_id')!;

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
}

class $$CoeficientesTalhaoLevantamentoTableFilterComposer
    extends Composer<_$BancoDendro, $CoeficientesTalhaoLevantamentoTable> {
  $$CoeficientesTalhaoLevantamentoTableFilterComposer({
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

  ColumnFilters<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
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
}

class $$CoeficientesTalhaoLevantamentoTableOrderingComposer
    extends Composer<_$BancoDendro, $CoeficientesTalhaoLevantamentoTable> {
  $$CoeficientesTalhaoLevantamentoTableOrderingComposer({
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

  ColumnOrderings<String> get simbolo => $composableBuilder(
    column: $table.simbolo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rotulo => $composableBuilder(
    column: $table.rotulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
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

class $$CoeficientesTalhaoLevantamentoTableAnnotationComposer
    extends Composer<_$BancoDendro, $CoeficientesTalhaoLevantamentoTable> {
  $$CoeficientesTalhaoLevantamentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get simbolo =>
      $composableBuilder(column: $table.simbolo, builder: (column) => column);

  GeneratedColumn<String> get rotulo =>
      $composableBuilder(column: $table.rotulo, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

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
}

class $$CoeficientesTalhaoLevantamentoTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $CoeficientesTalhaoLevantamentoTable,
          CoeficienteTalhaoLevantamento,
          $$CoeficientesTalhaoLevantamentoTableFilterComposer,
          $$CoeficientesTalhaoLevantamentoTableOrderingComposer,
          $$CoeficientesTalhaoLevantamentoTableAnnotationComposer,
          $$CoeficientesTalhaoLevantamentoTableCreateCompanionBuilder,
          $$CoeficientesTalhaoLevantamentoTableUpdateCompanionBuilder,
          (
            CoeficienteTalhaoLevantamento,
            $$CoeficientesTalhaoLevantamentoTableReferences,
          ),
          CoeficienteTalhaoLevantamento,
          PrefetchHooks Function({bool talhaoLevantamentoId})
        > {
  $$CoeficientesTalhaoLevantamentoTableTableManager(
    _$BancoDendro db,
    $CoeficientesTalhaoLevantamentoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoeficientesTalhaoLevantamentoTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CoeficientesTalhaoLevantamentoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CoeficientesTalhaoLevantamentoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> talhaoLevantamentoId = const Value.absent(),
                Value<String> simbolo = const Value.absent(),
                Value<String> rotulo = const Value.absent(),
                Value<double?> valor = const Value.absent(),
              }) => CoeficientesTalhaoLevantamentoCompanion(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int talhaoLevantamentoId,
                required String simbolo,
                required String rotulo,
                Value<double?> valor = const Value.absent(),
              }) => CoeficientesTalhaoLevantamentoCompanion.insert(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                simbolo: simbolo,
                rotulo: rotulo,
                valor: valor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CoeficientesTalhaoLevantamentoTable,
                    CoeficienteTalhaoLevantamento
                  >(table),
                  $$CoeficientesTalhaoLevantamentoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({talhaoLevantamentoId = false}) {
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
                    if (talhaoLevantamentoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.talhaoLevantamentoId,
                                referencedTable:
                                    $$CoeficientesTalhaoLevantamentoTableReferences
                                        ._talhaoLevantamentoIdTable(db),
                                referencedColumn:
                                    $$CoeficientesTalhaoLevantamentoTableReferences
                                        ._talhaoLevantamentoIdTable(db)
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

typedef $$CoeficientesTalhaoLevantamentoTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $CoeficientesTalhaoLevantamentoTable,
      CoeficienteTalhaoLevantamento,
      $$CoeficientesTalhaoLevantamentoTableFilterComposer,
      $$CoeficientesTalhaoLevantamentoTableOrderingComposer,
      $$CoeficientesTalhaoLevantamentoTableAnnotationComposer,
      $$CoeficientesTalhaoLevantamentoTableCreateCompanionBuilder,
      $$CoeficientesTalhaoLevantamentoTableUpdateCompanionBuilder,
      (
        CoeficienteTalhaoLevantamento,
        $$CoeficientesTalhaoLevantamentoTableReferences,
      ),
      CoeficienteTalhaoLevantamento,
      PrefetchHooks Function({bool talhaoLevantamentoId})
    >;
typedef $$ParcelasTableCreateCompanionBuilder =
    ParcelasCompanion Function({
      Value<int> id,
      required int talhaoLevantamentoId,
      required String identificacao,
      required SituacaoParcela situacao,
      Value<double?> areaHa,
      Value<PosicaoReferenciaParcela?> posicaoReferencia,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$ParcelasTableUpdateCompanionBuilder =
    ParcelasCompanion Function({
      Value<int> id,
      Value<int> talhaoLevantamentoId,
      Value<String> identificacao,
      Value<SituacaoParcela> situacao,
      Value<double?> areaHa,
      Value<PosicaoReferenciaParcela?> posicaoReferencia,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$ParcelasTableReferences
    extends BaseReferences<_$BancoDendro, $ParcelasTable, Parcela> {
  $$ParcelasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TalhaoLevantamentosTable _talhaoLevantamentoIdTable(
    _$BancoDendro db,
  ) => db.talhaoLevantamentos.createAlias(
    'parcelas__talhao_levantamento_id__talhao_levantamentos__id',
  );

  $$TalhaoLevantamentosTableProcessedTableManager get talhaoLevantamentoId {
    final $_column = $_itemColumn<int>('talhao_levantamento_id')!;

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

  static MultiTypedResultKey<
    $PontosGeograficosParcelaTable,
    List<PontoGeograficoParcela>
  >
  _pontosGeograficosParcelaRefsTable(_$BancoDendro db) =>
      MultiTypedResultKey.fromTable(
        db.pontosGeograficosParcela,
        aliasName: 'parcelas__id__pontos_geograficos_parcela__parcela_id',
      );

  $$PontosGeograficosParcelaTableProcessedTableManager
  get pontosGeograficosParcelaRefs {
    final manager = $$PontosGeograficosParcelaTableTableManager(
      $_db,
      $_db.pontosGeograficosParcela,
    ).filter((f) => f.parcelaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pontosGeograficosParcelaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ArvoresTable, List<Arvore>> _arvoresRefsTable(
    _$BancoDendro db,
  ) => MultiTypedResultKey.fromTable(
    db.arvores,
    aliasName: 'parcelas__id__arvores__parcela_id',
  );

  $$ArvoresTableProcessedTableManager get arvoresRefs {
    final manager = $$ArvoresTableTableManager(
      $_db,
      $_db.arvores,
    ).filter((f) => f.parcelaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_arvoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ParcelasTableFilterComposer
    extends Composer<_$BancoDendro, $ParcelasTable> {
  $$ParcelasTableFilterComposer({
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

  ColumnFilters<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SituacaoParcela, SituacaoParcela, String>
  get situacao => $composableBuilder(
    column: $table.situacao,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PosicaoReferenciaParcela?,
    PosicaoReferenciaParcela,
    String
  >
  get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
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

  Expression<bool> pontosGeograficosParcelaRefs(
    Expression<bool> Function($$PontosGeograficosParcelaTableFilterComposer f)
    f,
  ) {
    final $$PontosGeograficosParcelaTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pontosGeograficosParcela,
          getReferencedColumn: (t) => t.parcelaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PontosGeograficosParcelaTableFilterComposer(
                $db: $db,
                $table: $db.pontosGeograficosParcela,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> arvoresRefs(
    Expression<bool> Function($$ArvoresTableFilterComposer f) f,
  ) {
    final $$ArvoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.arvores,
      getReferencedColumn: (t) => t.parcelaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArvoresTableFilterComposer(
            $db: $db,
            $table: $db.arvores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParcelasTableOrderingComposer
    extends Composer<_$BancoDendro, $ParcelasTable> {
  $$ParcelasTableOrderingComposer({
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

  ColumnOrderings<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get situacao => $composableBuilder(
    column: $table.situacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaHa => $composableBuilder(
    column: $table.areaHa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
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

class $$ParcelasTableAnnotationComposer
    extends Composer<_$BancoDendro, $ParcelasTable> {
  $$ParcelasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get identificacao => $composableBuilder(
    column: $table.identificacao,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SituacaoParcela, String> get situacao =>
      $composableBuilder(column: $table.situacao, builder: (column) => column);

  GeneratedColumn<double> get areaHa =>
      $composableBuilder(column: $table.areaHa, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

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

  Expression<T> pontosGeograficosParcelaRefs<T extends Object>(
    Expression<T> Function($$PontosGeograficosParcelaTableAnnotationComposer a)
    f,
  ) {
    final $$PontosGeograficosParcelaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pontosGeograficosParcela,
          getReferencedColumn: (t) => t.parcelaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PontosGeograficosParcelaTableAnnotationComposer(
                $db: $db,
                $table: $db.pontosGeograficosParcela,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> arvoresRefs<T extends Object>(
    Expression<T> Function($$ArvoresTableAnnotationComposer a) f,
  ) {
    final $$ArvoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.arvores,
      getReferencedColumn: (t) => t.parcelaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArvoresTableAnnotationComposer(
            $db: $db,
            $table: $db.arvores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParcelasTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $ParcelasTable,
          Parcela,
          $$ParcelasTableFilterComposer,
          $$ParcelasTableOrderingComposer,
          $$ParcelasTableAnnotationComposer,
          $$ParcelasTableCreateCompanionBuilder,
          $$ParcelasTableUpdateCompanionBuilder,
          (Parcela, $$ParcelasTableReferences),
          Parcela,
          PrefetchHooks Function({
            bool talhaoLevantamentoId,
            bool pontosGeograficosParcelaRefs,
            bool arvoresRefs,
          })
        > {
  $$ParcelasTableTableManager(_$BancoDendro db, $ParcelasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParcelasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParcelasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParcelasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> talhaoLevantamentoId = const Value.absent(),
                Value<String> identificacao = const Value.absent(),
                Value<SituacaoParcela> situacao = const Value.absent(),
                Value<double?> areaHa = const Value.absent(),
                Value<PosicaoReferenciaParcela?> posicaoReferencia =
                    const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => ParcelasCompanion(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                identificacao: identificacao,
                situacao: situacao,
                areaHa: areaHa,
                posicaoReferencia: posicaoReferencia,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int talhaoLevantamentoId,
                required String identificacao,
                required SituacaoParcela situacao,
                Value<double?> areaHa = const Value.absent(),
                Value<PosicaoReferenciaParcela?> posicaoReferencia =
                    const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => ParcelasCompanion.insert(
                id: id,
                talhaoLevantamentoId: talhaoLevantamentoId,
                identificacao: identificacao,
                situacao: situacao,
                areaHa: areaHa,
                posicaoReferencia: posicaoReferencia,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParcelasTable, Parcela>(table),
                  $$ParcelasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                talhaoLevantamentoId = false,
                pontosGeograficosParcelaRefs = false,
                arvoresRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pontosGeograficosParcelaRefs)
                      db.pontosGeograficosParcela,
                    if (arvoresRefs) db.arvores,
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
                                    referencedTable: $$ParcelasTableReferences
                                        ._talhaoLevantamentoIdTable(db),
                                    referencedColumn: $$ParcelasTableReferences
                                        ._talhaoLevantamentoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pontosGeograficosParcelaRefs)
                        await $_getPrefetchedData<
                          Parcela,
                          $ParcelasTable,
                          PontoGeograficoParcela
                        >(
                          currentTable: table,
                          referencedTable: $$ParcelasTableReferences
                              ._pontosGeograficosParcelaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParcelasTableReferences(
                                db,
                                table,
                                p0,
                              ).pontosGeograficosParcelaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.parcelaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (arvoresRefs)
                        await $_getPrefetchedData<
                          Parcela,
                          $ParcelasTable,
                          Arvore
                        >(
                          currentTable: table,
                          referencedTable: $$ParcelasTableReferences
                              ._arvoresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParcelasTableReferences(
                                db,
                                table,
                                p0,
                              ).arvoresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.parcelaId == item.id,
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

typedef $$ParcelasTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $ParcelasTable,
      Parcela,
      $$ParcelasTableFilterComposer,
      $$ParcelasTableOrderingComposer,
      $$ParcelasTableAnnotationComposer,
      $$ParcelasTableCreateCompanionBuilder,
      $$ParcelasTableUpdateCompanionBuilder,
      (Parcela, $$ParcelasTableReferences),
      Parcela,
      PrefetchHooks Function({
        bool talhaoLevantamentoId,
        bool pontosGeograficosParcelaRefs,
        bool arvoresRefs,
      })
    >;
typedef $$PontosGeograficosParcelaTableCreateCompanionBuilder =
    PontosGeograficosParcelaCompanion Function({
      Value<int> id,
      required int parcelaId,
      required int ordemPonto,
      Value<PosicaoReferenciaParcela?> posicaoReferencia,
      required double latitude,
      required double longitude,
      Value<double?> precisaoMetros,
      required DateTime capturadoEm,
    });
typedef $$PontosGeograficosParcelaTableUpdateCompanionBuilder =
    PontosGeograficosParcelaCompanion Function({
      Value<int> id,
      Value<int> parcelaId,
      Value<int> ordemPonto,
      Value<PosicaoReferenciaParcela?> posicaoReferencia,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> precisaoMetros,
      Value<DateTime> capturadoEm,
    });

final class $$PontosGeograficosParcelaTableReferences
    extends
        BaseReferences<
          _$BancoDendro,
          $PontosGeograficosParcelaTable,
          PontoGeograficoParcela
        > {
  $$PontosGeograficosParcelaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ParcelasTable _parcelaIdTable(_$BancoDendro db) => db.parcelas
      .createAlias('pontos_geograficos_parcela__parcela_id__parcelas__id');

  $$ParcelasTableProcessedTableManager get parcelaId {
    final $_column = $_itemColumn<int>('parcela_id')!;

    final manager = $$ParcelasTableTableManager(
      $_db,
      $_db.parcelas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parcelaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PontosGeograficosParcelaTableFilterComposer
    extends Composer<_$BancoDendro, $PontosGeograficosParcelaTable> {
  $$PontosGeograficosParcelaTableFilterComposer({
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

  ColumnFilters<int> get ordemPonto => $composableBuilder(
    column: $table.ordemPonto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PosicaoReferenciaParcela?,
    PosicaoReferenciaParcela,
    String
  >
  get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
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

  ColumnFilters<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturadoEm => $composableBuilder(
    column: $table.capturadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ParcelasTableFilterComposer get parcelaId {
    final $$ParcelasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableFilterComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PontosGeograficosParcelaTableOrderingComposer
    extends Composer<_$BancoDendro, $PontosGeograficosParcelaTable> {
  $$PontosGeograficosParcelaTableOrderingComposer({
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

  ColumnOrderings<int> get ordemPonto => $composableBuilder(
    column: $table.ordemPonto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
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

  ColumnOrderings<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturadoEm => $composableBuilder(
    column: $table.capturadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ParcelasTableOrderingComposer get parcelaId {
    final $$ParcelasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableOrderingComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PontosGeograficosParcelaTableAnnotationComposer
    extends Composer<_$BancoDendro, $PontosGeograficosParcelaTable> {
  $$PontosGeograficosParcelaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ordemPonto => $composableBuilder(
    column: $table.ordemPonto,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  get posicaoReferencia => $composableBuilder(
    column: $table.posicaoReferencia,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get capturadoEm => $composableBuilder(
    column: $table.capturadoEm,
    builder: (column) => column,
  );

  $$ParcelasTableAnnotationComposer get parcelaId {
    final $$ParcelasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableAnnotationComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PontosGeograficosParcelaTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $PontosGeograficosParcelaTable,
          PontoGeograficoParcela,
          $$PontosGeograficosParcelaTableFilterComposer,
          $$PontosGeograficosParcelaTableOrderingComposer,
          $$PontosGeograficosParcelaTableAnnotationComposer,
          $$PontosGeograficosParcelaTableCreateCompanionBuilder,
          $$PontosGeograficosParcelaTableUpdateCompanionBuilder,
          (PontoGeograficoParcela, $$PontosGeograficosParcelaTableReferences),
          PontoGeograficoParcela,
          PrefetchHooks Function({bool parcelaId})
        > {
  $$PontosGeograficosParcelaTableTableManager(
    _$BancoDendro db,
    $PontosGeograficosParcelaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PontosGeograficosParcelaTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PontosGeograficosParcelaTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PontosGeograficosParcelaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parcelaId = const Value.absent(),
                Value<int> ordemPonto = const Value.absent(),
                Value<PosicaoReferenciaParcela?> posicaoReferencia =
                    const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> precisaoMetros = const Value.absent(),
                Value<DateTime> capturadoEm = const Value.absent(),
              }) => PontosGeograficosParcelaCompanion(
                id: id,
                parcelaId: parcelaId,
                ordemPonto: ordemPonto,
                posicaoReferencia: posicaoReferencia,
                latitude: latitude,
                longitude: longitude,
                precisaoMetros: precisaoMetros,
                capturadoEm: capturadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parcelaId,
                required int ordemPonto,
                Value<PosicaoReferenciaParcela?> posicaoReferencia =
                    const Value.absent(),
                required double latitude,
                required double longitude,
                Value<double?> precisaoMetros = const Value.absent(),
                required DateTime capturadoEm,
              }) => PontosGeograficosParcelaCompanion.insert(
                id: id,
                parcelaId: parcelaId,
                ordemPonto: ordemPonto,
                posicaoReferencia: posicaoReferencia,
                latitude: latitude,
                longitude: longitude,
                precisaoMetros: precisaoMetros,
                capturadoEm: capturadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $PontosGeograficosParcelaTable,
                    PontoGeograficoParcela
                  >(table),
                  $$PontosGeograficosParcelaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parcelaId = false}) {
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
                    if (parcelaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parcelaId,
                                referencedTable:
                                    $$PontosGeograficosParcelaTableReferences
                                        ._parcelaIdTable(db),
                                referencedColumn:
                                    $$PontosGeograficosParcelaTableReferences
                                        ._parcelaIdTable(db)
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

typedef $$PontosGeograficosParcelaTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $PontosGeograficosParcelaTable,
      PontoGeograficoParcela,
      $$PontosGeograficosParcelaTableFilterComposer,
      $$PontosGeograficosParcelaTableOrderingComposer,
      $$PontosGeograficosParcelaTableAnnotationComposer,
      $$PontosGeograficosParcelaTableCreateCompanionBuilder,
      $$PontosGeograficosParcelaTableUpdateCompanionBuilder,
      (PontoGeograficoParcela, $$PontosGeograficosParcelaTableReferences),
      PontoGeograficoParcela,
      PrefetchHooks Function({bool parcelaId})
    >;
typedef $$ArvoresTableCreateCompanionBuilder =
    ArvoresCompanion Function({
      Value<int> id,
      required int parcelaId,
      required int numero,
      required double dapCm,
      required double alturaM,
      Value<bool> possuiTroncoTortuoso,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> precisaoMetros,
      Value<DateTime?> localizacaoCapturadaEm,
      Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela,
      required DateTime criadoEm,
      required DateTime atualizadoEm,
    });
typedef $$ArvoresTableUpdateCompanionBuilder =
    ArvoresCompanion Function({
      Value<int> id,
      Value<int> parcelaId,
      Value<int> numero,
      Value<double> dapCm,
      Value<double> alturaM,
      Value<bool> possuiTroncoTortuoso,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> precisaoMetros,
      Value<DateTime?> localizacaoCapturadaEm,
      Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela,
      Value<DateTime> criadoEm,
      Value<DateTime> atualizadoEm,
    });

final class $$ArvoresTableReferences
    extends BaseReferences<_$BancoDendro, $ArvoresTable, Arvore> {
  $$ArvoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ParcelasTable _parcelaIdTable(_$BancoDendro db) =>
      db.parcelas.createAlias('arvores__parcela_id__parcelas__id');

  $$ParcelasTableProcessedTableManager get parcelaId {
    final $_column = $_itemColumn<int>('parcela_id')!;

    final manager = $$ParcelasTableTableManager(
      $_db,
      $_db.parcelas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parcelaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ArvoresTableFilterComposer
    extends Composer<_$BancoDendro, $ArvoresTable> {
  $$ArvoresTableFilterComposer({
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

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dapCm => $composableBuilder(
    column: $table.dapCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alturaM => $composableBuilder(
    column: $table.alturaM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get possuiTroncoTortuoso => $composableBuilder(
    column: $table.possuiTroncoTortuoso,
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

  ColumnFilters<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localizacaoCapturadaEm => $composableBuilder(
    column: $table.localizacaoCapturadaEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    PosicaoReferenciaParcela?,
    PosicaoReferenciaParcela,
    String
  >
  get posicaoReferenciaParcela => $composableBuilder(
    column: $table.posicaoReferenciaParcela,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ParcelasTableFilterComposer get parcelaId {
    final $$ParcelasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableFilterComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArvoresTableOrderingComposer
    extends Composer<_$BancoDendro, $ArvoresTable> {
  $$ArvoresTableOrderingComposer({
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

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dapCm => $composableBuilder(
    column: $table.dapCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alturaM => $composableBuilder(
    column: $table.alturaM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get possuiTroncoTortuoso => $composableBuilder(
    column: $table.possuiTroncoTortuoso,
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

  ColumnOrderings<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localizacaoCapturadaEm => $composableBuilder(
    column: $table.localizacaoCapturadaEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posicaoReferenciaParcela => $composableBuilder(
    column: $table.posicaoReferenciaParcela,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ParcelasTableOrderingComposer get parcelaId {
    final $$ParcelasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableOrderingComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArvoresTableAnnotationComposer
    extends Composer<_$BancoDendro, $ArvoresTable> {
  $$ArvoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<double> get dapCm =>
      $composableBuilder(column: $table.dapCm, builder: (column) => column);

  GeneratedColumn<double> get alturaM =>
      $composableBuilder(column: $table.alturaM, builder: (column) => column);

  GeneratedColumn<bool> get possuiTroncoTortuoso => $composableBuilder(
    column: $table.possuiTroncoTortuoso,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get precisaoMetros => $composableBuilder(
    column: $table.precisaoMetros,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get localizacaoCapturadaEm => $composableBuilder(
    column: $table.localizacaoCapturadaEm,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PosicaoReferenciaParcela?, String>
  get posicaoReferenciaParcela => $composableBuilder(
    column: $table.posicaoReferenciaParcela,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  $$ParcelasTableAnnotationComposer get parcelaId {
    final $$ParcelasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parcelaId,
      referencedTable: $db.parcelas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParcelasTableAnnotationComposer(
            $db: $db,
            $table: $db.parcelas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ArvoresTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $ArvoresTable,
          Arvore,
          $$ArvoresTableFilterComposer,
          $$ArvoresTableOrderingComposer,
          $$ArvoresTableAnnotationComposer,
          $$ArvoresTableCreateCompanionBuilder,
          $$ArvoresTableUpdateCompanionBuilder,
          (Arvore, $$ArvoresTableReferences),
          Arvore,
          PrefetchHooks Function({bool parcelaId})
        > {
  $$ArvoresTableTableManager(_$BancoDendro db, $ArvoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArvoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArvoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArvoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parcelaId = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<double> dapCm = const Value.absent(),
                Value<double> alturaM = const Value.absent(),
                Value<bool> possuiTroncoTortuoso = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> precisaoMetros = const Value.absent(),
                Value<DateTime?> localizacaoCapturadaEm = const Value.absent(),
                Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela =
                    const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime> atualizadoEm = const Value.absent(),
              }) => ArvoresCompanion(
                id: id,
                parcelaId: parcelaId,
                numero: numero,
                dapCm: dapCm,
                alturaM: alturaM,
                possuiTroncoTortuoso: possuiTroncoTortuoso,
                latitude: latitude,
                longitude: longitude,
                precisaoMetros: precisaoMetros,
                localizacaoCapturadaEm: localizacaoCapturadaEm,
                posicaoReferenciaParcela: posicaoReferenciaParcela,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parcelaId,
                required int numero,
                required double dapCm,
                required double alturaM,
                Value<bool> possuiTroncoTortuoso = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> precisaoMetros = const Value.absent(),
                Value<DateTime?> localizacaoCapturadaEm = const Value.absent(),
                Value<PosicaoReferenciaParcela?> posicaoReferenciaParcela =
                    const Value.absent(),
                required DateTime criadoEm,
                required DateTime atualizadoEm,
              }) => ArvoresCompanion.insert(
                id: id,
                parcelaId: parcelaId,
                numero: numero,
                dapCm: dapCm,
                alturaM: alturaM,
                possuiTroncoTortuoso: possuiTroncoTortuoso,
                latitude: latitude,
                longitude: longitude,
                precisaoMetros: precisaoMetros,
                localizacaoCapturadaEm: localizacaoCapturadaEm,
                posicaoReferenciaParcela: posicaoReferenciaParcela,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArvoresTable, Arvore>(table),
                  $$ArvoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parcelaId = false}) {
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
                    if (parcelaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parcelaId,
                                referencedTable: $$ArvoresTableReferences
                                    ._parcelaIdTable(db),
                                referencedColumn: $$ArvoresTableReferences
                                    ._parcelaIdTable(db)
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

typedef $$ArvoresTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $ArvoresTable,
      Arvore,
      $$ArvoresTableFilterComposer,
      $$ArvoresTableOrderingComposer,
      $$ArvoresTableAnnotationComposer,
      $$ArvoresTableCreateCompanionBuilder,
      $$ArvoresTableUpdateCompanionBuilder,
      (Arvore, $$ArvoresTableReferences),
      Arvore,
      PrefetchHooks Function({bool parcelaId})
    >;
typedef $$RegistrosAtividadeTableCreateCompanionBuilder =
    RegistrosAtividadeCompanion Function({
      Value<int> id,
      required String tipo,
      required String titulo,
      Value<String> subtitulo,
      Value<String?> tipoEntidade,
      Value<int?> entidadeId,
      required DateTime ocorridoEm,
    });
typedef $$RegistrosAtividadeTableUpdateCompanionBuilder =
    RegistrosAtividadeCompanion Function({
      Value<int> id,
      Value<String> tipo,
      Value<String> titulo,
      Value<String> subtitulo,
      Value<String?> tipoEntidade,
      Value<int?> entidadeId,
      Value<DateTime> ocorridoEm,
    });

class $$RegistrosAtividadeTableFilterComposer
    extends Composer<_$BancoDendro, $RegistrosAtividadeTable> {
  $$RegistrosAtividadeTableFilterComposer({
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

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitulo => $composableBuilder(
    column: $table.subtitulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoEntidade => $composableBuilder(
    column: $table.tipoEntidade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ocorridoEm => $composableBuilder(
    column: $table.ocorridoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegistrosAtividadeTableOrderingComposer
    extends Composer<_$BancoDendro, $RegistrosAtividadeTable> {
  $$RegistrosAtividadeTableOrderingComposer({
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

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitulo => $composableBuilder(
    column: $table.subtitulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoEntidade => $composableBuilder(
    column: $table.tipoEntidade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ocorridoEm => $composableBuilder(
    column: $table.ocorridoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegistrosAtividadeTableAnnotationComposer
    extends Composer<_$BancoDendro, $RegistrosAtividadeTable> {
  $$RegistrosAtividadeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get subtitulo =>
      $composableBuilder(column: $table.subtitulo, builder: (column) => column);

  GeneratedColumn<String> get tipoEntidade => $composableBuilder(
    column: $table.tipoEntidade,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entidadeId => $composableBuilder(
    column: $table.entidadeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ocorridoEm => $composableBuilder(
    column: $table.ocorridoEm,
    builder: (column) => column,
  );
}

class $$RegistrosAtividadeTableTableManager
    extends
        RootTableManager<
          _$BancoDendro,
          $RegistrosAtividadeTable,
          AtividadeBanco,
          $$RegistrosAtividadeTableFilterComposer,
          $$RegistrosAtividadeTableOrderingComposer,
          $$RegistrosAtividadeTableAnnotationComposer,
          $$RegistrosAtividadeTableCreateCompanionBuilder,
          $$RegistrosAtividadeTableUpdateCompanionBuilder,
          (
            AtividadeBanco,
            BaseReferences<
              _$BancoDendro,
              $RegistrosAtividadeTable,
              AtividadeBanco
            >,
          ),
          AtividadeBanco,
          PrefetchHooks Function()
        > {
  $$RegistrosAtividadeTableTableManager(
    _$BancoDendro db,
    $RegistrosAtividadeTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosAtividadeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosAtividadeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosAtividadeTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> subtitulo = const Value.absent(),
                Value<String?> tipoEntidade = const Value.absent(),
                Value<int?> entidadeId = const Value.absent(),
                Value<DateTime> ocorridoEm = const Value.absent(),
              }) => RegistrosAtividadeCompanion(
                id: id,
                tipo: tipo,
                titulo: titulo,
                subtitulo: subtitulo,
                tipoEntidade: tipoEntidade,
                entidadeId: entidadeId,
                ocorridoEm: ocorridoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tipo,
                required String titulo,
                Value<String> subtitulo = const Value.absent(),
                Value<String?> tipoEntidade = const Value.absent(),
                Value<int?> entidadeId = const Value.absent(),
                required DateTime ocorridoEm,
              }) => RegistrosAtividadeCompanion.insert(
                id: id,
                tipo: tipo,
                titulo: titulo,
                subtitulo: subtitulo,
                tipoEntidade: tipoEntidade,
                entidadeId: entidadeId,
                ocorridoEm: ocorridoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RegistrosAtividadeTable, AtividadeBanco>(table),
                  BaseReferences<
                    _$BancoDendro,
                    $RegistrosAtividadeTable,
                    AtividadeBanco
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegistrosAtividadeTableProcessedTableManager =
    ProcessedTableManager<
      _$BancoDendro,
      $RegistrosAtividadeTable,
      AtividadeBanco,
      $$RegistrosAtividadeTableFilterComposer,
      $$RegistrosAtividadeTableOrderingComposer,
      $$RegistrosAtividadeTableAnnotationComposer,
      $$RegistrosAtividadeTableCreateCompanionBuilder,
      $$RegistrosAtividadeTableUpdateCompanionBuilder,
      (
        AtividadeBanco,
        BaseReferences<_$BancoDendro, $RegistrosAtividadeTable, AtividadeBanco>,
      ),
      AtividadeBanco,
      PrefetchHooks Function()
    >;

class $BancoDendroManager {
  final _$BancoDendro _db;
  $BancoDendroManager(this._db);
  $$PropriedadesTableTableManager get propriedades =>
      $$PropriedadesTableTableManager(_db, _db.propriedades);
  $$EspeciesTableTableManager get especies =>
      $$EspeciesTableTableManager(_db, _db.especies);
  $$ModelosMatematicosTableTableManager get modelosMatematicos =>
      $$ModelosMatematicosTableTableManager(_db, _db.modelosMatematicos);
  $$VariaveisModeloTableTableManager get variaveisModelo =>
      $$VariaveisModeloTableTableManager(_db, _db.variaveisModelo);
  $$CoeficientesModeloTableTableManager get coeficientesModelo =>
      $$CoeficientesModeloTableTableManager(_db, _db.coeficientesModelo);
  $$EspeciesModelosTableTableManager get especiesModelos =>
      $$EspeciesModelosTableTableManager(_db, _db.especiesModelos);
  $$CoeficientesEspecieModeloTableTableManager get coeficientesEspecieModelo =>
      $$CoeficientesEspecieModeloTableTableManager(
        _db,
        _db.coeficientesEspecieModelo,
      );
  $$TalhoesTableTableManager get talhoes =>
      $$TalhoesTableTableManager(_db, _db.talhoes);
  $$LevantamentosTableTableManager get levantamentos =>
      $$LevantamentosTableTableManager(_db, _db.levantamentos);
  $$TalhaoLevantamentosTableTableManager get talhaoLevantamentos =>
      $$TalhaoLevantamentosTableTableManager(_db, _db.talhaoLevantamentos);
  $$CoeficientesTalhaoLevantamentoTableTableManager
  get coeficientesTalhaoLevantamento =>
      $$CoeficientesTalhaoLevantamentoTableTableManager(
        _db,
        _db.coeficientesTalhaoLevantamento,
      );
  $$ParcelasTableTableManager get parcelas =>
      $$ParcelasTableTableManager(_db, _db.parcelas);
  $$PontosGeograficosParcelaTableTableManager get pontosGeograficosParcela =>
      $$PontosGeograficosParcelaTableTableManager(
        _db,
        _db.pontosGeograficosParcela,
      );
  $$ArvoresTableTableManager get arvores =>
      $$ArvoresTableTableManager(_db, _db.arvores);
  $$RegistrosAtividadeTableTableManager get registrosAtividade =>
      $$RegistrosAtividadeTableTableManager(_db, _db.registrosAtividade);
}
