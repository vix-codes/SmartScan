class Document {
  const Document({
    required this.documentId,
    required this.title,
    required this.pages,
    required this.tags,
    required this.updatedAt,
  });

  final String documentId;
  final String title;
  final List<DocumentPage> pages;
  final List<String> tags;
  final DateTime updatedAt;
}

class DocumentPage {
  const DocumentPage({
    required this.pageId,
    required this.order,
    required this.processedImagePath,
    this.ocrText,
  });

  final String pageId;
  final int order;
  final String processedImagePath;
  final String? ocrText;
}
