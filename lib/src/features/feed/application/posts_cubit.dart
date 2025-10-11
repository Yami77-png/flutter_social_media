import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';

class PostsCubit extends Cubit<Map<String, Post>> {
  PostsCubit(super.initialState);

  void setPosts(List<Post> posts) {
    emit({for (final post in posts) post.id: post});
  }

  List<Post> get allPosts => state.values.toList();

  Post? getPost(String id) => state[id];
  void updatePost(Post post) {
    final updatedPosts = Map<String, Post>.from(state);
    updatedPosts[post.id] = post;
    emit(updatedPosts);
  }

  void addPostAtTop(Post post) {
    final updated = <String, Post>{post.id: post, ...state};
    emit(updated);
  }
}
