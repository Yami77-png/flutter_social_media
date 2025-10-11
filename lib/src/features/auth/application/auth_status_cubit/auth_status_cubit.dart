import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/helpers/hive_helper.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';
part 'auth_status_state.dart';
part 'auth_status_cubit.freezed.dart';

class AuthStatusCubit extends Cubit<AuthStatusState> {
  AuthStatusCubit(this._authRepository) : super(AuthStatusState.authenticated()) {
    checkAuthStatus();
  }

  final IAuthRepository _authRepository;

  Future<void> checkAuthStatus() async {
    final isFirstTime = await HiveHelper.isFirstTimeUser();
    if (isFirstTime) {
      emit(AuthStatusState.firstTime());
      emit(AuthStatusState.unauthenticated());
      return;
    }

    final success = await _authRepository.isSignedin();

    if (success) {
      emit(AuthStatusState.authenticated());
    } else {
      emit(AuthStatusState.unauthenticated());
    }
  }

  // void logout() async {
  //   await _auth.signOut();
  //   emit(AuthStatusState.unauthenticated());
  // }
}
