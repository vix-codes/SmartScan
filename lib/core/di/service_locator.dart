import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:smartscan/core/storage/file_storage_service.dart';
import 'package:smartscan/core/storage/isar_provider.dart';
import 'package:smartscan/features/document/data/document_repository_impl.dart';
import 'package:smartscan/features/document/domain/document_repository.dart';
import 'package:smartscan/features/ocr/data/ocr_service.dart';
import 'package:smartscan/features/ocr/domain/ocr_pipeline.dart';
import 'package:smartscan/features/scan/data/scanning_service.dart';
import 'package:smartscan/features/scan/domain/scan_pipeline.dart';

late final Isar isarInstance;

Future<void> configureDependencies() async {
  isarInstance = await IsarProvider.open();
}

final isarProvider = Provider<Isar>((_) => isarInstance);

final fileStorageProvider = Provider<FileStorageService>((_) => FileStorageService());

final scanPipelineProvider = Provider<ScanPipeline>((ref) {
  return ScanningService(ref.watch(fileStorageProvider));
});

final ocrPipelineProvider = Provider<OcrPipeline>((_) => OcrService());

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl(ref.watch(isarProvider));
});
