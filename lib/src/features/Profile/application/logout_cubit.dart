import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';
// Make sure to import your actual AuthRepository path
// --- STATES ---
// All possible states for the logout feature are defined here.

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailure extends LogoutState {
  final String error;
  LogoutFailure(this.error);
}

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository;

  LogoutCubit(this._authRepository) : super(LogoutInitial());

  Future<void> signOut() async {
    emit(LogoutLoading());
    try {
      await _authRepository.signOut();
      await HiveHelper.clearCurrentUserId();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
