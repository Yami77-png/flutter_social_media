import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/friends/components/already_knotted.dart';
import 'package:flutter_social_media/src/features/friends/application/knot_cubit.dart';
import 'package:flutter_social_media/src/features/friends/components/knot_sent_received_options.dart';

class KnotRequestSection extends StatefulWidget {
  KnotRequestSection({super.key, required this.requestedUser});

  final Userx requestedUser;

  @override
  State<KnotRequestSection> createState() => _KnotRequestSectionState();
}

class _KnotRequestSectionState extends State<KnotRequestSection> {
  @override
  void initState() {
    context.read<KnotCubit>().checkKnotRequest(widget.requestedUser.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KnotCubit, KnotState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: Durations.long1,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: state.when(
            initial: () => _sendCustomKnotBtn(),
            loading: () => _buildLoader(),
            success: () => _buildKnotAlreadySent(isIncomingKnotRequest: false),
            checkingKnot: () => SizedBox(),
            hasRequestedKnot: () => _buildKnotAlreadySent(isIncomingKnotRequest: false),
            hasIncomingKnot: () => _buildKnotAlreadySent(isIncomingKnotRequest: true),
            isKnotted: () => AlreadyKnotted(),
            cancaledRequest: () => _sendCustomKnotBtn(),
            rejectedRequest: () => _sendCustomKnotBtn(),
            accepetedRequest: () => AlreadyKnotted(),
            error: (_) => _sendCustomKnotBtn(),
          ),
        );
      },
    );
  }

  Widget _sendCustomKnotBtn() {
    return _knotBtn(
      onTap: () {
        context.read<KnotCubit>().sendKnotRequest(widget.requestedUser);
      },
    );
  }

  Widget _knotBtn({required VoidCallback onTap, String label = 'Send Custom Knot Request', bool isOutlined = false}) {
    return AppButton(onTap: onTap, label: label, isOutlined: isOutlined);
  }

  Widget _buildKnotAlreadySent({required bool isIncomingKnotRequest}) {
    return KnotSentReceivedOptions(
      isIncomingKnotRequest: isIncomingKnotRequest,
      onAccept: () {
        context.read<KnotCubit>().acceptKnotRequest(widget.requestedUser.uuid);
      },
      onReject: () {
        if (isIncomingKnotRequest)
          context.read<KnotCubit>().rejectKnotRequest(widget.requestedUser.uuid);
        else
          context.read<KnotCubit>().cancelKnotRequest(widget.requestedUser.uuid);
      },
    );
    // return DecoratedBox(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: AppColors.primaryColor.withValues(alpha: 0.15),
    //   ),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    //     child: Column(
    //       spacing: 8,
    //       children: [
    //         Text(
    //           isIncomingKnotRequest ? 'Incoming knot request' : 'Knot request sent already',
    //           style: AppTextStyles.primaryColorTitleStyle.copyWith(fontSize: 16.sp),
    //           textAlign: TextAlign.center,
    //         ),
    //         Row(
    //           spacing: 12,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             _knotBtn(
    // onTap: () {
    //   if (isIncomingKnotRequest)
    //     context.read<KnotCubit>().rejectKnotRequest(widget.requestedUser.uuid);
    //   else
    //     context.read<KnotCubit>().cancelKnotRequest(widget.requestedUser.uuid);
    // },
    //               label: isIncomingKnotRequest ? 'Reject' : 'Cancel',
    //               isOutlined: true,
    //             ),
    //             if (isIncomingKnotRequest)
    //               _knotBtn(
    //                 onTap: () {
    //                   context.read<KnotCubit>().acceptKnotRequest(widget.requestedUser.uuid);
    //                 },
    //                 label: 'Accept',
    //               ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  ElevatedButton _buildLoader() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}
