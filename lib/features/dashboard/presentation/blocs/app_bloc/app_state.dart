part of 'app_bloc.dart';

class AppState extends Equatable {
  final List<ConnectivityResult> connectivityResult;

  AppState copyWith({List<ConnectivityResult>? connectivityResult}) {
    return AppState(
      connectivityResult: connectivityResult ?? this.connectivityResult,
    );
  }

  const AppState({required this.connectivityResult});

  @override
  List<Object?> get props => [connectivityResult];
}
