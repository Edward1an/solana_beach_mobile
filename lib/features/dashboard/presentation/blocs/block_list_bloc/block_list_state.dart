part of 'block_list_bloc.dart';

sealed class BlockListState extends Equatable {
  const BlockListState();
}

final class BlockListInitial extends BlockListState {
  const BlockListInitial();

  @override
  List<Object> get props => [];
}

final class BlockListLoading extends BlockListState {
  const BlockListLoading();

  @override
  List<Object> get props => [];
}

final class BlockListLoaded extends BlockListState {
  final List<Block> blocks;

  const BlockListLoaded({required this.blocks});

  @override
  List<Object> get props => [blocks];
}

final class BlockListFailed extends BlockListState {
  final String message;

  const BlockListFailed({required this.message});

  @override
  List<Object> get props => [message];
}
