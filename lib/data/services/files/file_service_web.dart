import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;
import 'file_service_base.dart';

class FileServiceImp implements FileService {
  @override
  Future<void> saveAndOpen(List<int> bytes, String fileName) async {
    // 1. Convertir bytes a un JSArray
    final uint8array = Uint8List.fromList(bytes).toJS;
    final array = [uint8array].toJS;
    
    // 2. Crear un Blob (objeto de datos en el navegador)
    final blob = web.Blob(array, web.BlobPropertyBag(type: 'application/pdf'));
    
    // 3. Crear una URL temporal para ese Blob
    final url = web.URL.createObjectURL(blob);
    
    // 4. Crear un elemento <a> y simular el click para descargar
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = fileName;
    anchor.click();
    
    // 5. Limpiar la memoria
    web.URL.revokeObjectURL(url);
  }
}