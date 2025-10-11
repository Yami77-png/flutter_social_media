import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/helpers/helpers.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/core/helpers/profile_picture_helper.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/info_icon_text.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/knot_request_section.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_and_cover_image.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_privacy_switch.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profle_info_tile.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/business_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/content_creator_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/individual_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/professional_profile_model.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/feed/application/fetch_user_post_cubit/fetch_user_post_cubit.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_actions.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_card.dart';
import 'package:flutter_social_media/src/features/friends/application/knot_cubit.dart';
import 'package:flutter_social_media/src/features/friends/presentation/friends_list_page.dart';

class IndividualProfilePage extends StatefulWidget {
  static const String route = 'individual_profile_page';
  const IndividualProfilePage({
    super.key,
    required this.user,
    this.individual,
    this.business,
    this.professinal,
    this.contentCreator,
  });

  final Userx user;
  final IndividualProfileModel? individual;
  final BusinessProfileModel? business;
  final ProfessionalProfileModel? professinal;
  final ContentCreatorProfileModel? contentCreator;

  @override
  State<IndividualProfilePage> createState() => _IndividualProfilePageState();
}

class _IndividualProfilePageState extends State<IndividualProfilePage> {
  final List<String> categories = ['Feed', 'Stills', 'Visual Content', 'Audio & Podcast'];
  int selectedCategory = 0;
  bool isCurentUser = false;
  bool isIndividual = true;
  String? profileImageUrl;
  bool isLoading = true;

  _checkCurentUser() async {
    String? currentUserId = await HiveHelper.getCurrentUserId();
    isCurentUser = widget.user.uuid == currentUserId;
    isIndividual = widget.user.userType == UserType.individual;

    if (isCurentUser) {
      profileImageUrl = widget.user.imageUrl;
      context.read<FetchUserPostsCubit>().fetchPosts(widget.user.uuid);
    } else {
      profileImageUrl = await ProfilePictureHelper().getProfilePictureUrl(widget.user.uuid);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    log('UserType: ${widget.user.userType}');
    _checkCurentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Profile'),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileAndCoverImage(
              profileImage: profileImageUrl ?? '',
              coverImage: widget.user.coverImageUrl ?? '',
              isCurrentUser: isCurentUser,
              isCenterImage: true,
              isFemale: widget.individual?.gender == 'Female',
              publicAvatar: widget.individual?.publicAvatar ?? "male_placeholder_1",
            ),
            //profile privacy
            if (isCurentUser && isIndividual)
              Transform.translate(
                offset: Offset(0, -175),
                child: Align(alignment: Alignment.centerRight, child: ProfilePrivacySwitch()),
              ),
            Transform.translate(
              offset: Offset(0, -110),
              child: Column(
                spacing: 12.h,
                children: [
                  Text(
                    widget.user.name,
                    style: AppTextStyles.primaryColorTitleStyle.copyWith(color: AppColors.black800),
                  ),
                  if (!isCurentUser) _compatibilitySection(),
                  // Visibility(
                  //   visible: isIndividual,
                  //   child: _individualUserOverview(),
                  //   replacement: _otherUsersOverview(isCurentUser),
                  // ),
                  _userProfileSection(),
                  if (!isCurentUser && isIndividual)
                    BlocProvider(
                      create: (context) => KnotCubit(),
                      child: KnotRequestSection(requestedUser: widget.user),
                    ),

                  if (isCurentUser)
                    AppButton(
                      onTap: () {
                        context.pushNamed(FriendsListPage.route);
                      },
                      label: 'Friend List',
                    ),
                  //usertypes profile section
                  // LifeMirrorTab(selectedCategoryName: selectedCategoryName, images: images),
                  SizedBox(height: 12.h),
                  if (isIndividual && isCurentUser) _buildFeedPosts(),
                  // if (isCurentUser) _buildSelectedCategoryWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedPosts() {
    return Column(
      children: [
        // if (isIndividual) Text('FEED', style: AppTextStyles.primaryColorTitleStyle),
        BlocBuilder<FetchUserPostsCubit, FetchUserPostsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              empty: () => const Text('No post yet!', style: TextStyle(color: Colors.grey)),
              error: (message) => Center(child: Text(message)),
              loaded: (posts) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(PostDetailsPage.route, pathParameters: {'id': post.id}, extra: post);
                            },
                            child: PostCard(post: post),
                          ),
                          //TODO modify post actions
                          PostActions(postId: post.id),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // bool _hasPersonalInformation() {
  //   // if (isCurentUser) {
  //   //   return true;
  //   // }

  //   return (widget.individual?.nickname?.isNotEmpty ?? false) ||
  //       (widget.individual?.collegeName?.isNotEmpty ?? false) ||
  //       (widget.individual?.currentAddress?.isNotEmpty ?? false) ||
  //       (widget.individual?.subject?.isNotEmpty ?? false);
  // }

  // Widget _userExtraInfo() {
  //   switch (widget.user.userType) {
  //     case UserType.individual:
  //       return !_hasPersonalInformation()
  //           ? SizedBox()
  //           : Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             spacing: 12,
  //             children: [
  //               Text("Personal Information", style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 18.sp)),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: Wrap(
  //                   alignment: WrapAlignment.spaceEvenly,
  //                   spacing: 45,
  //                   runSpacing: 12,
  //                   children: [
  //                     if (widget.individual?.nickname?.isNotEmpty ?? false)
  //                       _iconText(label: Assets.nicknameSvg, text: widget.individual?.nickname ?? 'N/A'),
  //                     if (widget.individual?.collegeName?.isNotEmpty ?? false)
  //                       _iconText(label: Assets.educationSvg, text: widget.individual?.collegeName ?? 'N/A'),
  //                     if (widget.individual?.currentAddress?.isNotEmpty ?? false)
  //                       _iconText(label: Assets.locationSvg, text: widget.individual?.currentAddress ?? 'N/A'),
  //                     if (widget.individual?.subject?.isNotEmpty ?? false)
  //                       _iconText(label: Assets.subjectSvg, text: widget.individual?.subject ?? 'N/A'),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //     case UserType.business:
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         spacing: 4,
  //         children: [
  //           Text("Business Profile", style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 18.sp)),
  //           const SizedBox(height: 4),
  //           _labelText(label: 'Owner', text: widget.business?.ownerName ?? ''),
  //           _labelText(label: 'Registratoin No', text: widget.business?.regiNumber ?? ''),
  //           _labelText(label: 'Current Address', text: widget.business?.currentAddress ?? ''),
  //         ],
  //       );
  //     case UserType.professional:
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         spacing: 4,
  //         children: [
  //           Text("Professional Profile", style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 18.sp)),
  //           const SizedBox(height: 4),
  //           _labelText(label: 'Company', text: widget.professinal?.company ?? ''),
  //           _labelText(label: 'Designation', text: widget.professinal?.designation ?? ''),
  //           _labelText(label: 'Industry', text: widget.professinal?.industry ?? ''),
  //           _labelText(label: 'Professional', text: widget.professinal?.professional ?? ''),
  //           _labelText(label: 'Availability', text: widget.professinal?.availability ?? ''),
  //         ],
  //       );
  //     case UserType.contentCreator:
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         spacing: 4,
  //         children: [
  //           Text("Content Creator", style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 18.sp)),
  //           const SizedBox(height: 4),
  //           _labelText(label: 'Category', text: widget.contentCreator?.category ?? ''),
  //           _labelText(label: 'Founding Date', text: widget.contentCreator?.foundingDate ?? ''),
  //           _labelText(label: 'Owner', text: widget.contentCreator?.ownerName ?? ''),
  //           _labelText(label: 'Address', text: widget.contentCreator?.currentAddress ?? ''),
  //           _labelText(label: 'Gender', text: widget.contentCreator?.gender ?? ''),
  //           _labelText(label: 'Team Size', text: widget.contentCreator?.teamCount.toString() ?? ''),
  //         ],
  //       );
  //   }
  // }

  Widget _userProfileSection() {
    bool isIndividualAllFieldsNotEmpty =
        ((widget.individual?.dob.isNotEmpty ?? false) ||
        (widget.individual?.dob.isNotEmpty ?? false) ||
        (widget.individual?.gender.isNotEmpty ?? false));
    switch (widget.user.userType) {
      case UserType.individual:
        return isIndividualAllFieldsNotEmpty ? _individualProfileSection(context) : SizedBox();
      case UserType.business:
        return SizedBox.shrink();
      case UserType.professional:
        return SizedBox.shrink();
      case UserType.contentCreator:
        return SizedBox.shrink();
    }
  }

  Row _compatibilitySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Compatibility", style: AppTextStyles.switchTitle.copyWith(fontSize: 14.sp)),
        Text(
          " •••• ",
          style: TextStyle(fontSize: 18.sp, color: Colors.indigo),
        ),
        Text("35%", style: AppTextStyles.switchTitle.copyWith(fontSize: 14.sp)),
      ],
    );
  }

  Padding _individualProfileSection(BuildContext context) {
    var infoSections = [
      ProfleInfoTile(
        label: 'Basic Details',
        infos: [
          if (widget.individual?.dob.isNotEmpty ?? false)
            InfoIconText(
              iconPath: Icons.replay_outlined,
              label: Helpers().calculateAge(widget.individual?.dob ?? '').toString() + ' Years',
            ),
          if (widget.individual?.dob.isNotEmpty ?? false)
            InfoIconText(
              iconPath: Icons.calendar_month_rounded,
              label: Helpers().formatDate(widget.individual?.dob ?? ''),
            ),
          if (widget.individual?.gender.isNotEmpty ?? false)
            InfoIconText(iconPath: Icons.transgender_rounded, label: '${widget.individual?.gender ?? ''}'),
        ],
      ),
      ProfleInfoTile(
        label: 'Location',
        infos: [
          if (widget.individual?.currentAddress?.isNotEmpty ?? false)
            InfoIconText(iconPath: Icons.location_on_outlined, label: '${widget.individual?.currentAddress ?? ''}'),
          if (widget.individual?.hometown?.isNotEmpty ?? false)
            InfoIconText(iconPath: Icons.holiday_village_outlined, label: '${widget.individual?.hometown ?? ''}'),
        ],
      ),
      ProfleInfoTile(
        label: 'Studies',
        infos: [
          if (widget.individual?.subject?.isNotEmpty ?? false)
            InfoIconText(iconPath: Icons.subject_rounded, label: '${widget.individual?.subject ?? ''}'),
          if (widget.individual?.collegeName?.isNotEmpty ?? false)
            InfoIconText(iconPath: Icons.school_outlined, label: '${widget.individual?.collegeName ?? ''}'),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("", style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 18.sp)),
              if (isCurentUser)
                TextButton(
                  onPressed: () {
                    context.pushNamed(
                      ProfileUpdatePage.route,
                      extra: (
                        user: widget.user,
                        individual: widget.individual,
                        business: widget.business,
                        professional: widget.professinal,
                        contentCreator: widget.contentCreator,
                      ),
                    );
                  },
                  child: Row(
                    spacing: 8,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      Icon(Icons.edit),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: infoSections.length,
              itemBuilder: (context, i) {
                return Align(alignment: Alignment.topCenter, child: infoSections[i]);
              },
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
            ),
          ),
        ],
      ),
    );
  }
}
