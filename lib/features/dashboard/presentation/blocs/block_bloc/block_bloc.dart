import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';
import 'package:solana_beach/features/dashboard/domain/usecases/get_block_by_number_use_case.dart';

part 'block_event.dart';
part 'block_state.dart';

class BlockBloc extends Bloc<BlockEvent, BlockState> {
  final BlockRepository blockRepository = GetIt.I<BlockRepository>();

  BlockBloc() : super(const BlockInitial()) {
    on<GetBlockByNumberEvent>(_onGetBlockByNumberEvent);
  }

  FutureOr<void> _onGetBlockByNumberEvent(
    GetBlockByNumberEvent event,
    Emitter<BlockState> emit,
  ) async {
    emit(const BlockLoading());
    final useCase = GetBlockByNumberUseCase(blockRepository: blockRepository);
    final result = await useCase(param: event.blockNumber);
    if (result is DataSuccess<Block> && result.data != null) {
      emit(BlockLoaded(result.data!));
    } else if (result is DataFailure) {
      emit(BlockFailed(result.message ?? "Unknown error"));
    }
  }
}
