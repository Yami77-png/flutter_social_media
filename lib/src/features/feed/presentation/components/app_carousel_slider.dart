import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/carousel_media_viewer_page.dart';

class AppCarouselSlider extends StatefulWidget {
  final List<String> items;
  final double imageHeight;

  const AppCarouselSlider({super.key, required this.items, this.imageHeight = 300});

  @override
  State<AppCarouselSlider> createState() => _AppCarouselSliderState();
}

class _AppCarouselSliderState extends State<AppCarouselSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(
        height: widget.imageHeight,
        child: Center(child: Text("No images available")),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.imageHeight,
            viewportFraction: widget.items.length > 1 ? 0.9 : 1,
            enableInfiniteScroll: false,
            // enlargeCenterPage: true,
            // enlargeFactor: 0.2,
            padEnds: false,
            disableCenter: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.items.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          CarouselMediaViewerPage.route,
                          queryParameters: {'index': _current.toString()},
                          extra: widget.items,
                        );
                      },

                      child: AppImageViewer(
                        url,
                        height: widget.imageHeight,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (widget.items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? AppColors.primaryColor : AppColors.primaryColor.withAlpha(100),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
