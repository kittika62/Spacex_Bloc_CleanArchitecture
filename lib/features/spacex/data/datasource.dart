import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacex_bloc/features/spacex/data/model.dart';

// SpacexRemoteDataSource Interface (datasource.dart)
abstract class SpacexRemoteDataSource {
  Future<List<SpacexModel>> getSpacexLaunches();
}

class SpacexRemoteDataSourceImpl implements SpacexRemoteDataSource {
  final http.Client client;

  SpacexRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SpacexModel>> getSpacexLaunches() async {
    final response = await client.get(
      Uri.parse('https://api.spacexdata.com/v5/launches'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((e) => SpacexModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load SpaceX data');
    }
  }
}
