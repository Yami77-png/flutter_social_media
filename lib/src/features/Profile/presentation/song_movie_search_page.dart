// import 'package:flutter/material.dart';
// import 'package:flutter_social_media/src/features/Profile/domain/models/movie_model.dart';
// import 'package:flutter_social_media/src/features/Profile/domain/models/track_model.dart';
// import 'package:flutter_social_media/src/features/Profile/infrastructure/movie_repository.dart';
// import 'package:flutter_social_media/src/features/Profile/infrastructure/spotify_repository.dart';

// class SongMovieSearch extends StatefulWidget {
//   final String searchType;

//   const SongMovieSearch({super.key, required this.searchType});

//   @override
//   State<SongMovieSearch> createState() => _SongMovieSearchState();
// }

// class _SongMovieSearchState extends State<SongMovieSearch> {
//   final SpotifyRepository spotifyRepo = SpotifyRepository();
//   final MovieRepository movieRepo = MovieRepository();

//   final TextEditingController _controller = TextEditingController();
//   String dropdownValue = 'Song';

//   List<Track> trackResults = [];
//   List<Movie> movieResults = [];

//   bool isLoading = false;

//   void _search() async {
//     final query = _controller.text.trim();
//     if (query.isEmpty) return;

//     setState(() {
//       isLoading = true;
//       trackResults = [];
//       movieResults = [];
//     });

//     if (widget.searchType.toLowerCase() == 'song') {
//       final results = await spotifyRepo.searchTracks(query);
//       setState(() {
//         trackResults = results;
//       });
//     } else if (widget.searchType.toLowerCase() == 'movie') {
//       final results = await movieRepo.searchMovies(query);
//       setState(() {
//         movieResults = results;
//       });
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Widget _buildTrackItem(Track track) {
//     return ListTile(
//       leading:
//           track.thumbnailUrl.isNotEmpty
//               ? Image.network(track.thumbnailUrl, width: 50, height: 50, fit: BoxFit.cover)
//               : const SizedBox.shrink(),
//       title: Text(track.name),
//       subtitle: Text(track.artistNames.join(', ')),
//     );
//   }

//   Widget _buildMovieItem(Movie movie) {
//     return ListTile(
//       leading:
//           movie.posterPath.isNotEmpty
//               ? Image.network(
//                 "https://image.tmdb.org/t/p/w500${movie.posterPath}",
//                 width: 50,
//                 height: 75,
//                 fit: BoxFit.cover,
//               )
//               : const SizedBox.shrink(),
//       title: Text(movie.title),
//       subtitle: Text(movie.releaseDate),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Search Songs or Movies')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Search ${widget.searchType == 'song' ? 'Songs' : 'Movies'}',
//               ),
//               onSubmitted: (_) => _search(),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(onPressed: _search, child: const Text('Search')),
//             const SizedBox(height: 20),
//             Expanded(
//               child:
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : widget.searchType == 'song'
//                       ? ListView.builder(
//                         itemCount: trackResults.length,
//                         itemBuilder: (context, index) => _buildTrackItem(trackResults[index]),
//                       )
//                       : ListView.builder(
//                         itemCount: movieResults.length,
//                         itemBuilder: (context, index) => _buildMovieItem(movieResults[index]),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
