import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/feed/presentation/components/crop_aspect_ratio_present_9_16.dart';
import '../utility/app_colors.dart';

class ImageUploadHelper {
  Future<List<XFile>> cropImages(List<XFile> files) async {
    List<XFile> croppedFiles = [];

    for (XFile file in files) {
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 80,
        maxHeight: 2000,
        maxWidth: 2000,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            activeControlsWidgetColor: AppColors.primaryColor,
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: AppColors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            aspectRatioPresets: [CropAspectRatioPreset.ratio16x9, CropAspectRatioPreset9x16()],
            showCropGrid: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            resetAspectRatioEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.ratio16x9, CropAspectRatioPreset9x16()],
          ),
        ],
      );

      if (cropped != null) {
        croppedFiles.add(XFile(cropped.path));
      }
    }

    return croppedFiles;
  }
}
