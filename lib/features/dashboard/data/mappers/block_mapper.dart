import 'package:solana_beach/features/dashboard/data/models/block_model.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';

class BlockMapper {
  const BlockMapper._();

  static Block toEntity(BlockModel model) {
    return Block(
      blockHash: model.blockHash,
      blockNumber: model.blockNumber,
      previousBlockHash: model.previousBlockHash,
      proposer: model.proposer,
      txCount: model.txCount,
      failedTxs: model.failedTxs,
      successfulTxs: model.successfulTxs,
      innerInstructions: model.innerInstructions,
      totalFees: model.totalFees,
      blockTime: DateTime.fromMillisecondsSinceEpoch(model.blockTime*1000),
      proposerName: model.proposerName,
      proposerPublicKey: model.proposerPublicKey,
      proposerImage: model.proposerImage,
    );
  }

  static BlockModel toModel(Block entity) {
    return BlockModel(
      blockHash: entity.blockHash,
      blockNumber: entity.blockNumber,
      previousBlockHash: entity.previousBlockHash,
      proposer: entity.proposer,
      txCount: entity.txCount,
      failedTxs: entity.failedTxs,
      successfulTxs: entity.successfulTxs,
      innerInstructions: entity.innerInstructions,
      totalFees: entity.totalFees,
      blockTime: entity.blockTime.millisecondsSinceEpoch,
      proposerName: entity.proposerName,
      proposerPublicKey: entity.proposerPublicKey,
      proposerImage: entity.proposerImage,
    );
  }
}
