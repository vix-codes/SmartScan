import 'dart:typed_data';

class ScanPipelineInput {
  const ScanPipelineInput({required this.jpegBytes, required this.documentId});
  final Uint8List jpegBytes;
  final String documentId;
}

class ScanPipelineOutput {
  const ScanPipelineOutput({
    required this.rawImagePath,
    required this.processedImagePath,
    required this.width,
    required this.height,
  });

  final String rawImagePath;
  final String processedImagePath;
  final int width;
  final int height;
}

abstract interface class ScanPipeline {
  Future<ScanPipelineOutput> process(ScanPipelineInput input);
}
