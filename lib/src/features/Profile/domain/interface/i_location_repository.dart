import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';

abstract class ILocationRepository {
  Future<List<Location>> searchPlaces(String query);
  Future<void> saveLocation(Location location, bool? isHometown);
}
