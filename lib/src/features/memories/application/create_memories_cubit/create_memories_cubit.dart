import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';
import 'package:flutter_social_media/src/features/memories/domain/interface/i_memories_repository.dart';

part 'create_memories_state.dart';
part 'create_memories_cubit.freezed.dart';

@injectable
class CreateMemoriesCubit extends Cubit<CreateMemoriesState> {
  CreateMemoriesCubit(this._iMemoriesRepository) : super(CreateMemoriesState.initial());
  final IMemoriesRepository _iMemoriesRepository;

  Future<void> createMemory({
    String? caption,
    required List<File> attachments,
    List<String>? tags,
    PostPrivacy privacy = PostPrivacy.PUBLIC,
    required int timePeriodInHour,
  }) async {
    emit(const CreateMemoriesState.uploading(message: 'Publishing your memory...'));
    var result = await AuthRepository().getCurrentUserData();
    if (result == null) {
      emit(const CreateMemoriesState.error(message: 'User not found. Please log in again.'));
      return;
    }

    try {
      final postedby = PostedBy(id: result.uuid, name: result.name, imageUrl: result.imageUrl);
      final memory = await _iMemoriesRepository.createMemory(
        postedBy: postedby,
        attachments: attachments,
        caption: caption,
        privacy: privacy,
        timePeriodInHour: timePeriodInHour,
      );

      if (memory != null) {
        emit(CreateMemoriesState.success(message: 'Memory published successfully!', memory: memory));
      } else {
        emit(const CreateMemoriesState.error(message: 'Failed to publish Memory. Please try again.'));
      }
    } catch (e) {
      emit(CreateMemoriesState.error(message: 'An unexpected error occurred: $e'));
    }
  }

  void clearState() {
    emit(const CreateMemoriesState.initial());
  }
}
