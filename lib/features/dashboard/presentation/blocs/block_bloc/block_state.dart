part of 'block_bloc.dart';

sealed class BlockState extends Equatable {
  const BlockState();
}

final class BlockInitial extends BlockState {
  const BlockInitial();
  @override
  List<Object> get props => [];
}

final class BlockLoading extends BlockState {
  const BlockLoading();
  @override
  List<Object> get props => [];
  
}

final class BlockLoaded extends BlockState {
  final Block block;
  const BlockLoaded(this.block);
  @override
    List<Object> get props => [block];
}

final class BlockFailed extends BlockState {
  final String message;
  const BlockFailed(this.message);
  @override
    List<Object> get props => [message];
}
