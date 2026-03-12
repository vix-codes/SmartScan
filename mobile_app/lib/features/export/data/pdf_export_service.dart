import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smartscan/features/export/domain/export_models.dart';
import 'package:smartscan/core/storage/file_storage_service.dart';

class PdfExportService {
  PdfExportService(this._storageService);

  final FileStorageService _storageService;

  Future<File> export(ExportRequest request) async {
    final pdf = pw.Document();

    for (var i = 0; i < request.pageImagePaths.length; i++) {
      final imageFile = File(request.pageImagePaths[i]);
      if (!await imageFile.exists()) continue;

      final Uint8List imageBytes = await _storageService.readEncrypted(imageFile);
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Stack(
              alignment: pw.Alignment.center,
              children: [
                pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
                if (i < request.ocrTexts.length)
                  pw.Positioned.fill(
                    child: pw.Opacity(
                      opacity: 0.0,
                      child: pw.Text(request.ocrTexts[i]),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }

    final root = await getTemporaryDirectory();
    final file = File(p.join(root.path, '${request.title}_${request.documentId}.pdf'));
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }
}
