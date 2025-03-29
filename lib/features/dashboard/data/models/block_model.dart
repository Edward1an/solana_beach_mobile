import 'package:equatable/equatable.dart';

class BlockModel extends Equatable {
  final String blockHash;
  final int blockNumber;
  final String previousBlockHash;
  final String proposer;
  final int txCount;
  final int failedTxs;
  final int successfulTxs;
  final int innerInstructions;
  final int totalFees;
  final int blockTime;
  final String proposerName;
  final String proposerPublicKey;
  final String proposerImage;

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      blockHash: json['blockhash'] ?? '',
      blockNumber: json['blocknumber'] ?? 0,
      previousBlockHash: json['previousblockhash'] ?? '',
      proposer: json['proposer'] ?? '',
      txCount: (json['metrics']?['txcount'] ?? 0) as int,
      failedTxs: (json['metrics']?['failedtxs'] ?? 0) as int,
      successfulTxs: (json['metrics']?['sucessfultxs'] ?? 0) as int,
      innerInstructions: (json['metrics']?['innerinstructions'] ?? 0) as int,
      totalFees: (json['metrics']?['totalfees'] ?? 0) as int,
      blockTime: (json['blocktime']?['relative'] ?? 0) as int,
      proposerName: json['proposerData']?['name'] ?? '',
      proposerPublicKey: json['proposerData']?['nodePubkey'] ?? '',
      proposerImage: json['proposerData']?['image'] ?? '',
    );
  }

  static List<BlockModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => BlockModel.fromJson(e)).toList();
  }

  const BlockModel({
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
