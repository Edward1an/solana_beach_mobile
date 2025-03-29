import 'package:flutter/material.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';

class BlockListSearchDelegate extends SearchDelegate<String?> {
  final List<Block> blocks;

  BlockListSearchDelegate({
    required this.blocks,
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction,
    super.autocorrect,
    super.enableSuggestions,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matches = [];
    for (var block in blocks) {
      if (block.blockNumber.toString().contains(query)) {
        matches.add(block.blockNumber.toString());
      }
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return ListTile(
          title: Text(match),
          onTap: () {
            close(context, match);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matches = [];
    for (var block in blocks) {
      if (block.blockNumber.toString().contains(query)) {
        matches.add(block.blockNumber.toString());
      }
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return ListTile(
          onTap: () {
            close(context, match);
          },
          title: Text('Block №$match'),
        );
      },
    );
  }
}
