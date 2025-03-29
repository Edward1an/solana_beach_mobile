import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/core/usecase/use_case.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';

class GetLatestBlocksUseCase
    implements UseCase<Future<DataState<List<Block>>>, void> {
  final BlockRepository blockRepository;

  GetLatestBlocksUseCase({required this.blockRepository});

  @override
  Future<DataState<List<Block>>> call({required void param}) async {
    return await blockRepository.getLatestBlocks();
  }
}
