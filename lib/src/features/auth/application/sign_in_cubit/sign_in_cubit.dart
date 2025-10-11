import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(SignInState.initial());

  final IAuthRepository _authRepository;

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInState.loading());
    try {
      final user = await _authRepository.signin(email: email, password: password);
      log("success");
      emit(SignInState.success(user));
    } on FirebaseAuthException catch (e) {
      log("error");
      emit(SignInState.error(e.message ?? 'Unknown Firebase error'));
    } catch (e) {
      emit(SignInState.error('Sign-in failed: $e'));
    }
  }
}
