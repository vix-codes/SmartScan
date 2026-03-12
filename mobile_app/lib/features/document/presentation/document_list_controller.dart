import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartscan/core/di/service_locator.dart';
import 'package:smartscan_models/document.dart';
import 'package:smartscan/features/document/domain/document_repository.dart';

final documentListProvider = StreamProvider<List<Document>>((ref) {
  final repo = ref.watch(documentRepositoryProvider);
  return repo.watchDocuments();
});

final createDocumentProvider = Provider<Future<void> Function(String)>((ref) {
  final repo = ref.watch(documentRepositoryProvider);
  return repo.createDocument;
});
