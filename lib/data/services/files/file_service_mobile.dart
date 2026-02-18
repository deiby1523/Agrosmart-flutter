import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'file_service_base.dart';

class FileServiceImp implements FileService {
  @override
  Future<void> saveAndOpen(List<int> bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
}