import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smartscan/features/export/domain/export_models.dart';

class PdfExportService {
  /// Replace placeholder with `pdf` package integration to draw image and invisible text layer.
  Future<File> export(ExportRequest request) async {
    final root = await getApplicationDocumentsDirectory();
    final file = File(p.join(root.path, '${request.title}_${request.documentId}.pdf'));

    final payload = StringBuffer('SMARTSCAN_PDF_PLACEHOLDER\n');
    for (var i = 0; i < request.pageImagePaths.length; i++) {
      payload.writeln('PAGE:$i IMAGE:${request.pageImagePaths[i]}');
      if (i < request.ocrTexts.length) payload.writeln('OCR:${request.ocrTexts[i]}');
    }

    await file.writeAsString(payload.toString(), flush: true);
    return file;
  }
}
