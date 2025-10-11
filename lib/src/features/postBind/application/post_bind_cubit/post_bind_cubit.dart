import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:flutter_social_media/src/features/postBind/infrastructure/post_bind_repository.dart';

part 'post_bind_state.dart';
part 'post_bind_cubit.freezed.dart';

class PostBindCubit extends Cubit<PostBindState> {
  PostBindCubit() : super(PostBindState.initial());

  rejectPostBindRequest({required String postId, required String bindedPostId}) async {
    emit(PostBindState.loading());
    final isSuccess = await PostBindRepository().rejectPostBindRequest(postId: postId, bindedPostId: bindedPostId);
    if (isSuccess) {
      emit(PostBindState.rejectedRequest());
    } else {
      emit(PostBindState.error('Failed to reject post bind request.'));
    }
  }

  acceptPostBindRequest({required Post post, required String bindedPostId}) async {
    emit(PostBindState.loading());
    final isSuccess = await PostBindRepository().acceptPostBindRequest(post: post, bindedPostId: bindedPostId);
    if (isSuccess) {
      emit(PostBindState.accepetedRequest());
      FeedRepository().fetchPosts();
    } else {
      emit(PostBindState.error('Failed to accept friend request.'));
    }
  }
}
