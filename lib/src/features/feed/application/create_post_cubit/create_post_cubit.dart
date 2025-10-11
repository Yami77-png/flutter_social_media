import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/interface/i_feed_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';

import '../../domain/models/post.dart';

part 'create_post_state.dart';
part 'create_post_cubit.freezed.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit(this._iFeedRepository) : super(CreatePostState.initial());
  final IFeedRepository _iFeedRepository;

  Future<void> createPost({
    required String caption,
    List<File>? attachments,
    List<String>? tags,
    bool isVideo = false,
    bool isAudio = false,
    PostPrivacy privacy = PostPrivacy.PUBLIC,
    Post? bindedPost,
  }) async {
    emit(const CreatePostState.uploading(message: 'Publishing your post...'));
    var result = await AuthRepository().getCurrentUserData();
    if (result == null) {
      emit(const CreatePostState.error(message: 'User not found. Please log in again.'));
      return;
    }

    try {
      final postedby = PostedBy(id: result.uuid, name: result.name, imageUrl: result.imageUrl);
      final post = await _iFeedRepository.createPost(
        postedBy: postedby,
        attachments: attachments,
        caption: caption,
        isVideo: isVideo,
        isAudio: isAudio,
        privacy: privacy,
        bindedPost: bindedPost,
      );

      if (post != null) {
        emit(CreatePostState.success(message: 'Post published successfully!', post: post));
      } else {
        emit(const CreatePostState.error(message: 'Failed to publish post. Please try again.'));
      }
    } catch (e) {
      emit(CreatePostState.error(message: 'An unexpected error occurred: $e'));
    }
  }

  void clearState() {
    emit(const CreatePostState.initial());
  }
}
