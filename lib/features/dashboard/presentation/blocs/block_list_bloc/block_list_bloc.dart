import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';
import 'package:solana_beach/features/dashboard/domain/usecases/get_latest_blocks_use_case.dart';

part 'block_list_event.dart';
part 'block_list_state.dart';

class BlockListBloc extends Bloc<BlockListEvent, BlockListState> {
  final BlockRepository blockRepository = GetIt.I<BlockRepository>();

  BlockListBloc() : super(const BlockListInitial()) {
    on<GetLatestBlocksEvent>(_onGetLatestBlocks);
  }

  Future<void> _onGetLatestBlocks(
    GetLatestBlocksEvent event,
    Emitter<BlockListState> emit,
  ) async {
    emit(const BlockListLoading());
    final useCase = GetLatestBlocksUseCase(blockRepository: blockRepository);
    final result = await useCase(param: null);
    if (result is DataSuccess && result.data != null) {
      emit(BlockListLoaded(blocks: result.data!));
    } else {
      emit(BlockListFailed(message: result.message ?? 'Unknown error'));
    }
  }
}
