import 'package:smartscan_models/document.dart';

abstract interface class DocumentRepository {
  Stream<List<Document>> watchDocuments();
  Future<void> createDocument(String title);
  Future<void> deleteDocument(String documentId);
  Future<void> reorderPages(String documentId, List<String> orderedPageIds);
}
