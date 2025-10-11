import 'package:image_cropper/image_cropper.dart';

class CropAspectRatioPreset9x16 implements CropAspectRatioPresetData {
  @override
  String get name => '9x16';
  @override
  (int ratioX, int ratioY)? get data => (9, 16);
}
