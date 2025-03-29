import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';

abstract class BlockRepository {
  Future<DataState<List<Block>>> getLatestBlocks();
  Future<DataState<Block>> getBlockByNumber(String number);
}
