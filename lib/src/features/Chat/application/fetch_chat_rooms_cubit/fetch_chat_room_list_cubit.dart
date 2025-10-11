import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/Chat/domain/models/chat_room_model.dart';
import 'package:flutter_social_media/src/features/Chat/infrastructure/chat_service.dart';

part 'fetch_chat_room_list_state.dart';
part 'fetch_chat_room_list_cubit.freezed.dart';

class FetchChatRoomListCubit extends Cubit<FetchChatRoomListState> {
  FetchChatRoomListCubit() : super(FetchChatRoomListState.loading());

  Future<void> getChatList() async {
    var result = await ChatService().getUserChatRooms();
    if (result.isNotEmpty) {
      emit(FetchChatRoomListState.loaded(result));
    } else {
      emit(FetchChatRoomListState.error());
    }
  }
}
