import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_pic_blob.dart';
import 'package:flutter_social_media/src/features/feed/application/profile_pic_cubit/profile_pic_cubit.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/privacy_dropdown.dart';

class UserHeader extends StatelessWidget {
  final PostPrivacy selectedPrivacy;
  final ValueChanged<PostPrivacy?> onPrivacyChanged;
  final bool canSetPrivacy;
  const UserHeader({required this.selectedPrivacy, required this.onPrivacyChanged, required this.canSetPrivacy});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePicCubit, ProfilePicState>(
      builder: (context, state) {
        return state.map(
          loading: (_) => SizedBox.shrink(),
          loaded: (value) => Row(
            spacing: 12.w,
            children: [
              ProfilePicBlob(profilePicUrl: value.user.imageUrl, size: 64),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.w,
                children: [
                  Text(
                    value.user.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                  ),
                  Visibility(
                    visible: canSetPrivacy,
                    replacement: _bindedPrivacy(selectedPrivacy),
                    child: PrivacyDropdown(value: selectedPrivacy, onChanged: onPrivacyChanged),
                  ),
                ],
              ),
            ],
          ),
          error: (value) => const Row(children: [Text('Could not load user')]),
        );
      },
    );
  }

  Row _bindedPrivacy(PostPrivacy privacy) {
    _getPrivacyIcon(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return Icons.public_rounded;
        case PostPrivacy.FRIENDS:
          return Icons.people_outline_outlined;
        case PostPrivacy.ONLYME:
          return Icons.lock_outline_rounded;
      }
    }

    _getPrivacyName(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return "Public";
        case PostPrivacy.FRIENDS:
          return "Friends";
        case PostPrivacy.ONLYME:
          return "Only Me";
      }
    }

    return Row(
      spacing: 8.w,
      children: [
        Icon(_getPrivacyIcon(selectedPrivacy)),
        Text(
          _getPrivacyName(selectedPrivacy),
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w200, color: Colors.black87),
        ),
      ],
    );
  }
}
