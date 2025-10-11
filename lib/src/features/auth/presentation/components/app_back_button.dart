import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.isSwapColor = false, required this.onBackFallback});

  final bool isSwapColor;
  final String onBackFallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Ensure navigation is deferred after the frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(onBackFallback);
            }
          } catch (e) {
            // fallback page, if no item in stack to pop
            context.goNamed(onBackFallback);
          }
        });
      },
      borderRadius: BorderRadius.circular(99),
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: !isSwapColor ? AppColors.primaryColor : Colors.white),
        child: Icon(Icons.navigate_before, color: !isSwapColor ? Colors.white : AppColors.primaryColor, size: 28),
      ),
    );
  }
}
