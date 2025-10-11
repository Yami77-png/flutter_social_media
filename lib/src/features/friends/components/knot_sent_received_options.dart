import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

import '../../../core/utility/app_text_style.dart';

class KnotSentReceivedOptions extends StatelessWidget {
  const KnotSentReceivedOptions({
    super.key,
    required this.isIncomingKnotRequest,
    required this.onAccept,
    required this.onReject,
    this.isOnlyButton = false,
  });

  final bool isIncomingKnotRequest;
  final VoidCallback onAccept, onReject;
  final bool isOnlyButton;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor.withValues(alpha: isOnlyButton ? 0 : 0.15),
      ),
      child: Padding(
        padding: isOnlyButton ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          spacing: 8,
          children: [
            if (!isOnlyButton)
              Text(
                isIncomingKnotRequest ? 'Incoming knot request' : 'Knot request sent already',
                style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            Row(
              spacing: 12,
              mainAxisAlignment: isOnlyButton ? MainAxisAlignment.end : MainAxisAlignment.center,
              children: [
                _knotBtn(onTap: onReject, label: isIncomingKnotRequest ? 'Reject' : 'Cancel', isOutlined: true),
                if (isIncomingKnotRequest) _knotBtn(onTap: onAccept, label: 'Accept'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _knotBtn({required VoidCallback onTap, String label = 'Send Custom Knot Request', bool isOutlined = false}) {
    return AppButton(onTap: onTap, label: label, isOutlined: isOutlined);
  }
}
