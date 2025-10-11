import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class MediaPickerHelper {
  Future<File?> pickAudio() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result == null) {
        log('User canceled the audio picker.');
        return null;
      }

      final String? filePath = result.files.single.path;
      if (filePath != null) {
        log('Audio picked: $filePath');
        return File(filePath);
      } else {
        log('Error: Audio file path is null.');
        return null;
      }
    } catch (e) {
      log('Error picking audio file: $e');
      return null;
    }
  }
}
