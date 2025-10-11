import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/friends/infrustructure/knot_repository.dart';

part 'knot_state.dart';
part 'knot_cubit.freezed.dart';

class KnotCubit extends Cubit<KnotState> {
  KnotCubit() : super(KnotState.initial());

  sendKnotRequest(Userx requestedUser) async {
    emit(KnotState.loading());
    final isSuccess = await KnotRepository().sendKnotRequest(requestedUser);
    if (isSuccess) {
      emit(KnotState.success());
    } else {
      emit(KnotState.error('Failed to send knot request.'));
    }
  }

  checkKnotRequest(String userId) async {
    emit(const KnotState.checkingKnot());
    try {
      final hasIncoming = await KnotRepository().hasIncomingKnots(userId);
      if (hasIncoming) {
        emit(const KnotState.hasIncomingKnot());
        log('hasIncomingKnot()');
        return;
      }

      final hasRequested = await KnotRepository().hasRequestedKnots(userId);
      if (hasRequested) {
        emit(const KnotState.hasRequestedKnot());
        log('hasRequestedKnot()');
        return;
      }

      final isAlreadyKnotted = await KnotRepository().isAlreadyKnotted(userId);
      if (isAlreadyKnotted) {
        emit(const KnotState.isKnotted());
        log('isAlreadyKnotted()');
        return;
      }

      emit(const KnotState.initial());
    } catch (e) {
      emit(KnotState.error('Failed to check knot status: $e'));
    }
  }

  cancelKnotRequest(String requestedUserId) async {
    emit(KnotState.loading());
    final isSuccess = await KnotRepository().cancelKnotRequest(requestedUserId);
    if (isSuccess) {
      emit(KnotState.cancaledRequest());
    } else {
      emit(KnotState.error('Failed to cancel knot request.'));
    }
  }

  rejectKnotRequest(String requestedUserId) async {
    emit(KnotState.loading());
    final isSuccess = await KnotRepository().rejectKnotRequest(requestedUserId);
    if (isSuccess) {
      emit(KnotState.rejectedRequest());
    } else {
      emit(KnotState.error('Failed to reject knot request.'));
    }
  }

  acceptKnotRequest(String requestedUserId) async {
    emit(KnotState.loading());
    final isSuccess = await KnotRepository().acceptKnotRequest(requestedUserId);
    if (isSuccess) {
      emit(KnotState.accepetedRequest());
    } else {
      emit(KnotState.error('Failed to accept knot request.'));
    }
  }
}

//tZx9qoLHengdJXehqzzP8gljtm62 alam
//8KbIpaYX8NeXhiBsgFE1EZw1cL73 avizit

//TODO
//code refactor to cubit
//notification
//knot accept/reject/cancel
