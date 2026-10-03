// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FoldersTable extends Folders with TableInfo<$FoldersTable, FolderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<FolderRow> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FolderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class FolderRow extends DataClass implements Insertable<FolderRow> {
  final String id;
  final String name;
  const FolderRow({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(id: Value(id), name: Value(name));
  }

  factory FolderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  FolderRow copyWith({String? id, String? name}) =>
      FolderRow(id: id ?? this.id, name: name ?? this.name);
  FolderRow copyWithCompanion(FoldersCompanion data) {
    return FolderRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderRow(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderRow && other.id == this.id && other.name == this.name);
}

class FoldersCompanion extends UpdateCompanion<FolderRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<FolderRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, DocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<String> folderId = GeneratedColumn<String>(
    'folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES folders (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _ocrTextMeta = const VerificationMeta(
    'ocrText',
  );
  @override
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
    'ocr_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($DocumentsTable.$convertertags);
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    updatedAt,
    folderId,
    ocrText,
    tags,
    trashedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    }
    if (data.containsKey('ocr_text')) {
      context.handle(
        _ocrTextMeta,
        ocrText.isAcceptableOrUnknown(data['ocr_text']!, _ocrTextMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_id'],
      ),
      ocrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_text'],
      )!,
      tags: $DocumentsTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trashed_at'],
      ),
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
}

class DocumentRow extends DataClass implements Insertable<DocumentRow> {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? folderId;
  final String ocrText;
  final List<String> tags;

  /// Soft-delete marker. A trashed document is hidden everywhere, can be
  /// restored (undo) and is purged, files included, after a grace period.
  final DateTime? trashedAt;
  const DocumentRow({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.folderId,
    required this.ocrText,
    required this.tags,
    this.trashedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || folderId != null) {
      map['folder_id'] = Variable<String>(folderId);
    }
    map['ocr_text'] = Variable<String>(ocrText);
    {
      map['tags'] = Variable<String>(
        $DocumentsTable.$convertertags.toSql(tags),
      );
    }
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<DateTime>(trashedAt);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      ocrText: Value(ocrText),
      tags: Value(tags),
      trashedAt: trashedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trashedAt),
    );
  }

  factory DocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      folderId: serializer.fromJson<String?>(json['folderId']),
      ocrText: serializer.fromJson<String>(json['ocrText']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      trashedAt: serializer.fromJson<DateTime?>(json['trashedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'folderId': serializer.toJson<String?>(folderId),
      'ocrText': serializer.toJson<String>(ocrText),
      'tags': serializer.toJson<List<String>>(tags),
      'trashedAt': serializer.toJson<DateTime?>(trashedAt),
    };
  }

  DocumentRow copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> folderId = const Value.absent(),
    String? ocrText,
    List<String>? tags,
    Value<DateTime?> trashedAt = const Value.absent(),
  }) => DocumentRow(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    folderId: folderId.present ? folderId.value : this.folderId,
    ocrText: ocrText ?? this.ocrText,
    tags: tags ?? this.tags,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
  );
  DocumentRow copyWithCompanion(DocumentsCompanion data) {
    return DocumentRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      tags: data.tags.present ? data.tags.value : this.tags,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('folderId: $folderId, ')
          ..write('ocrText: $ocrText, ')
          ..write('tags: $tags, ')
          ..write('trashedAt: $trashedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    createdAt,
    updatedAt,
    folderId,
    ocrText,
    tags,
    trashedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.folderId == this.folderId &&
          other.ocrText == this.ocrText &&
          other.tags == this.tags &&
          other.trashedAt == this.trashedAt);
}

class DocumentsCompanion extends UpdateCompanion<DocumentRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> folderId;
  final Value<String> ocrText;
  final Value<List<String>> tags;
  final Value<DateTime?> trashedAt;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.folderId = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.tags = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.folderId = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.tags = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DocumentRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? folderId,
    Expression<String>? ocrText,
    Expression<String>? tags,
    Expression<DateTime>? trashedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (folderId != null) 'folder_id': folderId,
      if (ocrText != null) 'ocr_text': ocrText,
      if (tags != null) 'tags': tags,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? folderId,
    Value<String>? ocrText,
    Value<List<String>>? tags,
    Value<DateTime?>? trashedAt,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      folderId: folderId ?? this.folderId,
      ocrText: ocrText ?? this.ocrText,
      tags: tags ?? this.tags,
      trashedAt: trashedAt ?? this.trashedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<String>(folderId.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $DocumentsTable.$convertertags.toSql(tags.value),
      );
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('folderId: $folderId, ')
          ..write('ocrText: $ocrText, ')
          ..write('tags: $tags, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PagesTable extends Pages with TableInfo<$PagesTable, PageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalPathMeta = const VerificationMeta(
    'originalPath',
  );
  @override
  late final GeneratedColumn<String> originalPath = GeneratedColumn<String>(
    'original_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editedPathMeta = const VerificationMeta(
    'editedPath',
  );
  @override
  late final GeneratedColumn<String> editedPath = GeneratedColumn<String>(
    'edited_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filterMeta = const VerificationMeta('filter');
  @override
  late final GeneratedColumn<String> filter = GeneratedColumn<String>(
    'filter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('original'),
  );
  static const VerificationMeta _rotationMeta = const VerificationMeta(
    'rotation',
  );
  @override
  late final GeneratedColumn<int> rotation = GeneratedColumn<int>(
    'rotation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cropJsonMeta = const VerificationMeta(
    'cropJson',
  );
  @override
  late final GeneratedColumn<String> cropJson = GeneratedColumn<String>(
    'crop_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ocrBlocksJsonMeta = const VerificationMeta(
    'ocrBlocksJson',
  );
  @override
  late final GeneratedColumn<String> ocrBlocksJson = GeneratedColumn<String>(
    'ocr_blocks_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    documentId,
    position,
    originalPath,
    editedPath,
    filter,
    rotation,
    cropJson,
    ocrBlocksJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('original_path')) {
      context.handle(
        _originalPathMeta,
        originalPath.isAcceptableOrUnknown(
          data['original_path']!,
          _originalPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalPathMeta);
    }
    if (data.containsKey('edited_path')) {
      context.handle(
        _editedPathMeta,
        editedPath.isAcceptableOrUnknown(data['edited_path']!, _editedPathMeta),
      );
    }
    if (data.containsKey('filter')) {
      context.handle(
        _filterMeta,
        filter.isAcceptableOrUnknown(data['filter']!, _filterMeta),
      );
    }
    if (data.containsKey('rotation')) {
      context.handle(
        _rotationMeta,
        rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta),
      );
    }
    if (data.containsKey('crop_json')) {
      context.handle(
        _cropJsonMeta,
        cropJson.isAcceptableOrUnknown(data['crop_json']!, _cropJsonMeta),
      );
    }
    if (data.containsKey('ocr_blocks_json')) {
      context.handle(
        _ocrBlocksJsonMeta,
        ocrBlocksJson.isAcceptableOrUnknown(
          data['ocr_blocks_json']!,
          _ocrBlocksJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      originalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_path'],
      )!,
      editedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_path'],
      ),
      filter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filter'],
      )!,
      rotation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rotation'],
      )!,
      cropJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_json'],
      ),
      ocrBlocksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_blocks_json'],
      ),
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class PageRow extends DataClass implements Insertable<PageRow> {
  final String id;
  final String documentId;

  /// Zero-based position inside the document ("order" is an SQL keyword).
  final int position;

  /// Untouched capture. Never overwritten.
  final String originalPath;

  /// Rendered result of crop + filter + rotation. Null until first render.
  final String? editedPath;
  final String filter;
  final int rotation;

  /// Normalised crop corners (tl, tr, br, bl) as JSON, null = full image.
  final String? cropJson;

  /// OCR line boxes of the edited image, used for the PDF text layer.
  final String? ocrBlocksJson;
  const PageRow({
    required this.id,
    required this.documentId,
    required this.position,
    required this.originalPath,
    this.editedPath,
    required this.filter,
    required this.rotation,
    this.cropJson,
    this.ocrBlocksJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['document_id'] = Variable<String>(documentId);
    map['position'] = Variable<int>(position);
    map['original_path'] = Variable<String>(originalPath);
    if (!nullToAbsent || editedPath != null) {
      map['edited_path'] = Variable<String>(editedPath);
    }
    map['filter'] = Variable<String>(filter);
    map['rotation'] = Variable<int>(rotation);
    if (!nullToAbsent || cropJson != null) {
      map['crop_json'] = Variable<String>(cropJson);
    }
    if (!nullToAbsent || ocrBlocksJson != null) {
      map['ocr_blocks_json'] = Variable<String>(ocrBlocksJson);
    }
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      documentId: Value(documentId),
      position: Value(position),
      originalPath: Value(originalPath),
      editedPath: editedPath == null && nullToAbsent
          ? const Value.absent()
          : Value(editedPath),
      filter: Value(filter),
      rotation: Value(rotation),
      cropJson: cropJson == null && nullToAbsent
          ? const Value.absent()
          : Value(cropJson),
      ocrBlocksJson: ocrBlocksJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrBlocksJson),
    );
  }

  factory PageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PageRow(
      id: serializer.fromJson<String>(json['id']),
      documentId: serializer.fromJson<String>(json['documentId']),
      position: serializer.fromJson<int>(json['position']),
      originalPath: serializer.fromJson<String>(json['originalPath']),
      editedPath: serializer.fromJson<String?>(json['editedPath']),
      filter: serializer.fromJson<String>(json['filter']),
      rotation: serializer.fromJson<int>(json['rotation']),
      cropJson: serializer.fromJson<String?>(json['cropJson']),
      ocrBlocksJson: serializer.fromJson<String?>(json['ocrBlocksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'documentId': serializer.toJson<String>(documentId),
      'position': serializer.toJson<int>(position),
      'originalPath': serializer.toJson<String>(originalPath),
      'editedPath': serializer.toJson<String?>(editedPath),
      'filter': serializer.toJson<String>(filter),
      'rotation': serializer.toJson<int>(rotation),
      'cropJson': serializer.toJson<String?>(cropJson),
      'ocrBlocksJson': serializer.toJson<String?>(ocrBlocksJson),
    };
  }

  PageRow copyWith({
    String? id,
    String? documentId,
    int? position,
    String? originalPath,
    Value<String?> editedPath = const Value.absent(),
    String? filter,
    int? rotation,
    Value<String?> cropJson = const Value.absent(),
    Value<String?> ocrBlocksJson = const Value.absent(),
  }) => PageRow(
    id: id ?? this.id,
    documentId: documentId ?? this.documentId,
    position: position ?? this.position,
    originalPath: originalPath ?? this.originalPath,
    editedPath: editedPath.present ? editedPath.value : this.editedPath,
    filter: filter ?? this.filter,
    rotation: rotation ?? this.rotation,
    cropJson: cropJson.present ? cropJson.value : this.cropJson,
    ocrBlocksJson: ocrBlocksJson.present
        ? ocrBlocksJson.value
        : this.ocrBlocksJson,
  );
  PageRow copyWithCompanion(PagesCompanion data) {
    return PageRow(
      id: data.id.present ? data.id.value : this.id,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      position: data.position.present ? data.position.value : this.position,
      originalPath: data.originalPath.present
          ? data.originalPath.value
          : this.originalPath,
      editedPath: data.editedPath.present
          ? data.editedPath.value
          : this.editedPath,
      filter: data.filter.present ? data.filter.value : this.filter,
      rotation: data.rotation.present ? data.rotation.value : this.rotation,
      cropJson: data.cropJson.present ? data.cropJson.value : this.cropJson,
      ocrBlocksJson: data.ocrBlocksJson.present
          ? data.ocrBlocksJson.value
          : this.ocrBlocksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PageRow(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('position: $position, ')
          ..write('originalPath: $originalPath, ')
          ..write('editedPath: $editedPath, ')
          ..write('filter: $filter, ')
          ..write('rotation: $rotation, ')
          ..write('cropJson: $cropJson, ')
          ..write('ocrBlocksJson: $ocrBlocksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    documentId,
    position,
    originalPath,
    editedPath,
    filter,
    rotation,
    cropJson,
    ocrBlocksJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PageRow &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.position == this.position &&
          other.originalPath == this.originalPath &&
          other.editedPath == this.editedPath &&
          other.filter == this.filter &&
          other.rotation == this.rotation &&
          other.cropJson == this.cropJson &&
          other.ocrBlocksJson == this.ocrBlocksJson);
}

class PagesCompanion extends UpdateCompanion<PageRow> {
  final Value<String> id;
  final Value<String> documentId;
  final Value<int> position;
  final Value<String> originalPath;
  final Value<String?> editedPath;
  final Value<String> filter;
  final Value<int> rotation;
  final Value<String?> cropJson;
  final Value<String?> ocrBlocksJson;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.position = const Value.absent(),
    this.originalPath = const Value.absent(),
    this.editedPath = const Value.absent(),
    this.filter = const Value.absent(),
    this.rotation = const Value.absent(),
    this.cropJson = const Value.absent(),
    this.ocrBlocksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String documentId,
    required int position,
    required String originalPath,
    this.editedPath = const Value.absent(),
    this.filter = const Value.absent(),
    this.rotation = const Value.absent(),
    this.cropJson = const Value.absent(),
    this.ocrBlocksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentId = Value(documentId),
       position = Value(position),
       originalPath = Value(originalPath);
  static Insertable<PageRow> custom({
    Expression<String>? id,
    Expression<String>? documentId,
    Expression<int>? position,
    Expression<String>? originalPath,
    Expression<String>? editedPath,
    Expression<String>? filter,
    Expression<int>? rotation,
    Expression<String>? cropJson,
    Expression<String>? ocrBlocksJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (position != null) 'position': position,
      if (originalPath != null) 'original_path': originalPath,
      if (editedPath != null) 'edited_path': editedPath,
      if (filter != null) 'filter': filter,
      if (rotation != null) 'rotation': rotation,
      if (cropJson != null) 'crop_json': cropJson,
      if (ocrBlocksJson != null) 'ocr_blocks_json': ocrBlocksJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith({
    Value<String>? id,
    Value<String>? documentId,
    Value<int>? position,
    Value<String>? originalPath,
    Value<String?>? editedPath,
    Value<String>? filter,
    Value<int>? rotation,
    Value<String?>? cropJson,
    Value<String?>? ocrBlocksJson,
    Value<int>? rowid,
  }) {
    return PagesCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      position: position ?? this.position,
      originalPath: originalPath ?? this.originalPath,
      editedPath: editedPath ?? this.editedPath,
      filter: filter ?? this.filter,
      rotation: rotation ?? this.rotation,
      cropJson: cropJson ?? this.cropJson,
      ocrBlocksJson: ocrBlocksJson ?? this.ocrBlocksJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (originalPath.present) {
      map['original_path'] = Variable<String>(originalPath.value);
    }
    if (editedPath.present) {
      map['edited_path'] = Variable<String>(editedPath.value);
    }
    if (filter.present) {
      map['filter'] = Variable<String>(filter.value);
    }
    if (rotation.present) {
      map['rotation'] = Variable<int>(rotation.value);
    }
    if (cropJson.present) {
      map['crop_json'] = Variable<String>(cropJson.value);
    }
    if (ocrBlocksJson.present) {
      map['ocr_blocks_json'] = Variable<String>(ocrBlocksJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('position: $position, ')
          ..write('originalPath: $originalPath, ')
          ..write('editedPath: $editedPath, ')
          ..write('filter: $filter, ')
          ..write('rotation: $rotation, ')
          ..write('cropJson: $cropJson, ')
          ..write('ocrBlocksJson: $ocrBlocksJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PacketsTable extends Packets with TableInfo<$PacketsTable, PacketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PacketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    id,
    templateId,
    title,
    purpose,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packets';
  @override
  VerificationContext validateIntegrity(
    Insertable<PacketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PacketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PacketRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PacketsTable createAlias(String alias) {
    return $PacketsTable(attachedDatabase, alias);
  }
}

class PacketRow extends DataClass implements Insertable<PacketRow> {
  final String id;
  final String templateId;
  final String title;
  final String purpose;
  final DateTime createdAt;
  const PacketRow({
    required this.id,
    required this.templateId,
    required this.title,
    required this.purpose,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['title'] = Variable<String>(title);
    map['purpose'] = Variable<String>(purpose);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PacketsCompanion toCompanion(bool nullToAbsent) {
    return PacketsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      title: Value(title),
      purpose: Value(purpose),
      createdAt: Value(createdAt),
    );
  }

  factory PacketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PacketRow(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      title: serializer.fromJson<String>(json['title']),
      purpose: serializer.fromJson<String>(json['purpose']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'title': serializer.toJson<String>(title),
      'purpose': serializer.toJson<String>(purpose),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PacketRow copyWith({
    String? id,
    String? templateId,
    String? title,
    String? purpose,
    DateTime? createdAt,
  }) => PacketRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    title: title ?? this.title,
    purpose: purpose ?? this.purpose,
    createdAt: createdAt ?? this.createdAt,
  );
  PacketRow copyWithCompanion(PacketsCompanion data) {
    return PacketRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      title: data.title.present ? data.title.value : this.title,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PacketRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('title: $title, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, title, purpose, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PacketRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.title == this.title &&
          other.purpose == this.purpose &&
          other.createdAt == this.createdAt);
}

class PacketsCompanion extends UpdateCompanion<PacketRow> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> title;
  final Value<String> purpose;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PacketsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.title = const Value.absent(),
    this.purpose = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PacketsCompanion.insert({
    required String id,
    required String templateId,
    required String title,
    this.purpose = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<PacketRow> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? title,
    Expression<String>? purpose,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (title != null) 'title': title,
      if (purpose != null) 'purpose': purpose,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PacketsCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? title,
    Value<String>? purpose,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PacketsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      title: title ?? this.title,
      purpose: purpose ?? this.purpose,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
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
    return (StringBuffer('PacketsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('title: $title, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PacketItemsTable extends PacketItems
    with TableInfo<$PacketItemsTable, PacketItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PacketItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packetIdMeta = const VerificationMeta(
    'packetId',
  );
  @override
  late final GeneratedColumn<String> packetId = GeneratedColumn<String>(
    'packet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES packets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _requirementNameMeta = const VerificationMeta(
    'requirementName',
  );
  @override
  late final GeneratedColumn<String> requirementName = GeneratedColumn<String>(
    'requirement_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('missing'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packetId,
    requirementName,
    documentId,
    status,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packet_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PacketItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('packet_id')) {
      context.handle(
        _packetIdMeta,
        packetId.isAcceptableOrUnknown(data['packet_id']!, _packetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packetIdMeta);
    }
    if (data.containsKey('requirement_name')) {
      context.handle(
        _requirementNameMeta,
        requirementName.isAcceptableOrUnknown(
          data['requirement_name']!,
          _requirementNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requirementNameMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PacketItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PacketItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}packet_id'],
      )!,
      requirementName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requirement_name'],
      )!,
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $PacketItemsTable createAlias(String alias) {
    return $PacketItemsTable(attachedDatabase, alias);
  }
}

class PacketItemRow extends DataClass implements Insertable<PacketItemRow> {
  final String id;
  final String packetId;
  final String requirementName;
  final String? documentId;

  /// missing | added | needsReview
  final String status;
  final int position;
  const PacketItemRow({
    required this.id,
    required this.packetId,
    required this.requirementName,
    this.documentId,
    required this.status,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['packet_id'] = Variable<String>(packetId);
    map['requirement_name'] = Variable<String>(requirementName);
    if (!nullToAbsent || documentId != null) {
      map['document_id'] = Variable<String>(documentId);
    }
    map['status'] = Variable<String>(status);
    map['position'] = Variable<int>(position);
    return map;
  }

  PacketItemsCompanion toCompanion(bool nullToAbsent) {
    return PacketItemsCompanion(
      id: Value(id),
      packetId: Value(packetId),
      requirementName: Value(requirementName),
      documentId: documentId == null && nullToAbsent
          ? const Value.absent()
          : Value(documentId),
      status: Value(status),
      position: Value(position),
    );
  }

  factory PacketItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PacketItemRow(
      id: serializer.fromJson<String>(json['id']),
      packetId: serializer.fromJson<String>(json['packetId']),
      requirementName: serializer.fromJson<String>(json['requirementName']),
      documentId: serializer.fromJson<String?>(json['documentId']),
      status: serializer.fromJson<String>(json['status']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packetId': serializer.toJson<String>(packetId),
      'requirementName': serializer.toJson<String>(requirementName),
      'documentId': serializer.toJson<String?>(documentId),
      'status': serializer.toJson<String>(status),
      'position': serializer.toJson<int>(position),
    };
  }

  PacketItemRow copyWith({
    String? id,
    String? packetId,
    String? requirementName,
    Value<String?> documentId = const Value.absent(),
    String? status,
    int? position,
  }) => PacketItemRow(
    id: id ?? this.id,
    packetId: packetId ?? this.packetId,
    requirementName: requirementName ?? this.requirementName,
    documentId: documentId.present ? documentId.value : this.documentId,
    status: status ?? this.status,
    position: position ?? this.position,
  );
  PacketItemRow copyWithCompanion(PacketItemsCompanion data) {
    return PacketItemRow(
      id: data.id.present ? data.id.value : this.id,
      packetId: data.packetId.present ? data.packetId.value : this.packetId,
      requirementName: data.requirementName.present
          ? data.requirementName.value
          : this.requirementName,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      status: data.status.present ? data.status.value : this.status,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PacketItemRow(')
          ..write('id: $id, ')
          ..write('packetId: $packetId, ')
          ..write('requirementName: $requirementName, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packetId, requirementName, documentId, status, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PacketItemRow &&
          other.id == this.id &&
          other.packetId == this.packetId &&
          other.requirementName == this.requirementName &&
          other.documentId == this.documentId &&
          other.status == this.status &&
          other.position == this.position);
}

class PacketItemsCompanion extends UpdateCompanion<PacketItemRow> {
  final Value<String> id;
  final Value<String> packetId;
  final Value<String> requirementName;
  final Value<String?> documentId;
  final Value<String> status;
  final Value<int> position;
  final Value<int> rowid;
  const PacketItemsCompanion({
    this.id = const Value.absent(),
    this.packetId = const Value.absent(),
    this.requirementName = const Value.absent(),
    this.documentId = const Value.absent(),
    this.status = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PacketItemsCompanion.insert({
    required String id,
    required String packetId,
    required String requirementName,
    this.documentId = const Value.absent(),
    this.status = const Value.absent(),
    required int position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packetId = Value(packetId),
       requirementName = Value(requirementName),
       position = Value(position);
  static Insertable<PacketItemRow> custom({
    Expression<String>? id,
    Expression<String>? packetId,
    Expression<String>? requirementName,
    Expression<String>? documentId,
    Expression<String>? status,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packetId != null) 'packet_id': packetId,
      if (requirementName != null) 'requirement_name': requirementName,
      if (documentId != null) 'document_id': documentId,
      if (status != null) 'status': status,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PacketItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? packetId,
    Value<String>? requirementName,
    Value<String?>? documentId,
    Value<String>? status,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return PacketItemsCompanion(
      id: id ?? this.id,
      packetId: packetId ?? this.packetId,
      requirementName: requirementName ?? this.requirementName,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packetId.present) {
      map['packet_id'] = Variable<String>(packetId.value);
    }
    if (requirementName.present) {
      map['requirement_name'] = Variable<String>(requirementName.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PacketItemsCompanion(')
          ..write('id: $id, ')
          ..write('packetId: $packetId, ')
          ..write('requirementName: $requirementName, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('global'),
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, region, itemsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRow> instance, {
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
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final String id;
  final String name;
  final String region;
  final String itemsJson;
  const TemplateRow({
    required this.id,
    required this.name,
    required this.region,
    required this.itemsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['region'] = Variable<String>(region);
    map['items_json'] = Variable<String>(itemsJson);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      name: Value(name),
      region: Value(region),
      itemsJson: Value(itemsJson),
    );
  }

  factory TemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      region: serializer.fromJson<String>(json['region']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'region': serializer.toJson<String>(region),
      'itemsJson': serializer.toJson<String>(itemsJson),
    };
  }

  TemplateRow copyWith({
    String? id,
    String? name,
    String? region,
    String? itemsJson,
  }) => TemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    region: region ?? this.region,
    itemsJson: itemsJson ?? this.itemsJson,
  );
  TemplateRow copyWithCompanion(TemplatesCompanion data) {
    return TemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      region: data.region.present ? data.region.value : this.region,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('itemsJson: $itemsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, region, itemsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.region == this.region &&
          other.itemsJson == this.itemsJson);
}

class TemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> region;
  final Value<String> itemsJson;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.region = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    required String id,
    required String name,
    this.region = const Value.absent(),
    required String itemsJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       itemsJson = Value(itemsJson);
  static Insertable<TemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? region,
    Expression<String>? itemsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (region != null) 'region': region,
      if (itemsJson != null) 'items_json': itemsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? region,
    Value<String>? itemsJson,
    Value<int>? rowid,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      itemsJson: itemsJson ?? this.itemsJson,
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
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('region: $region, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SignaturesTable extends Signatures
    with TableInfo<$SignaturesTable, SignatureRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SignaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedPathMeta = const VerificationMeta(
    'encryptedPath',
  );
  @override
  late final GeneratedColumn<String> encryptedPath = GeneratedColumn<String>(
    'encrypted_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, encryptedPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'signatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<SignatureRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('encrypted_path')) {
      context.handle(
        _encryptedPathMeta,
        encryptedPath.isAcceptableOrUnknown(
          data['encrypted_path']!,
          _encryptedPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedPathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SignatureRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SignatureRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      encryptedPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_path'],
      )!,
    );
  }

  @override
  $SignaturesTable createAlias(String alias) {
    return $SignaturesTable(attachedDatabase, alias);
  }
}

class SignatureRow extends DataClass implements Insertable<SignatureRow> {
  final String id;
  final String encryptedPath;
  const SignatureRow({required this.id, required this.encryptedPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['encrypted_path'] = Variable<String>(encryptedPath);
    return map;
  }

  SignaturesCompanion toCompanion(bool nullToAbsent) {
    return SignaturesCompanion(
      id: Value(id),
      encryptedPath: Value(encryptedPath),
    );
  }

  factory SignatureRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SignatureRow(
      id: serializer.fromJson<String>(json['id']),
      encryptedPath: serializer.fromJson<String>(json['encryptedPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'encryptedPath': serializer.toJson<String>(encryptedPath),
    };
  }

  SignatureRow copyWith({String? id, String? encryptedPath}) => SignatureRow(
    id: id ?? this.id,
    encryptedPath: encryptedPath ?? this.encryptedPath,
  );
  SignatureRow copyWithCompanion(SignaturesCompanion data) {
    return SignatureRow(
      id: data.id.present ? data.id.value : this.id,
      encryptedPath: data.encryptedPath.present
          ? data.encryptedPath.value
          : this.encryptedPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SignatureRow(')
          ..write('id: $id, ')
          ..write('encryptedPath: $encryptedPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, encryptedPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignatureRow &&
          other.id == this.id &&
          other.encryptedPath == this.encryptedPath);
}

class SignaturesCompanion extends UpdateCompanion<SignatureRow> {
  final Value<String> id;
  final Value<String> encryptedPath;
  final Value<int> rowid;
  const SignaturesCompanion({
    this.id = const Value.absent(),
    this.encryptedPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SignaturesCompanion.insert({
    required String id,
    required String encryptedPath,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       encryptedPath = Value(encryptedPath);
  static Insertable<SignatureRow> custom({
    Expression<String>? id,
    Expression<String>? encryptedPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (encryptedPath != null) 'encrypted_path': encryptedPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SignaturesCompanion copyWith({
    Value<String>? id,
    Value<String>? encryptedPath,
    Value<int>? rowid,
  }) {
    return SignaturesCompanion(
      id: id ?? this.id,
      encryptedPath: encryptedPath ?? this.encryptedPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (encryptedPath.present) {
      map['encrypted_path'] = Variable<String>(encryptedPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SignaturesCompanion(')
          ..write('id: $id, ')
          ..write('encryptedPath: $encryptedPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $PacketsTable packets = $PacketsTable(this);
  late final $PacketItemsTable packetItems = $PacketItemsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $SignaturesTable signatures = $SignaturesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index settingsKey = Index(
    'settings_key',
    'CREATE INDEX settings_key ON settings ("key")',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    folders,
    documents,
    pages,
    packets,
    packetItems,
    templates,
    signatures,
    appSettings,
    settingsKey,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('documents', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'packets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('packet_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'documents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('packet_items', kind: UpdateKind.update)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  required String id,
  required String name,
  Value<int> rowid,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> rowid,
});

final class $$FoldersTableReferences
    extends BaseReferences<_$AppDatabase, $FoldersTable, FolderRow> {
  $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DocumentsTable, List<DocumentRow>>
  _documentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'folders__id__documents__folder_id',
  );

  $$DocumentsTableProcessedTableManager get documentsRefs {
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
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

  Expression<bool> documentsRefs(
    Expression<bool> Function($$DocumentsTableFilterComposer f) f,
  ) {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
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
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
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

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($$DocumentsTableAnnotationComposer a) f,
  ) {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          FolderRow,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (FolderRow, $$FoldersTableReferences),
          FolderRow,
          PrefetchHooks Function({bool documentsRefs})
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => FoldersCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) => FoldersCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoldersTable, FolderRow>(table),
                  $$FoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (documentsRefs) db.documents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (documentsRefs)
                    await $_getPrefetchedData<
                      FolderRow,
                      $FoldersTable,
                      DocumentRow
                    >(
                      currentTable: table,
                      referencedTable: $$FoldersTableReferences
                          ._documentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FoldersTableReferences(db, table, p0).documentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      FolderRow,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (FolderRow, $$FoldersTableReferences),
      FolderRow,
      PrefetchHooks Function({bool documentsRefs})
    >;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  required String id,
  required String title,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> folderId,
  Value<String> ocrText,
  Value<List<String>> tags,
  Value<DateTime?> trashedAt,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> folderId,
  Value<String> ocrText,
  Value<List<String>> tags,
  Value<DateTime?> trashedAt,
  Value<int> rowid,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentsTable, DocumentRow> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderIdTable(_$AppDatabase db) =>
      db.folders.createAlias('documents__folder_id__folders__id');

  $$FoldersTableProcessedTableManager? get folderId {
    final $_column = $_itemColumn<String>('folder_id');
    if ($_column == null) return null;
    final manager = $$FoldersTableTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PagesTable, List<PageRow>> _pagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pages,
    aliasName: 'documents__id__pages__document_id',
  );

  $$PagesTableProcessedTableManager get pagesRefs {
    final manager = $$PagesTableTableManager(
      $_db,
      $_db.pages,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PacketItemsTable, List<PacketItemRow>>
  _packetItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packetItems,
    aliasName: 'documents__id__packet_items__document_id',
  );

  $$PacketItemsTableProcessedTableManager get packetItemsRefs {
    final manager = $$PacketItemsTableTableManager(
      $_db,
      $_db.packetItems,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_packetItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnFilters<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FoldersTableFilterComposer get folderId {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pagesRefs(
    Expression<bool> Function($$PagesTableFilterComposer f) f,
  ) {
    final $$PagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableFilterComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> packetItemsRefs(
    Expression<bool> Function($$PacketItemsTableFilterComposer f) f,
  ) {
    final $$PacketItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packetItems,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketItemsTableFilterComposer(
            $db: $db,
            $table: $db.packetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
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

  ColumnOrderings<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoldersTableOrderingComposer get folderId {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get ocrText =>
      $composableBuilder(column: $table.ocrText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  $$FoldersTableAnnotationComposer get folderId {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pagesRefs<T extends Object>(
    Expression<T> Function($$PagesTableAnnotationComposer a) f,
  ) {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pages,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagesTableAnnotationComposer(
            $db: $db,
            $table: $db.pages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> packetItemsRefs<T extends Object>(
    Expression<T> Function($$PacketItemsTableAnnotationComposer a) f,
  ) {
    final $$PacketItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packetItems,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.packetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          DocumentRow,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (DocumentRow, $$DocumentsTableReferences),
          DocumentRow,
          PrefetchHooks Function({
            bool folderId,
            bool pagesRefs,
            bool packetItemsRefs,
          })
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> folderId = const Value.absent(),
                Value<String> ocrText = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                folderId: folderId,
                ocrText: ocrText,
                tags: tags,
                trashedAt: trashedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> folderId = const Value.absent(),
                Value<String> ocrText = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                folderId: folderId,
                ocrText: ocrText,
                tags: tags,
                trashedAt: trashedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentsTable, DocumentRow>(table),
                  $$DocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({folderId = false, pagesRefs = false, packetItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pagesRefs) db.pages,
                    if (packetItemsRefs) db.packetItems,
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
                        if (folderId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.folderId,
                            referencedTable: $$DocumentsTableReferences
                                ._folderIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._folderIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pagesRefs)
                        await $_getPrefetchedData<
                          DocumentRow,
                          $DocumentsTable,
                          PageRow
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._pagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).pagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.documentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (packetItemsRefs)
                        await $_getPrefetchedData<
                          DocumentRow,
                          $DocumentsTable,
                          PacketItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._packetItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).packetItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.documentId == item.id,
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

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      DocumentRow,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (DocumentRow, $$DocumentsTableReferences),
      DocumentRow,
      PrefetchHooks Function({
        bool folderId,
        bool pagesRefs,
        bool packetItemsRefs,
      })
    >;
typedef $$PagesTableCreateCompanionBuilder = PagesCompanion Function({
  required String id,
  required String documentId,
  required int position,
  required String originalPath,
  Value<String?> editedPath,
  Value<String> filter,
  Value<int> rotation,
  Value<String?> cropJson,
  Value<String?> ocrBlocksJson,
  Value<int> rowid,
});
typedef $$PagesTableUpdateCompanionBuilder = PagesCompanion Function({
  Value<String> id,
  Value<String> documentId,
  Value<int> position,
  Value<String> originalPath,
  Value<String?> editedPath,
  Value<String> filter,
  Value<int> rotation,
  Value<String?> cropJson,
  Value<String?> ocrBlocksJson,
  Value<int> rowid,
});

final class $$PagesTableReferences
    extends BaseReferences<_$AppDatabase, $PagesTable, PageRow> {
  $$PagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('pages__document_id__documents__id');

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PagesTableFilterComposer extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedPath => $composableBuilder(
    column: $table.editedPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropJson => $composableBuilder(
    column: $table.cropJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrBlocksJson => $composableBuilder(
    column: $table.ocrBlocksJson,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedPath => $composableBuilder(
    column: $table.editedPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filter => $composableBuilder(
    column: $table.filter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rotation => $composableBuilder(
    column: $table.rotation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropJson => $composableBuilder(
    column: $table.cropJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrBlocksJson => $composableBuilder(
    column: $table.ocrBlocksJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagesTable> {
  $$PagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get originalPath => $composableBuilder(
    column: $table.originalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editedPath => $composableBuilder(
    column: $table.editedPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filter =>
      $composableBuilder(column: $table.filter, builder: (column) => column);

  GeneratedColumn<int> get rotation =>
      $composableBuilder(column: $table.rotation, builder: (column) => column);

  GeneratedColumn<String> get cropJson =>
      $composableBuilder(column: $table.cropJson, builder: (column) => column);

  GeneratedColumn<String> get ocrBlocksJson => $composableBuilder(
    column: $table.ocrBlocksJson,
    builder: (column) => column,
  );

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagesTable,
          PageRow,
          $$PagesTableFilterComposer,
          $$PagesTableOrderingComposer,
          $$PagesTableAnnotationComposer,
          $$PagesTableCreateCompanionBuilder,
          $$PagesTableUpdateCompanionBuilder,
          (PageRow, $$PagesTableReferences),
          PageRow,
          PrefetchHooks Function({bool documentId})
        > {
  $$PagesTableTableManager(_$AppDatabase db, $PagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> originalPath = const Value.absent(),
                Value<String?> editedPath = const Value.absent(),
                Value<String> filter = const Value.absent(),
                Value<int> rotation = const Value.absent(),
                Value<String?> cropJson = const Value.absent(),
                Value<String?> ocrBlocksJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion(
                id: id,
                documentId: documentId,
                position: position,
                originalPath: originalPath,
                editedPath: editedPath,
                filter: filter,
                rotation: rotation,
                cropJson: cropJson,
                ocrBlocksJson: ocrBlocksJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String documentId,
                required int position,
                required String originalPath,
                Value<String?> editedPath = const Value.absent(),
                Value<String> filter = const Value.absent(),
                Value<int> rotation = const Value.absent(),
                Value<String?> cropJson = const Value.absent(),
                Value<String?> ocrBlocksJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PagesCompanion.insert(
                id: id,
                documentId: documentId,
                position: position,
                originalPath: originalPath,
                editedPath: editedPath,
                filter: filter,
                rotation: rotation,
                cropJson: cropJson,
                ocrBlocksJson: ocrBlocksJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PagesTable, PageRow>(table),
                  $$PagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
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
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$PagesTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$PagesTableReferences
                            ._documentIdTable(db)
                            .id,
                      ) as T;
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

typedef $$PagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagesTable,
      PageRow,
      $$PagesTableFilterComposer,
      $$PagesTableOrderingComposer,
      $$PagesTableAnnotationComposer,
      $$PagesTableCreateCompanionBuilder,
      $$PagesTableUpdateCompanionBuilder,
      (PageRow, $$PagesTableReferences),
      PageRow,
      PrefetchHooks Function({bool documentId})
    >;
typedef $$PacketsTableCreateCompanionBuilder = PacketsCompanion Function({
  required String id,
  required String templateId,
  required String title,
  Value<String> purpose,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PacketsTableUpdateCompanionBuilder = PacketsCompanion Function({
  Value<String> id,
  Value<String> templateId,
  Value<String> title,
  Value<String> purpose,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PacketsTableReferences
    extends BaseReferences<_$AppDatabase, $PacketsTable, PacketRow> {
  $$PacketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PacketItemsTable, List<PacketItemRow>>
  _packetItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.packetItems,
    aliasName: 'packets__id__packet_items__packet_id',
  );

  $$PacketItemsTableProcessedTableManager get packetItemsRefs {
    final manager = $$PacketItemsTableTableManager(
      $_db,
      $_db.packetItems,
    ).filter((f) => f.packetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_packetItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PacketsTableFilterComposer
    extends Composer<_$AppDatabase, $PacketsTable> {
  $$PacketsTableFilterComposer({
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

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> packetItemsRefs(
    Expression<bool> Function($$PacketItemsTableFilterComposer f) f,
  ) {
    final $$PacketItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packetItems,
      getReferencedColumn: (t) => t.packetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketItemsTableFilterComposer(
            $db: $db,
            $table: $db.packetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PacketsTableOrderingComposer
    extends Composer<_$AppDatabase, $PacketsTable> {
  $$PacketsTableOrderingComposer({
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

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PacketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PacketsTable> {
  $$PacketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> packetItemsRefs<T extends Object>(
    Expression<T> Function($$PacketItemsTableAnnotationComposer a) f,
  ) {
    final $$PacketItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.packetItems,
      getReferencedColumn: (t) => t.packetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.packetItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PacketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PacketsTable,
          PacketRow,
          $$PacketsTableFilterComposer,
          $$PacketsTableOrderingComposer,
          $$PacketsTableAnnotationComposer,
          $$PacketsTableCreateCompanionBuilder,
          $$PacketsTableUpdateCompanionBuilder,
          (PacketRow, $$PacketsTableReferences),
          PacketRow,
          PrefetchHooks Function({bool packetItemsRefs})
        > {
  $$PacketsTableTableManager(_$AppDatabase db, $PacketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PacketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PacketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PacketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PacketsCompanion(
                id: id,
                templateId: templateId,
                title: title,
                purpose: purpose,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String title,
                Value<String> purpose = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PacketsCompanion.insert(
                id: id,
                templateId: templateId,
                title: title,
                purpose: purpose,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PacketsTable, PacketRow>(table),
                  $$PacketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packetItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (packetItemsRefs) db.packetItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (packetItemsRefs)
                    await $_getPrefetchedData<
                      PacketRow,
                      $PacketsTable,
                      PacketItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$PacketsTableReferences
                          ._packetItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PacketsTableReferences(
                        db,
                        table,
                        p0,
                      ).packetItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.packetId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PacketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PacketsTable,
      PacketRow,
      $$PacketsTableFilterComposer,
      $$PacketsTableOrderingComposer,
      $$PacketsTableAnnotationComposer,
      $$PacketsTableCreateCompanionBuilder,
      $$PacketsTableUpdateCompanionBuilder,
      (PacketRow, $$PacketsTableReferences),
      PacketRow,
      PrefetchHooks Function({bool packetItemsRefs})
    >;
typedef $$PacketItemsTableCreateCompanionBuilder =
    PacketItemsCompanion Function({
      required String id,
      required String packetId,
      required String requirementName,
      Value<String?> documentId,
      Value<String> status,
      required int position,
      Value<int> rowid,
    });
typedef $$PacketItemsTableUpdateCompanionBuilder =
    PacketItemsCompanion Function({
      Value<String> id,
      Value<String> packetId,
      Value<String> requirementName,
      Value<String?> documentId,
      Value<String> status,
      Value<int> position,
      Value<int> rowid,
    });

final class $$PacketItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PacketItemsTable, PacketItemRow> {
  $$PacketItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PacketsTable _packetIdTable(_$AppDatabase db) =>
      db.packets.createAlias('packet_items__packet_id__packets__id');

  $$PacketsTableProcessedTableManager get packetId {
    final $_column = $_itemColumn<String>('packet_id')!;

    final manager = $$PacketsTableTableManager(
      $_db,
      $_db.packets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('packet_items__document_id__documents__id');

  $$DocumentsTableProcessedTableManager? get documentId {
    final $_column = $_itemColumn<String>('document_id');
    if ($_column == null) return null;
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PacketItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PacketItemsTable> {
  $$PacketItemsTableFilterComposer({
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

  ColumnFilters<String> get requirementName => $composableBuilder(
    column: $table.requirementName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$PacketsTableFilterComposer get packetId {
    final $$PacketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packetId,
      referencedTable: $db.packets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketsTableFilterComposer(
            $db: $db,
            $table: $db.packets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PacketItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PacketItemsTable> {
  $$PacketItemsTableOrderingComposer({
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

  ColumnOrderings<String> get requirementName => $composableBuilder(
    column: $table.requirementName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$PacketsTableOrderingComposer get packetId {
    final $$PacketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packetId,
      referencedTable: $db.packets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketsTableOrderingComposer(
            $db: $db,
            $table: $db.packets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PacketItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PacketItemsTable> {
  $$PacketItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get requirementName => $composableBuilder(
    column: $table.requirementName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$PacketsTableAnnotationComposer get packetId {
    final $$PacketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packetId,
      referencedTable: $db.packets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PacketsTableAnnotationComposer(
            $db: $db,
            $table: $db.packets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PacketItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PacketItemsTable,
          PacketItemRow,
          $$PacketItemsTableFilterComposer,
          $$PacketItemsTableOrderingComposer,
          $$PacketItemsTableAnnotationComposer,
          $$PacketItemsTableCreateCompanionBuilder,
          $$PacketItemsTableUpdateCompanionBuilder,
          (PacketItemRow, $$PacketItemsTableReferences),
          PacketItemRow,
          PrefetchHooks Function({bool packetId, bool documentId})
        > {
  $$PacketItemsTableTableManager(_$AppDatabase db, $PacketItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PacketItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PacketItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PacketItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packetId = const Value.absent(),
                Value<String> requirementName = const Value.absent(),
                Value<String?> documentId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PacketItemsCompanion(
                id: id,
                packetId: packetId,
                requirementName: requirementName,
                documentId: documentId,
                status: status,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packetId,
                required String requirementName,
                Value<String?> documentId = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => PacketItemsCompanion.insert(
                id: id,
                packetId: packetId,
                requirementName: requirementName,
                documentId: documentId,
                status: status,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PacketItemsTable, PacketItemRow>(table),
                  $$PacketItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({packetId = false, documentId = false}) {
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
                    if (packetId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.packetId,
                        referencedTable: $$PacketItemsTableReferences
                            ._packetIdTable(db),
                        referencedColumn: $$PacketItemsTableReferences
                            ._packetIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$PacketItemsTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$PacketItemsTableReferences
                            ._documentIdTable(db)
                            .id,
                      ) as T;
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

typedef $$PacketItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PacketItemsTable,
      PacketItemRow,
      $$PacketItemsTableFilterComposer,
      $$PacketItemsTableOrderingComposer,
      $$PacketItemsTableAnnotationComposer,
      $$PacketItemsTableCreateCompanionBuilder,
      $$PacketItemsTableUpdateCompanionBuilder,
      (PacketItemRow, $$PacketItemsTableReferences),
      PacketItemRow,
      PrefetchHooks Function({bool packetId, bool documentId})
    >;
typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  required String id,
  required String name,
  Value<String> region,
  required String itemsJson,
  Value<int> rowid,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> region,
  Value<String> itemsJson,
  Value<int> rowid,
});

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
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

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
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

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
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

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          TemplateRow,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (
            TemplateRow,
            BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow>,
          ),
          TemplateRow,
          PrefetchHooks Function()
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                name: name,
                region: region,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> region = const Value.absent(),
                required String itemsJson,
                Value<int> rowid = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                name: name,
                region: region,
                itemsJson: itemsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemplatesTable, TemplateRow>(table),
                  BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      TemplateRow,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (
        TemplateRow,
        BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow>,
      ),
      TemplateRow,
      PrefetchHooks Function()
    >;
typedef $$SignaturesTableCreateCompanionBuilder = SignaturesCompanion Function({
  required String id,
  required String encryptedPath,
  Value<int> rowid,
});
typedef $$SignaturesTableUpdateCompanionBuilder = SignaturesCompanion Function({
  Value<String> id,
  Value<String> encryptedPath,
  Value<int> rowid,
});

class $$SignaturesTableFilterComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableFilterComposer({
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

  ColumnFilters<String> get encryptedPath => $composableBuilder(
    column: $table.encryptedPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SignaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableOrderingComposer({
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

  ColumnOrderings<String> get encryptedPath => $composableBuilder(
    column: $table.encryptedPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SignaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SignaturesTable> {
  $$SignaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get encryptedPath => $composableBuilder(
    column: $table.encryptedPath,
    builder: (column) => column,
  );
}

class $$SignaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SignaturesTable,
          SignatureRow,
          $$SignaturesTableFilterComposer,
          $$SignaturesTableOrderingComposer,
          $$SignaturesTableAnnotationComposer,
          $$SignaturesTableCreateCompanionBuilder,
          $$SignaturesTableUpdateCompanionBuilder,
          (
            SignatureRow,
            BaseReferences<_$AppDatabase, $SignaturesTable, SignatureRow>,
          ),
          SignatureRow,
          PrefetchHooks Function()
        > {
  $$SignaturesTableTableManager(_$AppDatabase db, $SignaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SignaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SignaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SignaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> encryptedPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SignaturesCompanion(
                id: id,
                encryptedPath: encryptedPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String encryptedPath,
                Value<int> rowid = const Value.absent(),
              }) => SignaturesCompanion.insert(
                id: id,
                encryptedPath: encryptedPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SignaturesTable, SignatureRow>(table),
                  BaseReferences<_$AppDatabase, $SignaturesTable, SignatureRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SignaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SignaturesTable,
      SignatureRow,
      $$SignaturesTableFilterComposer,
      $$SignaturesTableOrderingComposer,
      $$SignaturesTableAnnotationComposer,
      $$SignaturesTableCreateCompanionBuilder,
      $$SignaturesTableUpdateCompanionBuilder,
      (
        SignatureRow,
        BaseReferences<_$AppDatabase, $SignaturesTable, SignatureRow>,
      ),
      SignatureRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$PagesTableTableManager get pages =>
      $$PagesTableTableManager(_db, _db.pages);
  $$PacketsTableTableManager get packets =>
      $$PacketsTableTableManager(_db, _db.packets);
  $$PacketItemsTableTableManager get packetItems =>
      $$PacketItemsTableTableManager(_db, _db.packetItems);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$SignaturesTableTableManager get signatures =>
      $$SignaturesTableTableManager(_db, _db.signatures);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
