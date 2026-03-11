import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  Future<Directory> _root() async {
    final dir = await getApplicationSupportDirectory();
    final root = Directory(p.join(dir.path, 'smartscan_data'));
    if (!await root.exists()) {
      await root.create(recursive: true);
    }
    return root;
  }

  Future<File> pageFile(String documentId, String pageId, {required bool processed}) async {
    final root = await _root();
    final folder = Directory(p.join(root.path, documentId));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return File(p.join(folder.path, '${processed ? 'proc' : 'raw'}_$pageId.jpg'));
  }
}
