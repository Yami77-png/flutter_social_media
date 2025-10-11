import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityCubit() : super(ConnectivityStatus.connected) {
    _listenNetworkConnection();
  }

  void _listenNetworkConnection() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        emit(ConnectivityStatus.disconnected);
      } else {
        emit(ConnectivityStatus.connected);
      }
    });
  }
}
