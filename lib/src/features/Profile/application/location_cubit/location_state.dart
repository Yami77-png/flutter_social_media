import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/Profile/domain/models/location_model.dart';

part 'location_state.freezed.dart';

@freezed
abstract class LocationState with _$LocationState {
  const factory LocationState({
    @Default([]) List<Location> results,
    @Default(false) bool isLoading,
    Location? selected,
  }) = _LocationState;
}
