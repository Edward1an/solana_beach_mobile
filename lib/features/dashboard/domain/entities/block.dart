import 'package:equatable/equatable.dart';

class Block extends Equatable {
  final String blockHash;
  final int blockNumber;
  final String previousBlockHash;
  final String proposer;
  final int txCount;
  final int failedTxs;
  final int successfulTxs;
  final int innerInstructions;
  final int totalFees;
  final DateTime blockTime;
  final String proposerName;
  final String proposerPublicKey;
  final String proposerImage;

  const Block({
    required this.blockHash,
    required this.blockNumber,
    required this.previousBlockHash,
    required this.proposer,
    required this.txCount,
    required this.failedTxs,
    required this.successfulTxs,
    required this.innerInstructions,
    required this.totalFees,
    required this.blockTime,
    required this.proposerName,
    required this.proposerPublicKey,
    required this.proposerImage,
  });

  @override
  String toString() {
    return " image: $proposerImage, name: $proposerName, proposer: $proposerPublicKey";
  }

  @override
  List<Object?> get props => [
    blockHash,
    blockNumber,
    previousBlockHash,
    proposer,
    txCount,
    failedTxs,
    successfulTxs,
    innerInstructions,
    totalFees,
    blockTime,
    proposerName,
    proposerPublicKey,
    proposerImage,
  ];
}
