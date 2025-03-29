import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/core/usecase/use_case.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';

class GetBlockByNumberUseCase
    implements UseCase<Future<DataState<Block>>, String> {
  final BlockRepository blockRepository;

  GetBlockByNumberUseCase({required this.blockRepository});

  @override
  Future<DataState<Block>> call({required String param}) async {
    return await blockRepository.getBlockByNumber(param);
  }
}
