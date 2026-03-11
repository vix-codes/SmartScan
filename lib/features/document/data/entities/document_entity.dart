import 'package:isar/isar.dart';

part 'document_entity.g.dart';

@collection
class DocumentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String documentId;

  late String title;
  late DateTime createdAt;
  late DateTime updatedAt;
  @enumerated
  late DocumentStatus status;

  final pages = IsarLinks<PageEntity>();
  final tags = IsarLinks<TagEntity>();
}

enum DocumentStatus { draft, ready, archived }

@collection
class PageEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String pageId;
  late String documentId;
  late int order;
  late String rawImagePath;
  late String processedImagePath;
  late int width;
  late int height;
  late bool hasSignature;
  late DateTime updatedAt;

  final ocrBlocks = IsarLinks<OcrBlockEntity>();
}

@collection
class OcrBlockEntity {
  Id id = Isar.autoIncrement;

  late String pageId;
  late String text;
  late double left;
  late double top;
  late double right;
  late double bottom;
  late String languageCode;
}

@collection
class TagEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;
}
