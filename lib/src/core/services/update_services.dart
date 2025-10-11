// // lib/src/core/services/update_service.dart

// import 'package:flutter/material.dart';
// import 'package:new_version_plus/new_version_plus.dart';

// class UpdateService {
//   static Future<void> checkForUpdate(BuildContext context) async {
//     final newVersion = NewVersionPlus(
//       androidId: 'com.yourcompany.appname', // Replace with actual ID
//       iOSId: 'your.ios.app.id',
//     );

//     final status = await newVersion.getVersionStatus();
//     if (status != null && status.canUpdate) {
//       newVersion.showUpdateDialog(
//         context: context,
//         versionStatus: status,
//         dialogTitle: 'Update Available',
//         dialogText: 'A new version of Flutter Social Media is available! Please update.',
//         updateButtonText: 'Update Now',
//         dismissButtonText: 'Later',
//       );
//     }
//   }
// }
