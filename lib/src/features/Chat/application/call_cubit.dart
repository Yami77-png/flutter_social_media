import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_media/src/sandbox/webroomrtc.dart';

enum CallStatus { idle, ringing, answered, declined, ended, missed }

class CallCubit extends Cubit<CallStatus> {
  CallCubit() : super(CallStatus.idle);

  void callAnswered() => emit(CallStatus.answered);
  void callDeclined() {
    emit(CallStatus.declined);
    print('call declined emitted');
  }

  Future<void> callEnded({String? callId}) async {
    if (callId != null) await WebRTCRoomService().endCall(callId, CallStatus.ended.name);
    emit(CallStatus.ended);
    print('call ended emitted');
  }

  void callMissed() => emit(CallStatus.missed);
  void reset() => emit(CallStatus.idle);
}
