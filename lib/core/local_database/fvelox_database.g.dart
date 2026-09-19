// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fvelox_database.dart';

// ignore_for_file: type=lint
class $PaymentTableTable extends PaymentTable
    with TableInfo<$PaymentTableTable, PaymentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyMeta = const VerificationMeta('party');
  @override
  late final GeneratedColumn<String> party = GeneratedColumn<String>(
    'party',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateLabelMeta = const VerificationMeta(
    'dateLabel',
  );
  @override
  late final GeneratedColumn<String> dateLabel = GeneratedColumn<String>(
    'date_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
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
    party,
    amount,
    status,
    dateLabel,
    reference,
    note,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('party')) {
      context.handle(
        _partyMeta,
        party.isAcceptableOrUnknown(data['party']!, _partyMeta),
      );
    } else if (isInserting) {
      context.missing(_partyMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date_label')) {
      context.handle(
        _dateLabelMeta,
        dateLabel.isAcceptableOrUnknown(data['date_label']!, _dateLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_dateLabelMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
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
  PaymentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      party: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      dateLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_label'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PaymentTableTable createAlias(String alias) {
    return $PaymentTableTable(attachedDatabase, alias);
  }
}

class PaymentTableData extends DataClass
    implements Insertable<PaymentTableData> {
  final String id;
  final String party;
  final double amount;
  final int status;
  final String dateLabel;
  final String reference;
  final String note;
  final DateTime cachedAt;
  const PaymentTableData({
    required this.id,
    required this.party,
    required this.amount,
    required this.status,
    required this.dateLabel,
    required this.reference,
    required this.note,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['party'] = Variable<String>(party);
    map['amount'] = Variable<double>(amount);
    map['status'] = Variable<int>(status);
    map['date_label'] = Variable<String>(dateLabel);
    map['reference'] = Variable<String>(reference);
    map['note'] = Variable<String>(note);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PaymentTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentTableCompanion(
      id: Value(id),
      party: Value(party),
      amount: Value(amount),
      status: Value(status),
      dateLabel: Value(dateLabel),
      reference: Value(reference),
      note: Value(note),
      cachedAt: Value(cachedAt),
    );
  }

  factory PaymentTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentTableData(
      id: serializer.fromJson<String>(json['id']),
      party: serializer.fromJson<String>(json['party']),
      amount: serializer.fromJson<double>(json['amount']),
      status: serializer.fromJson<int>(json['status']),
      dateLabel: serializer.fromJson<String>(json['dateLabel']),
      reference: serializer.fromJson<String>(json['reference']),
      note: serializer.fromJson<String>(json['note']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'party': serializer.toJson<String>(party),
      'amount': serializer.toJson<double>(amount),
      'status': serializer.toJson<int>(status),
      'dateLabel': serializer.toJson<String>(dateLabel),
      'reference': serializer.toJson<String>(reference),
      'note': serializer.toJson<String>(note),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PaymentTableData copyWith({
    String? id,
    String? party,
    double? amount,
    int? status,
    String? dateLabel,
    String? reference,
    String? note,
    DateTime? cachedAt,
  }) => PaymentTableData(
    id: id ?? this.id,
    party: party ?? this.party,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    dateLabel: dateLabel ?? this.dateLabel,
    reference: reference ?? this.reference,
    note: note ?? this.note,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PaymentTableData copyWithCompanion(PaymentTableCompanion data) {
    return PaymentTableData(
      id: data.id.present ? data.id.value : this.id,
      party: data.party.present ? data.party.value : this.party,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      dateLabel: data.dateLabel.present ? data.dateLabel.value : this.dateLabel,
      reference: data.reference.present ? data.reference.value : this.reference,
      note: data.note.present ? data.note.value : this.note,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentTableData(')
          ..write('id: $id, ')
          ..write('party: $party, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('reference: $reference, ')
          ..write('note: $note, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    party,
    amount,
    status,
    dateLabel,
    reference,
    note,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentTableData &&
          other.id == this.id &&
          other.party == this.party &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.dateLabel == this.dateLabel &&
          other.reference == this.reference &&
          other.note == this.note &&
          other.cachedAt == this.cachedAt);
}

class PaymentTableCompanion extends UpdateCompanion<PaymentTableData> {
  final Value<String> id;
  final Value<String> party;
  final Value<double> amount;
  final Value<int> status;
  final Value<String> dateLabel;
  final Value<String> reference;
  final Value<String> note;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PaymentTableCompanion({
    this.id = const Value.absent(),
    this.party = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.dateLabel = const Value.absent(),
    this.reference = const Value.absent(),
    this.note = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentTableCompanion.insert({
    required String id,
    required String party,
    required double amount,
    required int status,
    required String dateLabel,
    required String reference,
    required String note,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       party = Value(party),
       amount = Value(amount),
       status = Value(status),
       dateLabel = Value(dateLabel),
       reference = Value(reference),
       note = Value(note),
       cachedAt = Value(cachedAt);
  static Insertable<PaymentTableData> custom({
    Expression<String>? id,
    Expression<String>? party,
    Expression<double>? amount,
    Expression<int>? status,
    Expression<String>? dateLabel,
    Expression<String>? reference,
    Expression<String>? note,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (party != null) 'party': party,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (dateLabel != null) 'date_label': dateLabel,
      if (reference != null) 'reference': reference,
      if (note != null) 'note': note,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentTableCompanion copyWith({
    Value<String>? id,
    Value<String>? party,
    Value<double>? amount,
    Value<int>? status,
    Value<String>? dateLabel,
    Value<String>? reference,
    Value<String>? note,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PaymentTableCompanion(
      id: id ?? this.id,
      party: party ?? this.party,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      dateLabel: dateLabel ?? this.dateLabel,
      reference: reference ?? this.reference,
      note: note ?? this.note,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (party.present) {
      map['party'] = Variable<String>(party.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (dateLabel.present) {
      map['date_label'] = Variable<String>(dateLabel.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentTableCompanion(')
          ..write('id: $id, ')
          ..write('party: $party, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('reference: $reference, ')
          ..write('note: $note, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentFeatureTableTable extends PaymentFeatureTable
    with TableInfo<$PaymentFeatureTableTable, PaymentFeatureTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentFeatureTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _featureKeyMeta = const VerificationMeta(
    'featureKey',
  );
  @override
  late final GeneratedColumn<String> featureKey = GeneratedColumn<String>(
    'feature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _authRequiredMeta = const VerificationMeta(
    'authRequired',
  );
  @override
  late final GeneratedColumn<bool> authRequired = GeneratedColumn<bool>(
    'auth_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auth_required" IN (0, 1))',
    ),
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
    featureKey,
    enabled,
    authRequired,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_feature_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentFeatureTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('feature_key')) {
      context.handle(
        _featureKeyMeta,
        featureKey.isAcceptableOrUnknown(data['feature_key']!, _featureKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_featureKeyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('auth_required')) {
      context.handle(
        _authRequiredMeta,
        authRequired.isAcceptableOrUnknown(
          data['auth_required']!,
          _authRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authRequiredMeta);
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
  Set<GeneratedColumn> get $primaryKey => {featureKey};
  @override
  PaymentFeatureTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentFeatureTableData(
      featureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_key'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      authRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auth_required'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PaymentFeatureTableTable createAlias(String alias) {
    return $PaymentFeatureTableTable(attachedDatabase, alias);
  }
}

class PaymentFeatureTableData extends DataClass
    implements Insertable<PaymentFeatureTableData> {
  final String featureKey;
  final bool enabled;
  final bool authRequired;
  final DateTime cachedAt;
  const PaymentFeatureTableData({
    required this.featureKey,
    required this.enabled,
    required this.authRequired,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['feature_key'] = Variable<String>(featureKey);
    map['enabled'] = Variable<bool>(enabled);
    map['auth_required'] = Variable<bool>(authRequired);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PaymentFeatureTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentFeatureTableCompanion(
      featureKey: Value(featureKey),
      enabled: Value(enabled),
      authRequired: Value(authRequired),
      cachedAt: Value(cachedAt),
    );
  }

  factory PaymentFeatureTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentFeatureTableData(
      featureKey: serializer.fromJson<String>(json['featureKey']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      authRequired: serializer.fromJson<bool>(json['authRequired']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'featureKey': serializer.toJson<String>(featureKey),
      'enabled': serializer.toJson<bool>(enabled),
      'authRequired': serializer.toJson<bool>(authRequired),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PaymentFeatureTableData copyWith({
    String? featureKey,
    bool? enabled,
    bool? authRequired,
    DateTime? cachedAt,
  }) => PaymentFeatureTableData(
    featureKey: featureKey ?? this.featureKey,
    enabled: enabled ?? this.enabled,
    authRequired: authRequired ?? this.authRequired,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PaymentFeatureTableData copyWithCompanion(PaymentFeatureTableCompanion data) {
    return PaymentFeatureTableData(
      featureKey: data.featureKey.present
          ? data.featureKey.value
          : this.featureKey,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      authRequired: data.authRequired.present
          ? data.authRequired.value
          : this.authRequired,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentFeatureTableData(')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('authRequired: $authRequired, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(featureKey, enabled, authRequired, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentFeatureTableData &&
          other.featureKey == this.featureKey &&
          other.enabled == this.enabled &&
          other.authRequired == this.authRequired &&
          other.cachedAt == this.cachedAt);
}

class PaymentFeatureTableCompanion
    extends UpdateCompanion<PaymentFeatureTableData> {
  final Value<String> featureKey;
  final Value<bool> enabled;
  final Value<bool> authRequired;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PaymentFeatureTableCompanion({
    this.featureKey = const Value.absent(),
    this.enabled = const Value.absent(),
    this.authRequired = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentFeatureTableCompanion.insert({
    required String featureKey,
    required bool enabled,
    required bool authRequired,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : featureKey = Value(featureKey),
       enabled = Value(enabled),
       authRequired = Value(authRequired),
       cachedAt = Value(cachedAt);
  static Insertable<PaymentFeatureTableData> custom({
    Expression<String>? featureKey,
    Expression<bool>? enabled,
    Expression<bool>? authRequired,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (featureKey != null) 'feature_key': featureKey,
      if (enabled != null) 'enabled': enabled,
      if (authRequired != null) 'auth_required': authRequired,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentFeatureTableCompanion copyWith({
    Value<String>? featureKey,
    Value<bool>? enabled,
    Value<bool>? authRequired,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PaymentFeatureTableCompanion(
      featureKey: featureKey ?? this.featureKey,
      enabled: enabled ?? this.enabled,
      authRequired: authRequired ?? this.authRequired,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (featureKey.present) {
      map['feature_key'] = Variable<String>(featureKey.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (authRequired.present) {
      map['auth_required'] = Variable<bool>(authRequired.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentFeatureTableCompanion(')
          ..write('featureKey: $featureKey, ')
          ..write('enabled: $enabled, ')
          ..write('authRequired: $authRequired, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentSummaryTableTable extends PaymentSummaryTable
    with TableInfo<$PaymentSummaryTableTable, PaymentSummaryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentSummaryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMinorMeta = const VerificationMeta(
    'totalAmountMinor',
  );
  @override
  late final GeneratedColumn<int> totalAmountMinor = GeneratedColumn<int>(
    'total_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentCountMeta = const VerificationMeta(
    'paymentCount',
  );
  @override
  late final GeneratedColumn<int> paymentCount = GeneratedColumn<int>(
    'payment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    month,
    currency,
    totalAmount,
    totalAmountMinor,
    paymentCount,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_summary_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentSummaryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_amount_minor')) {
      context.handle(
        _totalAmountMinorMeta,
        totalAmountMinor.isAcceptableOrUnknown(
          data['total_amount_minor']!,
          _totalAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMinorMeta);
    }
    if (data.containsKey('payment_count')) {
      context.handle(
        _paymentCountMeta,
        paymentCount.isAcceptableOrUnknown(
          data['payment_count']!,
          _paymentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentCountMeta);
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
  Set<GeneratedColumn> get $primaryKey => {month};
  @override
  PaymentSummaryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentSummaryTableData(
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      totalAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_minor'],
      )!,
      paymentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_count'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PaymentSummaryTableTable createAlias(String alias) {
    return $PaymentSummaryTableTable(attachedDatabase, alias);
  }
}

class PaymentSummaryTableData extends DataClass
    implements Insertable<PaymentSummaryTableData> {
  final String month;
  final String currency;
  final double totalAmount;
  final int totalAmountMinor;
  final int paymentCount;
  final DateTime cachedAt;
  const PaymentSummaryTableData({
    required this.month,
    required this.currency,
    required this.totalAmount,
    required this.totalAmountMinor,
    required this.paymentCount,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['month'] = Variable<String>(month);
    map['currency'] = Variable<String>(currency);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_amount_minor'] = Variable<int>(totalAmountMinor);
    map['payment_count'] = Variable<int>(paymentCount);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PaymentSummaryTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentSummaryTableCompanion(
      month: Value(month),
      currency: Value(currency),
      totalAmount: Value(totalAmount),
      totalAmountMinor: Value(totalAmountMinor),
      paymentCount: Value(paymentCount),
      cachedAt: Value(cachedAt),
    );
  }

  factory PaymentSummaryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentSummaryTableData(
      month: serializer.fromJson<String>(json['month']),
      currency: serializer.fromJson<String>(json['currency']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalAmountMinor: serializer.fromJson<int>(json['totalAmountMinor']),
      paymentCount: serializer.fromJson<int>(json['paymentCount']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'month': serializer.toJson<String>(month),
      'currency': serializer.toJson<String>(currency),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalAmountMinor': serializer.toJson<int>(totalAmountMinor),
      'paymentCount': serializer.toJson<int>(paymentCount),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PaymentSummaryTableData copyWith({
    String? month,
    String? currency,
    double? totalAmount,
    int? totalAmountMinor,
    int? paymentCount,
    DateTime? cachedAt,
  }) => PaymentSummaryTableData(
    month: month ?? this.month,
    currency: currency ?? this.currency,
    totalAmount: totalAmount ?? this.totalAmount,
    totalAmountMinor: totalAmountMinor ?? this.totalAmountMinor,
    paymentCount: paymentCount ?? this.paymentCount,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PaymentSummaryTableData copyWithCompanion(PaymentSummaryTableCompanion data) {
    return PaymentSummaryTableData(
      month: data.month.present ? data.month.value : this.month,
      currency: data.currency.present ? data.currency.value : this.currency,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      totalAmountMinor: data.totalAmountMinor.present
          ? data.totalAmountMinor.value
          : this.totalAmountMinor,
      paymentCount: data.paymentCount.present
          ? data.paymentCount.value
          : this.paymentCount,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentSummaryTableData(')
          ..write('month: $month, ')
          ..write('currency: $currency, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAmountMinor: $totalAmountMinor, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    month,
    currency,
    totalAmount,
    totalAmountMinor,
    paymentCount,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentSummaryTableData &&
          other.month == this.month &&
          other.currency == this.currency &&
          other.totalAmount == this.totalAmount &&
          other.totalAmountMinor == this.totalAmountMinor &&
          other.paymentCount == this.paymentCount &&
          other.cachedAt == this.cachedAt);
}

class PaymentSummaryTableCompanion
    extends UpdateCompanion<PaymentSummaryTableData> {
  final Value<String> month;
  final Value<String> currency;
  final Value<double> totalAmount;
  final Value<int> totalAmountMinor;
  final Value<int> paymentCount;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PaymentSummaryTableCompanion({
    this.month = const Value.absent(),
    this.currency = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalAmountMinor = const Value.absent(),
    this.paymentCount = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentSummaryTableCompanion.insert({
    required String month,
    required String currency,
    required double totalAmount,
    required int totalAmountMinor,
    required int paymentCount,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : month = Value(month),
       currency = Value(currency),
       totalAmount = Value(totalAmount),
       totalAmountMinor = Value(totalAmountMinor),
       paymentCount = Value(paymentCount),
       cachedAt = Value(cachedAt);
  static Insertable<PaymentSummaryTableData> custom({
    Expression<String>? month,
    Expression<String>? currency,
    Expression<double>? totalAmount,
    Expression<int>? totalAmountMinor,
    Expression<int>? paymentCount,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (month != null) 'month': month,
      if (currency != null) 'currency': currency,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalAmountMinor != null) 'total_amount_minor': totalAmountMinor,
      if (paymentCount != null) 'payment_count': paymentCount,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentSummaryTableCompanion copyWith({
    Value<String>? month,
    Value<String>? currency,
    Value<double>? totalAmount,
    Value<int>? totalAmountMinor,
    Value<int>? paymentCount,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PaymentSummaryTableCompanion(
      month: month ?? this.month,
      currency: currency ?? this.currency,
      totalAmount: totalAmount ?? this.totalAmount,
      totalAmountMinor: totalAmountMinor ?? this.totalAmountMinor,
      paymentCount: paymentCount ?? this.paymentCount,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalAmountMinor.present) {
      map['total_amount_minor'] = Variable<int>(totalAmountMinor.value);
    }
    if (paymentCount.present) {
      map['payment_count'] = Variable<int>(paymentCount.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentSummaryTableCompanion(')
          ..write('month: $month, ')
          ..write('currency: $currency, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAmountMinor: $totalAmountMinor, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FveloxDatabase extends GeneratedDatabase {
  _$FveloxDatabase(QueryExecutor e) : super(e);
  $FveloxDatabaseManager get managers => $FveloxDatabaseManager(this);
  late final $PaymentTableTable paymentTable = $PaymentTableTable(this);
  late final $PaymentFeatureTableTable paymentFeatureTable =
      $PaymentFeatureTableTable(this);
  late final $PaymentSummaryTableTable paymentSummaryTable =
      $PaymentSummaryTableTable(this);
  late final PaymentDao paymentDao = PaymentDao(this as FveloxDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    paymentTable,
    paymentFeatureTable,
    paymentSummaryTable,
  ];
}

typedef $$PaymentTableTableCreateCompanionBuilder =
    PaymentTableCompanion Function({
      required String id,
      required String party,
      required double amount,
      required int status,
      required String dateLabel,
      required String reference,
      required String note,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PaymentTableTableUpdateCompanionBuilder =
    PaymentTableCompanion Function({
      Value<String> id,
      Value<String> party,
      Value<double> amount,
      Value<int> status,
      Value<String> dateLabel,
      Value<String> reference,
      Value<String> note,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PaymentTableTableFilterComposer
    extends Composer<_$FveloxDatabase, $PaymentTableTable> {
  $$PaymentTableTableFilterComposer({
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

  ColumnFilters<String> get party => $composableBuilder(
    column: $table.party,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateLabel => $composableBuilder(
    column: $table.dateLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentTableTableOrderingComposer
    extends Composer<_$FveloxDatabase, $PaymentTableTable> {
  $$PaymentTableTableOrderingComposer({
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

  ColumnOrderings<String> get party => $composableBuilder(
    column: $table.party,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateLabel => $composableBuilder(
    column: $table.dateLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentTableTableAnnotationComposer
    extends Composer<_$FveloxDatabase, $PaymentTableTable> {
  $$PaymentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get party =>
      $composableBuilder(column: $table.party, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dateLabel =>
      $composableBuilder(column: $table.dateLabel, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PaymentTableTableTableManager
    extends
        RootTableManager<
          _$FveloxDatabase,
          $PaymentTableTable,
          PaymentTableData,
          $$PaymentTableTableFilterComposer,
          $$PaymentTableTableOrderingComposer,
          $$PaymentTableTableAnnotationComposer,
          $$PaymentTableTableCreateCompanionBuilder,
          $$PaymentTableTableUpdateCompanionBuilder,
          (
            PaymentTableData,
            BaseReferences<
              _$FveloxDatabase,
              $PaymentTableTable,
              PaymentTableData
            >,
          ),
          PaymentTableData,
          PrefetchHooks Function()
        > {
  $$PaymentTableTableTableManager(_$FveloxDatabase db, $PaymentTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> party = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String> dateLabel = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentTableCompanion(
                id: id,
                party: party,
                amount: amount,
                status: status,
                dateLabel: dateLabel,
                reference: reference,
                note: note,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String party,
                required double amount,
                required int status,
                required String dateLabel,
                required String reference,
                required String note,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentTableCompanion.insert(
                id: id,
                party: party,
                amount: amount,
                status: status,
                dateLabel: dateLabel,
                reference: reference,
                note: note,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentTableTableProcessedTableManager =
    ProcessedTableManager<
      _$FveloxDatabase,
      $PaymentTableTable,
      PaymentTableData,
      $$PaymentTableTableFilterComposer,
      $$PaymentTableTableOrderingComposer,
      $$PaymentTableTableAnnotationComposer,
      $$PaymentTableTableCreateCompanionBuilder,
      $$PaymentTableTableUpdateCompanionBuilder,
      (
        PaymentTableData,
        BaseReferences<_$FveloxDatabase, $PaymentTableTable, PaymentTableData>,
      ),
      PaymentTableData,
      PrefetchHooks Function()
    >;
typedef $$PaymentFeatureTableTableCreateCompanionBuilder =
    PaymentFeatureTableCompanion Function({
      required String featureKey,
      required bool enabled,
      required bool authRequired,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PaymentFeatureTableTableUpdateCompanionBuilder =
    PaymentFeatureTableCompanion Function({
      Value<String> featureKey,
      Value<bool> enabled,
      Value<bool> authRequired,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PaymentFeatureTableTableFilterComposer
    extends Composer<_$FveloxDatabase, $PaymentFeatureTableTable> {
  $$PaymentFeatureTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get authRequired => $composableBuilder(
    column: $table.authRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentFeatureTableTableOrderingComposer
    extends Composer<_$FveloxDatabase, $PaymentFeatureTableTable> {
  $$PaymentFeatureTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get authRequired => $composableBuilder(
    column: $table.authRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentFeatureTableTableAnnotationComposer
    extends Composer<_$FveloxDatabase, $PaymentFeatureTableTable> {
  $$PaymentFeatureTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get authRequired => $composableBuilder(
    column: $table.authRequired,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PaymentFeatureTableTableTableManager
    extends
        RootTableManager<
          _$FveloxDatabase,
          $PaymentFeatureTableTable,
          PaymentFeatureTableData,
          $$PaymentFeatureTableTableFilterComposer,
          $$PaymentFeatureTableTableOrderingComposer,
          $$PaymentFeatureTableTableAnnotationComposer,
          $$PaymentFeatureTableTableCreateCompanionBuilder,
          $$PaymentFeatureTableTableUpdateCompanionBuilder,
          (
            PaymentFeatureTableData,
            BaseReferences<
              _$FveloxDatabase,
              $PaymentFeatureTableTable,
              PaymentFeatureTableData
            >,
          ),
          PaymentFeatureTableData,
          PrefetchHooks Function()
        > {
  $$PaymentFeatureTableTableTableManager(
    _$FveloxDatabase db,
    $PaymentFeatureTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentFeatureTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentFeatureTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaymentFeatureTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> featureKey = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> authRequired = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentFeatureTableCompanion(
                featureKey: featureKey,
                enabled: enabled,
                authRequired: authRequired,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String featureKey,
                required bool enabled,
                required bool authRequired,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentFeatureTableCompanion.insert(
                featureKey: featureKey,
                enabled: enabled,
                authRequired: authRequired,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentFeatureTableTableProcessedTableManager =
    ProcessedTableManager<
      _$FveloxDatabase,
      $PaymentFeatureTableTable,
      PaymentFeatureTableData,
      $$PaymentFeatureTableTableFilterComposer,
      $$PaymentFeatureTableTableOrderingComposer,
      $$PaymentFeatureTableTableAnnotationComposer,
      $$PaymentFeatureTableTableCreateCompanionBuilder,
      $$PaymentFeatureTableTableUpdateCompanionBuilder,
      (
        PaymentFeatureTableData,
        BaseReferences<
          _$FveloxDatabase,
          $PaymentFeatureTableTable,
          PaymentFeatureTableData
        >,
      ),
      PaymentFeatureTableData,
      PrefetchHooks Function()
    >;
typedef $$PaymentSummaryTableTableCreateCompanionBuilder =
    PaymentSummaryTableCompanion Function({
      required String month,
      required String currency,
      required double totalAmount,
      required int totalAmountMinor,
      required int paymentCount,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PaymentSummaryTableTableUpdateCompanionBuilder =
    PaymentSummaryTableCompanion Function({
      Value<String> month,
      Value<String> currency,
      Value<double> totalAmount,
      Value<int> totalAmountMinor,
      Value<int> paymentCount,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PaymentSummaryTableTableFilterComposer
    extends Composer<_$FveloxDatabase, $PaymentSummaryTableTable> {
  $$PaymentSummaryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountMinor => $composableBuilder(
    column: $table.totalAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentSummaryTableTableOrderingComposer
    extends Composer<_$FveloxDatabase, $PaymentSummaryTableTable> {
  $$PaymentSummaryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountMinor => $composableBuilder(
    column: $table.totalAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentSummaryTableTableAnnotationComposer
    extends Composer<_$FveloxDatabase, $PaymentSummaryTableTable> {
  $$PaymentSummaryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmountMinor => $composableBuilder(
    column: $table.totalAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PaymentSummaryTableTableTableManager
    extends
        RootTableManager<
          _$FveloxDatabase,
          $PaymentSummaryTableTable,
          PaymentSummaryTableData,
          $$PaymentSummaryTableTableFilterComposer,
          $$PaymentSummaryTableTableOrderingComposer,
          $$PaymentSummaryTableTableAnnotationComposer,
          $$PaymentSummaryTableTableCreateCompanionBuilder,
          $$PaymentSummaryTableTableUpdateCompanionBuilder,
          (
            PaymentSummaryTableData,
            BaseReferences<
              _$FveloxDatabase,
              $PaymentSummaryTableTable,
              PaymentSummaryTableData
            >,
          ),
          PaymentSummaryTableData,
          PrefetchHooks Function()
        > {
  $$PaymentSummaryTableTableTableManager(
    _$FveloxDatabase db,
    $PaymentSummaryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentSummaryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentSummaryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PaymentSummaryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> month = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<int> totalAmountMinor = const Value.absent(),
                Value<int> paymentCount = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentSummaryTableCompanion(
                month: month,
                currency: currency,
                totalAmount: totalAmount,
                totalAmountMinor: totalAmountMinor,
                paymentCount: paymentCount,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String month,
                required String currency,
                required double totalAmount,
                required int totalAmountMinor,
                required int paymentCount,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentSummaryTableCompanion.insert(
                month: month,
                currency: currency,
                totalAmount: totalAmount,
                totalAmountMinor: totalAmountMinor,
                paymentCount: paymentCount,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentSummaryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$FveloxDatabase,
      $PaymentSummaryTableTable,
      PaymentSummaryTableData,
      $$PaymentSummaryTableTableFilterComposer,
      $$PaymentSummaryTableTableOrderingComposer,
      $$PaymentSummaryTableTableAnnotationComposer,
      $$PaymentSummaryTableTableCreateCompanionBuilder,
      $$PaymentSummaryTableTableUpdateCompanionBuilder,
      (
        PaymentSummaryTableData,
        BaseReferences<
          _$FveloxDatabase,
          $PaymentSummaryTableTable,
          PaymentSummaryTableData
        >,
      ),
      PaymentSummaryTableData,
      PrefetchHooks Function()
    >;

class $FveloxDatabaseManager {
  final _$FveloxDatabase _db;
  $FveloxDatabaseManager(this._db);
  $$PaymentTableTableTableManager get paymentTable =>
      $$PaymentTableTableTableManager(_db, _db.paymentTable);
  $$PaymentFeatureTableTableTableManager get paymentFeatureTable =>
      $$PaymentFeatureTableTableTableManager(_db, _db.paymentFeatureTable);
  $$PaymentSummaryTableTableTableManager get paymentSummaryTable =>
      $$PaymentSummaryTableTableTableManager(_db, _db.paymentSummaryTable);
}
