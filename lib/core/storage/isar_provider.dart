import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartscan/features/document/data/entities/document_entity.dart';

class IsarProvider {
  static Future<Isar> open() async {
    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(
      [DocumentEntitySchema, PageEntitySchema, OcrBlockEntitySchema, TagEntitySchema],
      directory: directory.path,
      name: 'smartscan',
      inspector: false,
    );
  }
}
