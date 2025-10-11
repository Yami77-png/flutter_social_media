// import 'package:flutter/material.dart';
//
// class TriangleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.moveTo(size.width / 2, 0); // Top Center
//     path.lineTo(0, size.height);    // Bottom Left
//     path.lineTo(size.width, size.height); // Bottom Right
//     path.close(); // Connects back to the start
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// import 'package:flutter/material.dart';
//
// class CircleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     return Path()
//       ..addOval(Rect.fromLTWH(0.0, .5, size.width, size.height));
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  final double radius;

  CircleClipper({this.radius = 8});

  @override
  Path getClip(Size size) {
    final path = Path();

    final double w = size.width;
    final double h = size.height;

    // Define the three points of the triangle
    final p1 = Offset(w / 2, 0);
    final p2 = Offset(0, h);
    final p3 = Offset(w, h);

    path.moveTo(p1.dx, p1.dy + radius);

    // Top vertex (rounded)
    path.quadraticBezierTo(p1.dx, p1.dy, p1.dx - radius * 0.7, p1.dy + radius * 0.7);

    // Left corner
    path.lineTo(p2.dx + radius, p2.dy - radius);
    path.quadraticBezierTo(p2.dx, p2.dy, p2.dx + radius, p2.dy);

    // Right corner
    path.lineTo(p3.dx - radius, p3.dy);
    path.quadraticBezierTo(p3.dx, p3.dy, p3.dx - radius, p3.dy - radius);

    // Connect back to top with a curve
    path.lineTo(p1.dx + radius * 0.7, p1.dy + radius * 0.7);
    path.quadraticBezierTo(p1.dx, p1.dy, p1.dx, p1.dy + radius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
