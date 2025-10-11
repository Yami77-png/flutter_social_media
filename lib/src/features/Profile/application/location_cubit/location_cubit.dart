import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/features/Profile/domain/interface/i_location_repository.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';

import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationRepository repository;

  LocationCubit(this.repository) : super(LocationState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(results: [], isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final results = await repository.searchPlaces(query);
      emit(state.copyWith(results: results, isLoading: false));
    } catch (_) {
      emit(
        state.copyWith(
          results: [Location(name: 'Test Location', address: 'Test Location')],
          isLoading: false,
        ),
      );
    }
  }

  void select(Location location) {
    emit(state.copyWith(selected: location));
  }

  Future<void> saveLocationToFirebase(Location location, bool? isHometown) async {
    try {
      await repository.saveLocation(location, isHometown);
      emit(state.copyWith(selected: location));
    } catch (e) {
      print('Error saving location: $e');
    }
  }
}
