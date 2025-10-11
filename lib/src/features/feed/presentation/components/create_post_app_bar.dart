import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class CreatePostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canPost;
  final VoidCallback onPublish;
  const CreatePostAppBar({required this.canPost, required this.onPublish});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: context.pop,
            child: Text(
              "Discard",
              style: TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(
            "CREATE",
            style: TextStyle(fontSize: 16, letterSpacing: 1.5, fontWeight: FontWeight.normal, color: Colors.black),
          ),
          GestureDetector(
            onTap: canPost ? onPublish : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: canPost ? AppColors.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "Publish",
                  style: TextStyle(
                    color: canPost ? Colors.white : Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
