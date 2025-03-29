// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/presentation/blocs/block_bloc/block_bloc.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockDetailsScreen extends StatefulWidget {
  final String blockNumber;

  const BlockDetailsScreen({required this.blockNumber, super.key});

  @override
  State<BlockDetailsScreen> createState() => BlockDetailsScreenState();
}

class BlockDetailsScreenState extends State<BlockDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<BlockBloc>().add(GetBlockByNumberEvent(widget.blockNumber));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem(
    Widget child, {
    Offset beginOffset = const Offset(0, 0.2),
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
      child: FadeTransition(opacity: _fadeAnimation, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Block Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<BlockBloc, BlockState>(
        builder: (context, state) {
          if (state is BlockLoaded) {
            final block = state.block;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedItem(
                      _buildInfoTile(
                        "Block Hash",
                        block.blockHash,
                        Icons.code,
                        Colors.blue,
                      ),
                      beginOffset: const Offset(-0.2, 0),
                    ),
                    _buildAnimatedItem(
                      _buildInfoTile(
                        "Block Number",
                        block.blockNumber.toString(),
                        Icons.numbers,
                        Colors.blue,
                      ),
                      beginOffset: const Offset(0.2, 0),
                    ),
                    _buildAnimatedItem(
                      _buildInfoTile(
                        "Previous Block Hash",
                        block.previousBlockHash,
                        Icons.arrow_back,
                        Colors.blue,
                      ),
                      beginOffset: const Offset(0, -0.2),
                    ),

                    const SizedBox(height: 20),
                    _buildAnimatedItem(
                      _buildSectionHeader(
                        "Proposer Info",
                        Icons.person,
                        Colors.deepPurple,
                      ),
                    ),
                    _buildAnimatedItem(_buildProposerInfo(block)),

                    const SizedBox(height: 20),
                    _buildAnimatedItem(
                      _buildSectionHeader(
                        "Transaction Metrics",
                        Icons.analytics,
                        Colors.blue,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedItem(
                                _buildColoredTile(
                                  "Total Transactions",
                                  block.txCount.toString(),
                                  Colors.blue,
                                ),
                                beginOffset: const Offset(-0.2, 0),
                              ),
                            ),
                            Expanded(
                              child: _buildAnimatedItem(
                                _buildColoredTile(
                                  "Successful Transactions",
                                  block.successfulTxs.toString(),
                                  Colors.green,
                                ),
                                beginOffset: const Offset(0.2, 0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedItem(
                                _buildColoredTile(
                                  "Failed Transactions",
                                  block.failedTxs.toString(),
                                  Colors.red,
                                ),
                                beginOffset: const Offset(-0.2, 0),
                              ),
                            ),
                            Expanded(
                              child: _buildAnimatedItem(
                                _buildColoredTile(
                                  "Inner Instructions",
                                  block.innerInstructions.toString(),
                                  Colors.orange,
                                ),
                                beginOffset: const Offset(0.2, 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedItem(
                      _buildInfoTile(
                        "Block Time",
                        format(block.blockTime),
                        Icons.access_time,
                        Colors.blue,
                      ),
                      beginOffset: const Offset(0.2, 0),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is BlockLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is BlockFailed) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    child: const Text("Retry"),
                    onPressed: () {
                      context.read<BlockBloc>().add(
                        GetBlockByNumberEvent(widget.blockNumber),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.copy, color: Colors.grey),
          onPressed: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Copied to clipboard"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        onLongPress: () async {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Copied to clipboard"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  Widget _buildColoredTile(String title, String value, Color color) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(value, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildProposerInfo(Block block) {
    return GestureDetector(
      onTap: () async {
        /// in full project this should be a separate screen. However for simplicity, we are just launching the validator url
        if (!await launchUrl(
          Uri.parse('https://solanabeach.io/validator/${block.proposer}'),
        )) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Could not launch validator url"),
                ],
              ),
              backgroundColor: Colors.redAccent,
              duration: const  Duration(seconds: 1),
              dismissDirection: DismissDirection.none,
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            backgroundImage:
                block.proposerImage.isNotEmpty
                    ? NetworkImage(block.proposerImage)
                    : null,
            child:
                block.proposerImage.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
          ),
          title: Text(
            block.proposerName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Public Key: ${block.proposerPublicKey}"),
          trailing: const Icon(
            Icons.account_circle,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
