import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/comment.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/selected_media.dart';
import 'package:flutter_social_media/src/features/feed/presentation/components/app_image_viewer.dart';
import 'package:tenor_dart/tenor_dart.dart';

enum SearchMediaType { gif, sticker }

Future<SelectedMedia?> showCommentGifStickerBottomSheet(BuildContext context, {required SearchMediaType mediaType}) {
  return showModalBottomSheet<SelectedMedia>(
    context: context,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    builder: (context) => CommentGifStickerBottomSheet(mediaType: mediaType),
  );
}

class CommentGifStickerBottomSheet extends StatefulWidget {
  final SearchMediaType mediaType;
  const CommentGifStickerBottomSheet({super.key, required this.mediaType});

  @override
  State<CommentGifStickerBottomSheet> createState() => _CommentGifStickerBottomSheetState();
}

class _CommentGifStickerBottomSheetState extends State<CommentGifStickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Tenor tenor = Tenor(apiKey: ''); // TODO: Add Tenor API Key

  List<TenorResult> _results = [];
  bool _isLoading = true;
  bool _hasMore = true;
  String? _next;
  String _currentQuery = '';

  bool get _isSearchingForStickers => widget.mediaType == SearchMediaType.sticker;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // fetch data for GIFs or Stickers.
  Future<void> _fetchData({bool isNewSearch = false}) async {
    if (isNewSearch) {
      setState(() {
        _results = [];
        _next = null;
        _hasMore = true;
        _currentQuery = _searchController.text;
        _isLoading = true;
      });
    }

    if ((_isLoading && _results.isNotEmpty) || !_hasMore) return;

    setState(() => _isLoading = true);

    TenorResponse? response;
    if (_isSearchingForStickers) {
      final stickerQuery = _currentQuery.isEmpty ? "trending stickers" : "$_currentQuery";
      response = await tenor.search(stickerQuery, sticker: true, limit: 10, pos: _next);
    } else {
      response = _currentQuery.isEmpty
          ? await tenor.featured(limit: 10, pos: _next)
          : await tenor.search(_currentQuery, limit: 10, pos: _next);
    }

    if (mounted && response != null && response.results.isNotEmpty) {
      setState(() {
        _results.addAll(response!.results);
        _next = response.next;
        _hasMore = _next != null && _next!.isNotEmpty;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  void _onScroll() {
    // Check if we're near the end of the list and not already loading
    if (!_isLoading &&
        _hasMore &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hintText = _isSearchingForStickers ? 'Search for a Sticker' : 'Search for a GIF';

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                // Search
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: hintText,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _fetchData(isNewSearch: true),
                  ),
                ),
                onSubmitted: (query) => _fetchData(isNewSearch: true),
              ),
            ),
            Expanded(
              child: (_isLoading && _results.isEmpty)
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : (!_isLoading && _results.isEmpty)
                  ? Center(child: Text("No ${_isSearchingForStickers ? 'Stickers' : 'GIFs'} found."))
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _isSearchingForStickers ? 3 : 2, // Stickers are smaller, because looks good :)
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        final mediaObject = item.media.tinyGif;
                        final previewUrl = mediaObject?.url.toString() ?? '';

                        final aspectRatio = mediaObject?.dimensions.aspectRatio ?? 1.0;

                        return GestureDetector(
                          onTap: () {
                            if (previewUrl.isNotEmpty) {
                              final selectedUrl = item.media.tinyGif?.url.toString() ?? previewUrl;
                              final selectedItem = SelectedMedia(
                                url: selectedUrl,
                                aspectRatio: aspectRatio,
                                type: _isSearchingForStickers ? CommentType.sticker : CommentType.gif,
                              );
                              Navigator.pop(context, selectedItem);
                            }
                          },
                          child: AppImageViewer(previewUrl, fit: BoxFit.cover),
                        );
                      },
                    ),
            ),
            if (_isLoading && _results.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
          ],
        );
      },
    );
  }
}
