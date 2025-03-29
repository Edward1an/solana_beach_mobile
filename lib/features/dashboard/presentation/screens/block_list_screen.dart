import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_beach/config/constants/app_images.dart';
import 'package:solana_beach/features/dashboard/presentation/blocs/block_list_bloc/block_list_bloc.dart';
import 'package:solana_beach/features/dashboard/presentation/screens/block_details_screen.dart';
import 'package:solana_beach/features/dashboard/presentation/shared/block_list_search_delegate.dart';
import 'package:solana_beach/features/dashboard/presentation/shared/block_list_tile.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent - 200) {
      context.read<BlockListBloc>().add(const GetLatestBlocksEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(AppImages.logo),
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<BlockListBloc, BlockListState>(
            builder: (context, state) {
              if (state is BlockListLoaded) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    push(MaterialPageRoute route) async {
                      Navigator.push(context, route);
                    }

                    final result = await showSearch<String?>(
                      context: context,
                      delegate: BlockListSearchDelegate(blocks: state.blocks),
                    );
                    if (result == null) return;
                    push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BlockDetailsScreen(blockNumber: result),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<BlockListBloc, BlockListState>(
        builder: (context, state) {
          if (state is BlockListLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is BlockListFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BlockListBloc>().add(
                        const GetLatestBlocksEvent(),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is BlockListLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.blocks.length,
              itemBuilder: (BuildContext context, int index) {
                final block = state.blocks[index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => BlockDetailsScreen(
                              blockNumber: block.blockNumber.toString(),
                            ),
                      ),
                    );
                  },
                  child: BlockListTile(block: block, index: index),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
