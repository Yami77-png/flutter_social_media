import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';

class CarouselMediaViewerPage extends StatelessWidget {
  static const route = '/media-viewer';

  final List<String> imageUrls;
  final int initialIndex;

  const CarouselMediaViewerPage({super.key, required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: AppImageViewer(
                    imageUrls[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholderColor: Colors.black,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
