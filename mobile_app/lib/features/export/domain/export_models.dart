enum ExportFormat { pdf, docx, xlsx }

class ExportRequest {
  const ExportRequest({required this.documentId, required this.title, required this.pageImagePaths, required this.ocrTexts});

  final String documentId;
  final String title;
  final List<String> pageImagePaths;
  final List<String> ocrTexts;
}
