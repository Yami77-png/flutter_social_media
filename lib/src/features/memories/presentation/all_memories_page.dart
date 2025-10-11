import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/auth/presentation/components/app_app_bar.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/carousel_media_viewer_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/components/memory_tile.dart';

class AllMemoriesPage extends StatelessWidget {
  static const String route = 'all_memories_page';
  const AllMemoriesPage({super.key, required this.memories});

  final List<Post> memories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Memories'),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.h,
            childAspectRatio: 0.7,
          ),
          itemCount: memories.length,
          itemBuilder: (context, index) {
            final memory = memories[index];
            return GestureDetector(
              onTap: () {
                final List<String> attachments = memories.map((memory) => memory.attachment?.first ?? '').toList();

                context.pushNamed(
                  CarouselMediaViewerPage.route,
                  queryParameters: {'index': index.toString()},
                  extra: attachments,
                );
              },
              child: MemoryTile(memory: memory, width: double.infinity),
            );
          },
        ),
      ),
    );
  }
}
