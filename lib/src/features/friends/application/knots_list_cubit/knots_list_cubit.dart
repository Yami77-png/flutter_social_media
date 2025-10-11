import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/friends/domain/knot_model.dart';
import 'package:flutter_social_media/src/features/friends/infrustructure/knots_list_repository.dart';

part 'knots_list_state.dart';
part 'knots_list_cubit.freezed.dart';

class KnotsListCubit extends Cubit<KnotsListState> {
  final KnotsListRepository _knotsListRepository;
  KnotsListCubit(this._knotsListRepository) : super(KnotsListState.initial());

  Future<void> fetchKnots() async {
    emit(const KnotsListState.loading());
    try {
      final List<KnotModel> knots = await _knotsListRepository.fetchKnots();

      emit(KnotsListState.knotsLoaded(knots));
    } catch (e) {
      log('Error in KnotsListCubit: $e');
      emit(const KnotsListState.error('Failed to load your requests.'));
    }
  }

  Future<void> fetchRequestedKnots() async {
    emit(const KnotsListState.loading());
    try {
      final List<KnotModel> knots = await _knotsListRepository.fetchRequestedKnots();

      emit(KnotsListState.requestedKnotsLoaded(knots));
    } catch (e) {
      log('Error in KnotsListCubit: $e');
      emit(const KnotsListState.error('Failed to load your requests.'));
    }
  }

  Future<void> fetchIncomingKnots() async {
    emit(const KnotsListState.loading());
    try {
      final List<KnotModel> knots = await _knotsListRepository.fetchIncomingKnots();

      emit(KnotsListState.incomingKnotsLoaded(knots));
    } catch (e) {
      log('Error in KnotsListCubit: $e');
      emit(const KnotsListState.error('Failed to load your requests.'));
    }
  }
}
