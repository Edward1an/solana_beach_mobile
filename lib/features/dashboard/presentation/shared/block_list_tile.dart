import 'package:flutter/material.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';

class BlockListTile extends StatefulWidget {
  final Block block;
  final int index;

  const BlockListTile({required this.block, required this.index, super.key});

  @override
  State<BlockListTile> createState() => _BlockListTileState();
}

class _BlockListTileState extends State<BlockListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.index % 2 == 0;
    final Color bgColor =
        isDark ? const Color(0xFF252525) : const Color(0xFF2E2E2E);
    final double successRate =
        widget.block.successfulTxs / widget.block.txCount;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        color: bgColor,
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Block #${widget.block.blockNumber}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.code, color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Hash: ${widget.block.blockHash.substring(0, 4)}...${widget.block.blockHash.substring(widget.block.blockHash.length - 4)}",
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.orangeAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Previous: ${widget.block.previousBlockHash.substring(0, 4)}...${widget.block.previousBlockHash.substring(widget.block.previousBlockHash.length - 4)}",
                      style: const TextStyle(color: Colors.white54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.transfer_within_a_station,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "TXs: ${widget.block.txCount} (Failed: ${widget.block.failedTxs}, Successful: ${widget.block.successfulTxs})",
                      style: const TextStyle(color: Colors.greenAccent),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.yellowAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Success Rate: ${(successRate * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.insert_chart,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Inner Instructions: ${widget.block.innerInstructions}",
                      style: const TextStyle(color: Colors.orangeAccent),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: Colors.deepOrangeAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Total Fees: ${(widget.block.totalFees / 1000000000).toStringAsFixed(9)} SOL",
                      style: const TextStyle(color: Colors.redAccent),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
