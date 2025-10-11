// // --------------------- IMAGE DISPLAY ---------------------
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import '../models/media_model.dart';
//
// class ImageDisplayWidget extends StatefulWidget {
//   final MediaModel media;
//
//   const ImageDisplayWidget({super.key, required this.media});
//
//   @override
//   State<ImageDisplayWidget> createState() => _ImageDisplayWidgetState();
// }
//
// class _ImageDisplayWidgetState extends State<ImageDisplayWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _likeAnimationController;
//   bool _showLikeOverlay = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _likeAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _likeAnimationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() => _showLikeOverlay = false);
//         _likeAnimationController.reset();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _likeAnimationController.dispose();
//     super.dispose();
//   }
//
//   void _handleDoubleTap() {
//     setState(() => _showLikeOverlay = true);
//     _likeAnimationController.forward();
//     // You could also call a callback to increment likes or animate icon here
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final imageHeight = screenWidth / widget.media.aspectRatioValue;
//
//     return SizedBox(
//       width: screenWidth,
//       height: screenWidth,//imageHeight,
//       child: GestureDetector(
//         onDoubleTap: _handleDoubleTap,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             widget.media.url.startsWith('http')
//                 ? Image.network(
//                     widget.media.url,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         color: Colors.black12,
//                         child: const Center(child: CircularProgressIndicator()),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.black12,
//                         child: const Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.error_outline,
//                                   color: Colors.white, size: 32),
//                               SizedBox(height: 8),
//                               Text('Image not available',
//                                   style: TextStyle(color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : Image.file(
//                     File(widget.media.url),
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.black12,
//                         child: const Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.error_outline,
//                                   color: Colors.white, size: 32),
//                               SizedBox(height: 8),
//                               Text('Image not available',
//                                   style: TextStyle(color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//             if (_showLikeOverlay)
//               ScaleTransition(
//                 scale: CurvedAnimation(
//                   parent: _likeAnimationController,
//                   curve: Curves.elasticOut,
//                 ),
//                 child: const Icon(
//                   Icons.favorite,
//                   color: Colors.white,
//                   size: 80,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// --------------------- IMAGE DISPLAY ---------------------
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/media_model.dart';

class ImageDisplayWidget extends StatefulWidget {
  final MediaModel media;

  const ImageDisplayWidget({super.key, required this.media});

  @override
  State<ImageDisplayWidget> createState() => _ImageDisplayWidgetState();
}

class _ImageDisplayWidgetState extends State<ImageDisplayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  bool _showLikeOverlay = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _likeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showLikeOverlay = false);
        _likeAnimationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    setState(() => _showLikeOverlay = true);
    _likeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        // width: screenWidth,
        // height: screenWidth, // Square image (width = height)
        child: GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Column(
            // alignment: Alignment.center,
            children: [
              widget.media.url.startsWith('http')
                  ? Image.network(
                    widget.media.url,
                    width: screenWidth, // double.infinity,
                    height: screenWidth, //double.infinity,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(color: Colors.black12, child: const Center(child: CircularProgressIndicator()));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.white, size: 32),
                              SizedBox(height: 8),
                              Text('Image not available', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                  : Image.file(
                    File(widget.media.url),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black12,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.white, size: 32),
                              SizedBox(height: 8),
                              Text('Image not available', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              if (_showLikeOverlay)
                ScaleTransition(
                  scale: CurvedAnimation(parent: _likeAnimationController, curve: Curves.elasticOut),
                  child: Icon(Icons.favorite, color: Colors.white, size: 80),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
