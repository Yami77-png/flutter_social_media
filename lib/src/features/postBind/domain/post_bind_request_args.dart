class PostBindRequestPageArgs {
  final String postId;
  final String bindedPostId;
  final String notificationId;

  const PostBindRequestPageArgs({required this.postId, required this.bindedPostId, required this.notificationId});
}

const int postBindLimit = 5;
