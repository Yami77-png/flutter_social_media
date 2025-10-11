import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/core/utility/app_text_style.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/post_card.dart';
import 'package:flutter_social_media/src/features/notification/application/cubit/notification_cubit.dart';
import 'package:flutter_social_media/src/features/postBind/application/post_bind_cubit/post_bind_cubit.dart';
import 'package:flutter_social_media/src/features/postBind/infrastructure/post_bind_repository.dart';
import '../../feed/domain/models/post.dart';
import '../domain/post_bind_request_args.dart';

class PostBindRequestPage extends StatefulWidget {
  static String route = "bind_post_request_page";
  const PostBindRequestPage({super.key, required this.args});

  final PostBindRequestPageArgs args;

  @override
  State<PostBindRequestPage> createState() => _PostBindRequestPageState();
}

class _PostBindRequestPageState extends State<PostBindRequestPage> {
  Post? post;
  _getPost() async {
    post = await PostBindRepository().fetchRequestedBindPost(
      postId: widget.args.postId,
      bindedPostId: widget.args.bindedPostId,
    );
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    _getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isBindLimitExceed = (post?.bindedPost?.bindedPostCount ?? 0) >= postBindLimit;

    return Scaffold(
      appBar: AppAppBar(title: 'Bind Post Request'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : post == null
              ? Text('Post not found')
              : PostCard(post: post!),
        ),
      ),
      floatingActionButton: post == null
          ? null
          : isBindLimitExceed
          ? _bindLimitExceedWarning()
          : _buildActionButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String statusText = '';
  Color statusColor = Colors.black87;
  updateStatueText(String val, Color color) {
    setState(() {
      statusText = val;
      statusColor = color;
    });
  }

  bool isAcceptRejectLoading = false;
  updateIsAcceptRejectLoadig(bool val) {
    setState(() {
      isAcceptRejectLoading = val;
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocConsumer<PostBindCubit, PostBindState>(
      listener: (context, state) {
        state.mapOrNull(
          loading: (_) {
            updateIsAcceptRejectLoadig(true);
          },
          accepetedRequest: (_) {
            updateStatueText('Accepted post bind request!', Colors.green);
            updateIsAcceptRejectLoadig(false);
          },
          rejectedRequest: (_) {
            updateStatueText('Rejected post bind request!', Colors.redAccent);
            updateIsAcceptRejectLoadig(false);
          },
        );
      },
      builder: (context, state) {
        return isAcceptRejectLoading
            ? Center(child: CircularProgressIndicator())
            : statusText.isNotEmpty
            ? _statusText()
            : _actionButtons(context);
      },
    );
  }

  DecoratedBox _statusText() {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: statusColor.withValues(alpha: 0.12)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(statusText, style: AppTextStyles.buttonText.copyWith(color: statusColor)),
      ),
    );
  }

  DecoratedBox _bindLimitExceedWarning() {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.amber.withValues(alpha: 0.12)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          'Post bind limit exceed! Cannot bind anymore.',
          maxLines: 3,
          style: AppTextStyles.buttonText.copyWith(color: Colors.amber),
        ),
      ),
    );
  }

  Row _actionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10.w,
      children: [
        AppButton(
          label: 'Reject',
          isOutlined: true,
          onTap: () {
            context.read<PostBindCubit>().rejectPostBindRequest(
              postId: widget.args.postId,
              bindedPostId: widget.args.bindedPostId,
            );
            context.read<NotificationCubit>().updateNotificationBody(
              widget.args.notificationId,
              'Rejected post bind request!',
            );
          },
        ),
        AppButton(
          label: 'Accept',
          onTap: () {
            if (post != null) {
              context.read<PostBindCubit>().acceptPostBindRequest(post: post!, bindedPostId: widget.args.bindedPostId);
            }
            context.read<NotificationCubit>().updateNotificationBody(
              widget.args.notificationId,
              'Accepted post bind request!',
            );
          },
        ),
      ],
    );
  }
}
