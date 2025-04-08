import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';

void main() {
  late SortSpacexUseCase useCase;
  late List<SpacexEntity> launches;

  setUp(() {
    useCase = SortSpacexUseCase();
    launches = [
      SpacexEntity(
        id: "1",
        name: "Starship",
        dateUtc: "2024-03-15T14:30:00Z",
        details: "Test flight for Starship",
        rocket: "Starship Rocket",
        launchpad: "Pad 39A",
        smallimage: "https://example.com/small_starship.jpg",
        largeimage: "https://example.com/large_starship.jpg",
        success: true,
      ),
      SpacexEntity(
        id: "2",
        name: "Falcon Heavy",
        dateUtc: "2022-12-20T10:45:00Z",
        details: "Test flight for Falcon Heavy",
        rocket: "Falcon Heavy Rocket",
        launchpad: "Pad 40",
        smallimage: "https://example.com/small_falcon_heavy.jpg",
        largeimage: "https://example.com/large_falcon_heavy.jpg",
        success: true,
      ),
      SpacexEntity(
        id: "3",
        name: "Falcon 9",
        dateUtc: "2023-06-10T12:00:00Z",
        details: "Test flight for Falcon 9",
        rocket: "Falcon 9 Rocket",
        launchpad: "Pad 39B",
        smallimage: "https://example.com/small_falcon9.jpg",
        largeimage: "https://example.com/large_falcon9.jpg",
        success: true,
      ),
      SpacexEntity(
        id: "4",
        name: "Falcon 9",
        dateUtc: "2023-01-05T08:20:00Z", // ชื่อซ้ำแต่วันที่ต่างกัน
        details: "Another test flight for Falcon 9",
        rocket: "Falcon 9 Rocket",
        launchpad: "Pad 39C",
        smallimage: "https://example.com/small_falcon9_v2.jpg",
        largeimage: "https://example.com/large_falcon9_v2.jpg",
        success: false,
      ),
    ];
  });

  test('should sort by name first and then by date', () {
    final result = useCase(launches);

    expect(result[0].name, "Falcon 9");
    expect(
      result[0].dateUtc,
      "2023-01-05T08:20:00Z",
    ); // Falcon 9 ที่เก่ากว่าต้องมาก่อน
    expect(result[1].name, "Falcon 9");
    expect(result[2].name, "Falcon Heavy");
    expect(result[3].name, "Starship");
  });
}
