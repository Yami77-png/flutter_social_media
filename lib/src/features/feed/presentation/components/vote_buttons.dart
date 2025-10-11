import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/features/feed/application/like_cubit/like_cubit.dart';
import 'package:flutter_social_media/src/features/feed/application/like_cubit/like_state.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:flutter_social_media/src/features/feed/infrastructure/feed_repository.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

class VoteButtons extends StatelessWidget {
  final Post post;

  const VoteButtons({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = LikeCubit(FeedRepository(), AuthRepository());
        cubit.init(post.id); // only pass post id
        return cubit;
      },
      child: BlocBuilder<LikeCubit, LikeState>(
        builder: (context, state) {
          final cubit = context.read<LikeCubit>();

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Upvote button
                GestureDetector(
                  onTap: () {
                    cubit.vote(state.vote == VoteType.up ? VoteType.none : VoteType.up);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_upward,
                      color: state.vote == VoteType.up ? AppColors.primaryColor : Colors.grey,
                    ),
                  ),
                ),

                // Divider
                Container(width: 1, height: 32, color: Colors.grey.shade300),

                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '${state.score}', // just show score
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),

                // Divider
                Container(width: 1, height: 32, color: Colors.grey.shade300),

                // Downvote button
                GestureDetector(
                  onTap: () {
                    cubit.vote(state.vote == VoteType.down ? VoteType.none : VoteType.down);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.arrow_downward, color: state.vote == VoteType.down ? Colors.red : Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
