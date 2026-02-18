abstract class FileService {
  Future<void> saveAndOpen(List<int> bytes, String fileName);
}