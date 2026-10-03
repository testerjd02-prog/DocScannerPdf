import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a `List<String>` as a JSON array in a text column.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    final decoded = jsonDecode(fromDb);
    return decoded is List ? decoded.cast<String>() : const [];
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

@DataClassName('FolderRow')
class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DocumentRow')
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get folderId =>
      text().nullable().references(Folders, #id, onDelete: KeyAction.setNull)();
  TextColumn get ocrText => text().withDefault(const Constant(''))();
  TextColumn get tags => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  /// Soft-delete marker. A trashed document is hidden everywhere, can be
  /// restored (undo) and is purged, files included, after a grace period.
  DateTimeColumn get trashedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PageRow')
class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().references(Documents, #id, onDelete: KeyAction.cascade)();

  /// Zero-based position inside the document ("order" is an SQL keyword).
  IntColumn get position => integer()();

  /// Untouched capture. Never overwritten.
  TextColumn get originalPath => text()();

  /// Rendered result of crop + filter + rotation. Null until first render.
  TextColumn get editedPath => text().nullable()();
  TextColumn get filter => text().withDefault(const Constant('original'))();
  IntColumn get rotation => integer().withDefault(const Constant(0))();

  /// Normalised crop corners (tl, tr, br, bl) as JSON, null = full image.
  TextColumn get cropJson => text().nullable()();

  /// OCR line boxes of the edited image, used for the PDF text layer.
  TextColumn get ocrBlocksJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PacketRow')
class Packets extends Table {
  TextColumn get id => text()();
  TextColumn get templateId => text()();
  TextColumn get title => text()();
  TextColumn get purpose => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PacketItemRow')
class PacketItems extends Table {
  TextColumn get id => text()();
  TextColumn get packetId =>
      text().references(Packets, #id, onDelete: KeyAction.cascade)();
  TextColumn get requirementName => text()();
  TextColumn get documentId => text().nullable().references(
    Documents,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// missing | added | needsReview
  TextColumn get status => text().withDefault(const Constant('missing'))();
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TemplateRow')
class Templates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get region => text().withDefault(const Constant('global'))();
  TextColumn get itemsJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SignatureRow')
class Signatures extends Table {
  TextColumn get id => text()();
  TextColumn get encryptedPath => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SettingRow')
@TableIndex(name: 'settings_key', columns: {#key})
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  String get tableName => 'settings';

  @override
  Set<Column<Object>> get primaryKey => {key};
}
