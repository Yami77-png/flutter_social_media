import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/features/Profile/application/logout_cubit.dart';
import 'package:flutter_social_media/src/features/Profile/application/profile_cubit/profile_cubit.dart';
import 'package:flutter_social_media/src/features/settings/presentation/settings_page.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is LogoutSuccess) {
          context.pop();
          context.read<NavigationCubit>().reset();
          context.goNamed(GetStarted.route);
        }
        if (state is LogoutFailure) {
          context.pop();
          AppSnackbar.show(context, message: 'Logout Failed: ${state.error}');
        }
      },
      child: Column(
        children: [
          _menuTile(context, label: appLocalizations.profile, menuIcon: Icons.person_outline_rounded),
          _menuTile(context, label: appLocalizations.settings, menuIcon: Icons.settings_outlined),
          _menuTile(context, label: appLocalizations.privacy, menuIcon: Icons.shield_outlined),
          _menuTile(context, label: appLocalizations.support, menuIcon: Icons.support_agent_rounded),
          _menuTile(context, label: appLocalizations.logout, menuIcon: Icons.logout_rounded),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, {required IconData menuIcon, required String label}) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryColor,
        child: Icon(menuIcon, color: AppColors.white, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16.sp),
      ),
      onTap: () {
        final appLocalizations = AppLocalizations.of(context)!;

        if (label == appLocalizations.profile) {
          final state = context.read<ProfileCubit>().state;
          state.mapOrNull(
            loading: (_) {
              return Center(child: CircularProgressIndicator.adaptive());
            },
            loaded: (value) {
              switch (value.user.userType) {
                case UserType.individual:
                  context.pushNamed(
                    IndividualProfilePage.route,
                    extra: (
                      user: value.user,
                      individual: value.individualProfile,
                      business: value.businessProfile,
                      professional: value.professionalProfile,
                      contentCreator: value.contentCreatorProfile,
                    ),
                  );
                case UserType.business:
                case UserType.contentCreator:
                case UserType.professional:
              }
            },
            error: (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.e}')));
            },
          );
          return;
        }

        if (label == appLocalizations.settings) {
          context.pushNamed(SettingsPage.route);
        }

        if (label == appLocalizations.privacy) {
          // Get.to(() => const PrivacySettingsPage());
        }

        if (label == appLocalizations.support) {
          // Get.to(() => const SupportPage());
        }

        if (label == appLocalizations.logout) {
          context.read<LogoutCubit>().signOut();
        }
      },
    );
  }
}
