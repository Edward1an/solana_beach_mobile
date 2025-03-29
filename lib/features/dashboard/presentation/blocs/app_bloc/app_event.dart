part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();
}

class ChangeConnectivityEvent extends AppEvent {
  final List<ConnectivityResult> connectivityResult;

  const ChangeConnectivityEvent({required this.connectivityResult});

  @override
  List<Object?> get props => [connectivityResult];
}
