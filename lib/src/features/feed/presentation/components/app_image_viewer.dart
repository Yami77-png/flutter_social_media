import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageViewer extends StatelessWidget {
  const AppImageViewer(
    this.imageUrl, {
    super.key,
    this.height = 100,
    this.width = 100,
    this.placeholderWidget,
    this.errorWidget,
    this.fit,
    this.isCircle = false,
    this.darken = 0,
    this.placeholderColor,
  });

  final double? height, width;
  final String imageUrl;
  final Widget? placeholderWidget, errorWidget;
  final BoxFit? fit;
  final bool isCircle;
  final double darken;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isCircle ? height ?? 100 : 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        placeholder: (_, _) => _buildImg(child: Center(child: placeholderWidget ?? CircularProgressIndicator())),
        errorWidget: (_, _, _) => _buildImg(child: errorWidget ?? Icon(Icons.error_outline_rounded)),
        fadeInDuration: Durations.medium2,
        colorBlendMode: BlendMode.darken,
        color: Colors.black.withValues(alpha: darken),
      ),
    );
  }

  SizedBox _buildImg({required Widget child}) {
    return SizedBox(
      height: height,
      width: width,
      child: ColoredBox(color: placeholderColor ?? Colors.grey.shade300, child: child),
    );
  }
}
