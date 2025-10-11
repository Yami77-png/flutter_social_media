import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_back_button.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({super.key, required this.title, this.actions, this.onBackFallback});

  final String title;
  final List<Widget>? actions;
  final String? onBackFallback;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: AppBackButton(isSwapColor: true),
      automaticallyImplyLeading: false,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 18,
        children: [
          AppBackButton(onBackFallback: onBackFallback ?? NavWrapperPage.route),
          Text(title, style: AppTextStyles.appBarTitle),
          // SizedBox.shrink(),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
