import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartscan/core/di/service_locator.dart';
import 'package:smartscan/features/scan/domain/scan_pipeline.dart';

final scanControllerProvider = Provider<ScanController>((ref) {
  return ScanController(ref.watch(scanPipelineProvider));
});

class ScanController {
  ScanController(this._pipeline);
  final ScanPipeline _pipeline;

  Future<ScanPipelineOutput> processCapture({
    required String documentId,
    required Uint8List jpegBytes,
  }) {
    return _pipeline.process(ScanPipelineInput(jpegBytes: jpegBytes, documentId: documentId));
  }
}
