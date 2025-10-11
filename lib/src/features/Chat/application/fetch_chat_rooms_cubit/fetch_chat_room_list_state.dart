part of 'fetch_chat_room_list_cubit.dart';

@freezed
class FetchChatRoomListState with _$FetchChatRoomListState {
  const factory FetchChatRoomListState.loading() = _Loading;
  const factory FetchChatRoomListState.loaded(List<ChatRoomModel> chats) = _Loaded;
  const factory FetchChatRoomListState.error() = _Error;
}
