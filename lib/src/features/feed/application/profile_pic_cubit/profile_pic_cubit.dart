import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/features/auth/domain/models/user.dart';
import 'package:flutter_social_media/src/features/auth/infrastructure/auth_repository.dart';

part 'profile_pic_state.dart';
part 'profile_pic_cubit.freezed.dart';

class ProfilePicCubit extends Cubit<ProfilePicState> {
  ProfilePicCubit(this._authRepository) : super(ProfilePicState.loading());

  final AuthRepository _authRepository;
  Future<void> getUserInfo() async {
    var result = await _authRepository.getCurrentUserData();
    if (result != null) {
      emit(ProfilePicState.loaded(result));
    } else {
      emit(ProfilePicState.error("Something went wrong!!"));
    }
  }
}
