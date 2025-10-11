// import 'dart:developer';

// import 'package:flutter_social_media/src/features/Profile/domain/interface/i_spotify_repository.dart';
// import 'package:flutter_social_media/src/features/Profile/domain/models/album_model.dart';
// import 'package:flutter_social_media/src/features/Profile/domain/models/artist_model.dart';
// import 'package:flutter_social_media/src/features/Profile/domain/models/track_model.dart';
// import 'package:flutter_social_media/src/features/Profile/infrastructure/spotify_auth_service.dart';

// import '../../../core/helpers/dio_helper.dart';

// class SpotifyRepository implements ISpotifyRepository {
//   final String baseUrl = 'https://api.spotify.com/v1/';

//   Future<Map<String, String>> _getHeaders() async {
//     final token = await SpotifyAuthService().getValidAccessToken(); // from Hive or fresh
//     return {'Authorization': 'Bearer $token'};
//   }

//   @override
//   Future<List<Track>> searchTracks(String query) async {
//     try {
//       final headers = await _getHeaders();
//       final data = await DioHelper.get(
//         'search',
//         queryParams: {'q': query, 'type': 'track'},
//         headers: headers,
//         overrideBaseUrl: baseUrl,
//       );

//       final items = data['tracks']['items'] as List<dynamic>;
//       inspect(items);
//       return items.map((item) => Track.fromJson(item)).toList();
//     } catch (e) {
//       print('Error searching tracks: $e');
//       return [];
//     }
//   }

//   @override
//   Future<Album> getAlbum(String id) async {
//     try {
//       final headers = await _getHeaders();
//       final data = await DioHelper.get('albums/$id', headers: headers, overrideBaseUrl: baseUrl);
//       return Album.fromJson(data);
//     } catch (e) {
//       print('Error fetching album: $e');
//       return Album.empty();
//     }
//   }

//   Future<Album> getNewReleases() async {
//     try {
//       final headers = await _getHeaders();
//       final data = await DioHelper.get('browse/new-releases', headers: headers, overrideBaseUrl: baseUrl);
//       inspect(data);
//       return Album.fromJson(data);
//     } catch (e) {
//       print('Error fetching new releases: $e');
//       return Album.empty();
//     }
//   }

//   @override
//   Future<Artist> getArtist(String id) async {
//     try {
//       final headers = await _getHeaders();
//       final data = await DioHelper.get('artists/$id', headers: headers, overrideBaseUrl: baseUrl);
//       return Artist.fromJson(data);
//     } catch (e) {
//       print('Error fetching artist: $e');
//       return Artist.empty();
//     }
//   }
// }
