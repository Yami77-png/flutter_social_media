import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/memories/domain/interface/i_memories_repository.dart';

part 'fetch_memories_state.dart';
part 'fetch_memories_cubit.freezed.dart';

@injectable
class FetchMemoriesCubit extends Cubit<FetchMemoriesState> {
  final IMemoriesRepository _iMemoriesRepository;

  FetchMemoriesCubit(this._iMemoriesRepository) : super(const FetchMemoriesState.initial()) {
    fetchMemories();
  }

  Future<void> fetchMemories() async {
    emit(const FetchMemoriesState.loading());
    try {
      final memories = await _iMemoriesRepository.fetchMemories();

      if (memories.isNotEmpty) {
        emit(FetchMemoriesState.loaded(memories));
      } else {
        emit(const FetchMemoriesState.empty());
      }
    } catch (e) {
      emit(const FetchMemoriesState.error('Failed to load memories feed.'));
    }
  }

  void addAudioAtTop(Post memory) {
    if (state is _Loaded) {
      final current = (state as _Loaded).memories;
      emit(FetchMemoriesState.loaded([memory, ...current]));
    }
  }
}
