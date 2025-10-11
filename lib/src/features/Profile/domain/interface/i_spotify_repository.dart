import 'package:flutter_social_media/src/features/Profile/domain/models/album_model.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/artist_model.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/track_model.dart';

abstract class ISpotifyRepository {
  Future<List<Track>> searchTracks(String query);
  Future<Album> getAlbum(String id);
  Future<Artist> getArtist(String id);
}
