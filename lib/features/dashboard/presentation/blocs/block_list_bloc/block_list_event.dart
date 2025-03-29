part of 'block_list_bloc.dart';

sealed class BlockListEvent extends Equatable {
  const BlockListEvent();
}

final class GetLatestBlocksEvent extends BlockListEvent {
  const GetLatestBlocksEvent();

  @override
  List<Object> get props => [];
}
