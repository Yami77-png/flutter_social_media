import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/signup_dto.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(SignUpState.initial());

  final IAuthRepository _authRepository;

  Future<void> signUp({required SignupDto dto}) async {
    emit(const SignUpState.loading());

    try {
      final result = await _authRepository.signUp(signupDto: dto);
      if (result) {
        emit(SignUpState.success('Account created successfully!'));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignUpState.error(e.message ?? 'Authentication error occurred'));
    } catch (e) {
      log('SignUp failed: $e');
      emit(SignUpState.error('An unexpected error occurred. Try again later.'));
    }
  }
}
