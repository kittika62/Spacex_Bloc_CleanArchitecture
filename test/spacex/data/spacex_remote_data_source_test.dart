import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spacex_bloc/features/spacex/data/datasource.dart';
import 'package:spacex_bloc/features/spacex/data/model.dart';

import 'spacex_remote_data_source_test.mocks.dart'; // import mock ที่ generate

@GenerateMocks([http.Client]) // สร้าง mock class
void main() {
  late SpacexRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = SpacexRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getSpacexLaunches', () {
    final List<Map<String, dynamic>> mockResponseData = [
      {"id": "1", "name": "Falcon 9", "date_utc": "2024-03-01T12:00:00.000Z"},
    ];

    test(
      'ควรคืนค่าเป็น List ของ SpacexModel เมื่อ response มีสถานะ 200',
      () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponseData), 200),
        );

        final result = await dataSource.getSpacexLaunches();

        expect(result, isA<List<SpacexModel>>());
        expect(result.first.name, "Falcon 9");
      },
    );

    test('ควรเกิด Exception เมื่อ response ไม่ใช่ 200', () async {
      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('Error', 404));

      expect(() => dataSource.getSpacexLaunches(), throwsException);
    });
  });
}
