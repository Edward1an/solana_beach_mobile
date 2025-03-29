import 'dart:convert';

import 'package:http/http.dart';
import 'package:solana_beach/config/constants/app_urls.dart';
import 'package:solana_beach/core/datasource/data_state.dart';
import 'package:solana_beach/features/dashboard/data/mappers/block_mapper.dart';
import 'package:solana_beach/features/dashboard/data/models/block_model.dart';
import 'package:solana_beach/features/dashboard/domain/entities/block.dart';
import 'package:solana_beach/features/dashboard/domain/repositories/block_repository.dart';

class BlockRepositoryImpl implements BlockRepository {
  final Client client;

  const BlockRepositoryImpl({required this.client});

  static const String _baseUrl = AppUrls.BASE_URL;
  static const String _apiKey = String.fromEnvironment("API_KEY");
  static const Map<String, String> _requestHeaders = {
    "Accept": "application/json",
    "Authorization": " Bearer $_apiKey",
  };

  @override
  Future<DataState<List<Block>>> getLatestBlocks() async {
    try {
      final Uri url = Uri.parse(
        "$_baseUrl/latest-blocks",
      ).replace(queryParameters: {"limit": "50"});
      final response = await client.get(url, headers: _requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return DataSuccess<List<Block>>(
          BlockModel.fromJsonList(
            data,
          ).map((e) => BlockMapper.toEntity(e)).toList(),
        );
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        return DataFailure(error['err'] ?? 'Unknown error');
      }
    } catch (e) {
      return DataFailure(e.toString());
    }
  }

  @override
  Future<DataState<Block>> getBlockByNumber(String number) async {
    try {
      final Uri url = Uri.parse("$_baseUrl/block/$number");
      final response = await client.get(url, headers: _requestHeaders);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return DataSuccess<Block>(
          BlockMapper.toEntity(BlockModel.fromJson(data)),
        );
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        return DataFailure(error['err'] ?? 'Unknown error');
      }
    } catch (e) {
      return DataFailure(e.toString());
    }
  }
}
