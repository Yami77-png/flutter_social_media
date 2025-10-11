import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_social_media/src/core/domain/error.dart';
import 'package:flutter_social_media/src/features/Profile/domain/interface/i_user_repository.dart';

part 'knot_request_state.dart';
part 'knot_request_cubit.freezed.dart';

class KnotRequestCubit extends Cubit<KnotRequestState> {
  KnotRequestCubit(this.iUserRepository) : super(KnotRequestState.initial());
  IUserRepository iUserRepository;

  Future<void> sendCustomKnotRequest({required String id}) async {
    emit(KnotRequestState.sendingRequest());

    var result = await iUserRepository.sendCustomKnotRequest(id);

    if (!result) {
      emit(KnotRequestState.error(ErrorModel(errorText: 'Cannot send Knot request', status: '404')));
      return; // ⛔️ Prevent further emit
    }

    emit(KnotRequestState.sentRequest());
  }
}
