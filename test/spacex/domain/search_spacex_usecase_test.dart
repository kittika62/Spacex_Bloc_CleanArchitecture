import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';

void main() {
  late SearchSpacexUseCase useCase;
  late List<SpacexEntity> launches;

  setUp(() {
    useCase = SearchSpacexUseCase();
    launches = [
      SpacexEntity(
        id: "1",
        name: "Falcon 9",
        dateUtc: "2023-06-10T12:00:00Z",
        details: "A reusable rocket by SpaceX.",
        rocket: "Falcon 9",
        launchpad: "LC-39A",
        smallimage: "https://example.com/falcon9_small.jpg",
        largeimage: "https://example.com/falcon9_large.jpg",
        success: true,
      ),
      SpacexEntity(
        id: "3",
        name: "Starship",
        dateUtc: "2024-03-15T14:30:00Z",
        details: "A fully reusable spacecraft by SpaceX.",
        rocket: "Starship",
        launchpad: "Starbase",
        smallimage: "https://example.com/starship_small.jpg",
        largeimage: "https://example.com/starship_large.jpg",
        success: false,
      ),
      SpacexEntity(
        id: "2",
        name: "Falcon Heavy",
        dateUtc: "2022-12-20T10:45:00Z",
        details: "A powerful rocket by SpaceX.",
        rocket: "Falcon Heavy",
        launchpad: "LC-39A",
        smallimage: "https://example.com/falconheavy_small.jpg",
        largeimage: "https://example.com/falconheavy_large.jpg",
        success: true,
      ),
    ];
  });

  test('should return matched launches when searching by name', () {
    final result = useCase(launches, "falcon");
    expect(result.length, 2);
    expect(result[0].name, "Falcon 9");
    expect(result[1].name, "Falcon Heavy");
  });

  test('should return an empty list when no matches are found', () {
    final result = useCase(launches, "saturn");
    expect(result, []);
  });

  test('should be case insensitive', () {
    final result = useCase(launches, "STARSHIP");
    expect(result.length, 1);
    expect(result[0].name, "Starship");
  });
}
