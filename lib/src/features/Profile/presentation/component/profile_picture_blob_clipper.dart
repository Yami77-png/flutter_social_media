import 'package:flutter/material.dart';

class ProfilePictureBlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // These are the dimensions
    final double originalWidth = 99.0;
    final double originalHeight = 104.0;

    // Calculate the scale factors to fit the SVG path into the widget's size
    final double scaleX = size.width / originalWidth;
    final double scaleY = size.height / originalHeight;

    final path = Path();

    // Move to the starting point
    path.moveTo(1.19513 * scaleX, 50.51 * scaleY);

    // The rest of the SVG path data, converted to Flutter Path commands
    path.lineTo(1.18927 * scaleX, 50.4543 * scaleY);
    path.cubicTo(
      -0.165532 * scaleX,
      38.4109 * scaleY,
      5.85375 * scaleX,
      25.4707 * scaleY,
      16.6072 * scaleX,
      15.8889 * scaleY,
    );
    path.cubicTo(
      27.3429 * scaleX,
      6.32295 * scaleY,
      42.7067 * scaleX,
      0.196438 * scaleY,
      59.8348 * scaleX,
      1.7365 * scaleY,
    );
    path.cubicTo(
      62.1416 * scaleX,
      1.94391 * scaleY,
      64.4775 * scaleX,
      1.98237 * scaleY,
      66.7322 * scaleX,
      2.05681 * scaleY,
    );
    path.cubicTo(
      76.7978 * scaleX,
      2.38917 * scaleY,
      84.5853 * scaleX,
      8.16626 * scaleY,
      89.8973 * scaleX,
      16.6438 * scaleY,
    );
    path.cubicTo(
      95.2185 * scaleX,
      25.1361 * scaleY,
      97.9997 * scaleX,
      36.2703 * scaleY,
      97.9998 * scaleX,
      47.0539 * scaleY,
    );
    path.cubicTo(
      97.9998 * scaleX,
      58.153 * scaleY,
      94.1942 * scaleX,
      72.9682 * scaleY,
      85.95 * scaleX,
      84.4914 * scaleY,
    );
    path.cubicTo(
      77.7359 * scaleX,
      95.9726 * scaleY,
      65.1635 * scaleX,
      104.141 * scaleY,
      47.5135 * scaleX,
      102.22 * scaleY,
    );
    path.cubicTo(
      46.7422 * scaleX,
      102.136 * scaleY,
      45.9659 * scaleX,
      102.069 * scaleY,
      45.2059 * scaleX,
      102.003 * scaleY,
    );
    path.cubicTo(
      44.4415 * scaleX,
      101.936 * scaleY,
      43.6912 * scaleX,
      101.87 * scaleY,
      42.95 * scaleX,
      101.784 * scaleY,
    );
    path.cubicTo(
      33.972 * scaleX,
      100.741 * scaleY,
      23.5243 * scaleX,
      93.4501 * scaleY,
      15.2703 * scaleX,
      83.5168 * scaleY,
    );
    path.cubicTo(
      7.03035 * scaleX,
      73.6004 * scaleY,
      1.19531 * scaleX,
      61.3105 * scaleY,
      1.19513 * scaleX,
      50.5666 * scaleY,
    );

    // Vertical line and close the path
    path.lineTo(1.19513 * scaleX, 50.51 * scaleY);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // The path is static, so no need to reclip.
  }
}
