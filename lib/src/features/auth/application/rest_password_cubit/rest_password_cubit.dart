import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/domain/interface/i_auth_repository.dart';

part 'rest_password_state.dart';
part 'rest_password_cubit.freezed.dart';

class RestPasswordCubit extends Cubit<RestPasswordState> {
  RestPasswordCubit(this._authRepository) : super(RestPasswordState.initial());
  final IAuthRepository _authRepository;

  Future<void> restPassword({required String email}) async {
    emit(const RestPasswordState.loading());

    try {
      final success = await _authRepository.forgotPassword(email);
      if (success) {
        emit(const RestPasswordState.success());
      } else {
        emit(const RestPasswordState.failure('Failed to send password reset email.'));
      }
    } catch (e) {
      emit(RestPasswordState.failure('An error occurred: ${e.toString()}'));
    }
  }
}
