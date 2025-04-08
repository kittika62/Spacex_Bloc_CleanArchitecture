import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:spacex_bloc/features/spacex/data/datasource.dart';
import 'package:spacex_bloc/features/spacex/data/model.dart';
import 'package:spacex_bloc/features/spacex/data/repositories_impl.dart';

import 'spacex_repository_impl_test.mocks.dart';

@GenerateMocks([SpacexRemoteDataSource])
void main() {
  late SpacexRepositoryImpl repository;
  late MockSpacexRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSpacexRemoteDataSource();
    repository = SpacexRepositoryImpl(remoteDataSource: mockRemoteDataSource);

    // กำหนดค่าเริ่มต้นให้ Mock เพื่อป้องกันค่า Null
    when(mockRemoteDataSource.getSpacexLaunches()).thenAnswer((_) async => []);
  });

  group('fetchSpacex', () {
    final spacexModelList = [
      SpacexModel(
        id: "1",
        name: "Falcon 9",
        dateUtc: "2023-01-01T00:00:00Z",
        details: "Test launch",
        rocket: "Falcon 9",
        launchpad: "LC-39A",
        smallimage: "https://example.com/small.jpg",
        largeimage: "https://example.com/large.jpg",
        success: true,
      ),
    ];

    test('ควรคืนค่า List<SpacexEntity> เมื่อ DataSource ทำงานปกติ', () async {
      // Arrange (Mock ให้คืนค่าปกติ)
      when(
        mockRemoteDataSource.getSpacexLaunches(),
      ).thenAnswer((_) async => spacexModelList);

      // Act
      final result = await repository.fetchSpacex();

      // Assert
      expect(result, isA<Right>());
      expect(result.getOrElse(() => []), isNotEmpty);
      verify(mockRemoteDataSource.getSpacexLaunches()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('ควรคืน Left(Exception) เมื่อ DataSource โยน Exception', () async {
      // Arrange (Mock ให้เกิดข้อผิดพลาด)
      when(
        mockRemoteDataSource.getSpacexLaunches(),
      ).thenThrow(Exception('Network Error'));

      // Act
      final result = await repository.fetchSpacex();

      // Assert
      expect(result, isA<Left>());
      expect(result.fold((l) => l, (r) => null), isA<Exception>());
      verify(mockRemoteDataSource.getSpacexLaunches()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
