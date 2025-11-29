import 'package:file_picker/file_picker.dart';

class FolderPicker {
  static Future<String?> pickFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();

    return path; // Puede ser null si cancela
  }
}
