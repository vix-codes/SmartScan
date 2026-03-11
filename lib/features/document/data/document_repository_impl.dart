import 'package:isar/isar.dart';
import 'package:smartscan/features/document/data/entities/document_entity.dart';
import 'package:smartscan/features/document/domain/document.dart';
import 'package:smartscan/features/document/domain/document_repository.dart';
import 'package:uuid/uuid.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> createDocument(String title) async {
    final entity = DocumentEntity()
      ..documentId = _uuid.v4()
      ..title = title
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..status = DocumentStatus.draft;

    await _isar.writeTxn(() => _isar.documentEntitys.put(entity));
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    final doc = await _isar.documentEntitys.filter().documentIdEqualTo(documentId).findFirst();
    if (doc == null) return;
    await _isar.writeTxn(() => _isar.documentEntitys.delete(doc.id));
  }

  @override
  Future<void> reorderPages(String documentId, List<String> orderedPageIds) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < orderedPageIds.length; i++) {
        final page = await _isar.pageEntitys.filter().pageIdEqualTo(orderedPageIds[i]).findFirst();
        if (page != null) {
          page.order = i;
          await _isar.pageEntitys.put(page);
        }
      }
    });
  }

  @override
  Stream<List<Document>> watchDocuments() {
    return _isar.documentEntitys.where().watch(fireImmediately: true).asyncMap((entities) async {
      final output = <Document>[];
      for (final doc in entities) {
        final pages = await _isar.pageEntitys.filter().documentIdEqualTo(doc.documentId).sortByOrder().findAll();
        output.add(Document(
          documentId: doc.documentId,
          title: doc.title,
          pages: pages
              .map((page) => DocumentPage(
                    pageId: page.pageId,
                    order: page.order,
                    processedImagePath: page.processedImagePath,
                  ))
              .toList(growable: false),
          tags: (await doc.tags.load()).map((t) => t.name).toList(growable: false),
          updatedAt: doc.updatedAt,
        ));
      }
      return output;
    });
  }
}
