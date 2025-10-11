import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/src/features/Profile/domain/interface/i_location_repository.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

import '../../../core/helpers/dio_helper.dart';
import '../../auth/domain/models/user.dart';

class LocationRepository implements ILocationRepository {
  final String _apiKey;
  final FirebaseFirestore _firestore;

  LocationRepository(this._apiKey, this._firestore);

  @override
  Future<List<Location>> searchPlaces(String query) async {
    final data = {'textQuery': query};

    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': 'places.displayName,places.formattedAddress',
    };

    final response = await DioHelper.post(
      'places:searchText',
      data: data,
      headers: headers,
      overrideBaseUrl: 'https://places.googleapis.com/v1/',
    );

    final List results = response['places'];

    return results.map((place) {
      final name = place['displayName']['text'] ?? '';
      final address = place['formattedAddress'] ?? '';
      return Location(name: name, address: address);
    }).toList();
  }

  @override
  Future<void> saveLocation(Location location, bool? isHometown) async {
    final Userx? user = await AuthRepository().getCurrentUserData();
    final String? refid = user?.refid;

    if (isHometown == true) {
      await _firestore.collection('individuals').doc(refid).set({
        'hometown': location.address,
      }, SetOptions(merge: true));
    } else {
      await _firestore.collection('individuals').doc(refid).set({
        'currentAddress': location.address,
      }, SetOptions(merge: true));
    }
  }
}
