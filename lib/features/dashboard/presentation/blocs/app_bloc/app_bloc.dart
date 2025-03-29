import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  AppBloc() : super(const AppState(connectivityResult: [])) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      add(ChangeConnectivityEvent(connectivityResult: result));
    });
    on<ChangeConnectivityEvent>(_onChangeConnectivityEvent);
  }

  FutureOr<void> _onChangeConnectivityEvent(
    ChangeConnectivityEvent event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(connectivityResult: event.connectivityResult));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
