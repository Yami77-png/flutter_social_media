import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class PostAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PostAppbar({super.key, this.onTap, this.publishColor, required this.title});

  final VoidCallback? onTap;
  final String title;
  final Color? publishColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: context.pop,
            child: Text(
              "Discard",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Text(title, style: TextStyle(letterSpacing: 2)),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: publishColor ?? AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text("Publish", style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
