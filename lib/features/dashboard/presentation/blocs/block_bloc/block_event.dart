part of 'block_bloc.dart';

sealed class BlockEvent extends Equatable {
  const BlockEvent();
}

final class GetBlockByNumberEvent extends BlockEvent {
  final String blockNumber;

  const GetBlockByNumberEvent(this.blockNumber);

  @override
  List<Object> get props => [blockNumber];
}
