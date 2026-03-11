import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:smartscan/core/storage/file_storage_service.dart';
import 'package:smartscan/features/scan/domain/scan_pipeline.dart';
import 'package:uuid/uuid.dart';

/// OpenCV bridge can replace the placeholder enhancement methods.
class ScanningService implements ScanPipeline {
  ScanningService(this._storageService);

  final FileStorageService _storageService;
  final _uuid = const Uuid();

  @override
  Future<ScanPipelineOutput> process(ScanPipelineInput input) async {
    final pageId = _uuid.v4();
    final rawFile = await _storageService.pageFile(input.documentId, pageId, processed: false);
    final processedFile = await _storageService.pageFile(input.documentId, pageId, processed: true);

    await rawFile.writeAsBytes(input.jpegBytes, flush: true);

    final image = img.decodeJpg(input.jpegBytes);
    if (image == null) {
      throw StateError('Invalid JPEG input');
    }

    // Placeholder for OpenCV perspective correction + adaptive threshold.
    final enhanced = img.adjustColor(image, contrast: 1.15, saturation: 0.0);
    final encoded = img.encodeJpg(enhanced, quality: 92);
    await processedFile.writeAsBytes(Uint8List.fromList(encoded), flush: true);

    return ScanPipelineOutput(
      rawImagePath: rawFile.path,
      processedImagePath: processedFile.path,
      width: enhanced.width,
      height: enhanced.height,
    );
  }
}
