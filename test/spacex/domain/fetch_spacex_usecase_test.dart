import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:spacex_bloc/features/spacex/domain/repositories.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';

class MockSpacexRepository extends Mock implements SpacexRepository {}

void main() {
  late FetchSpacexUseCase useCase;
  late MockSpacexRepository mockRepository;

  setUp(() {
    mockRepository = MockSpacexRepository();
    useCase = FetchSpacexUseCase(mockRepository);
  });

  test('should call fetchSpacex from repository', () async {
    // Arrange
    final List<SpacexEntity> mockLaunches = [
      SpacexEntity(
        id: "1",
        name: "Falcon 9",
        dateUtc: "2023-06-10T12:00:00Z",
        details: "First Falcon 9 launch of 2023",
        rocket: "Falcon 9",
        launchpad: "LC-39A",
        smallimage: "https://example.com/small.jpg",
        largeimage: "https://example.com/large.jpg",
        success: true,
      ),
    ];
    when(
      () => mockRepository.fetchSpacex(),
    ).thenAnswer((_) async => Right(mockLaunches));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(mockLaunches));
    verify(() => mockRepository.fetchSpacex()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
