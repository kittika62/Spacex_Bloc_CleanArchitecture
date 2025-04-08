import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart';

/// Mock Classes
class MockFetchSpacexUseCase extends Mock implements FetchSpacexUseCase {}

class MockSearchSpacexUseCase extends Mock implements SearchSpacexUseCase {}

class MockSortSpacexUseCase extends Mock implements SortSpacexUseCase {}

void main() {
  late SpacexBloc spacexBloc;
  late MockFetchSpacexUseCase mockFetchSpacexUseCase;
  late MockSearchSpacexUseCase mockSearchSpacexUseCase;
  late MockSortSpacexUseCase mockSortSpacexUseCase;

  setUp(() {
    mockFetchSpacexUseCase = MockFetchSpacexUseCase();
    mockSearchSpacexUseCase = MockSearchSpacexUseCase();
    mockSortSpacexUseCase = MockSortSpacexUseCase();

    spacexBloc = SpacexBloc(
      fetchSpacexUseCase: mockFetchSpacexUseCase,
      searchSpacexUseCase: mockSearchSpacexUseCase,
      sortSpacexUseCase: mockSortSpacexUseCase,
    );
  });

  tearDown(() {
    spacexBloc.close();
  });

  test('initial state should be SpacexInitial', () {
    expect(spacexBloc.state, equals(SpacexInitial()));
  });

  blocTest<SpacexBloc, SpacexState>(
    'emits [SpacexFetchingLoadingState, SpacexFetchingSuccessfulState] when data is fetched successfully',
    build: () {
      when(() => mockFetchSpacexUseCase.call()).thenAnswer(
        (_) async => Right([
          SpacexEntity(
            name: 'Falcon 9',
            id: '1',
            dateUtc: '2023-01-01T00:00:00Z',
            details: 'First Falcon 9 launch',
            rocket: 'Falcon 9',
            launchpad: 'LC-39A',
            smallimage: 'https://example.com/small.jpg',
            largeimage: 'https://example.com/large.jpg',
            success: true,
          ),
        ]),
      );

      when(() => mockSortSpacexUseCase.call(any())).thenReturn([]); // Mock sort

      return SpacexBloc(
        fetchSpacexUseCase: mockFetchSpacexUseCase,
        searchSpacexUseCase: mockSearchSpacexUseCase,
        sortSpacexUseCase: mockSortSpacexUseCase,
      );
    },
    act: (bloc) => bloc.add(SpacexFetchEvent()),
    expect:
        () => [
          SpacexFetchingLoadingState(),
          SpacexFetchingSuccessfulState(
            spacexLists: [
              SpacexEntity(
                name: 'Falcon 9',
                id: '1',
                dateUtc: '2023-01-01T00:00:00Z',
                details: 'First Falcon 9 launch',
                rocket: 'Falcon 9',
                launchpad: 'LC-39A',
                smallimage: 'https://example.com/small.jpg',
                largeimage: 'https://example.com/large.jpg',
                success: true,
              ),
            ],
          ),
        ],
  );

  blocTest<SpacexBloc, SpacexState>(
    'emits [SpacexFetchingLoadingState, SpacexFetchingFailedState] when data fetch fails',
    build: () {
      when(() => mockFetchSpacexUseCase.call()).thenAnswer(
        (_) async =>
            Left(Exception('โหลดข้อมูลล้มเหลว')), // Simulating a failure
      );
      return SpacexBloc(
        fetchSpacexUseCase: mockFetchSpacexUseCase,
        searchSpacexUseCase: mockSearchSpacexUseCase,
        sortSpacexUseCase: mockSortSpacexUseCase,
      );
    },
    act: (bloc) => bloc.add(SpacexFetchEvent()),
    expect: () => [SpacexFetchingLoadingState(), SpacexFetchingFailedState()],
  );

  blocTest<SpacexBloc, SpacexState>(
    'emits [SpacexFetchingSuccessfulState] when searching by name and a match is found',
    build: () {
      when(() => mockSearchSpacexUseCase.call(any(), any())).thenAnswer((
        invocation,
      ) {
        final List<SpacexEntity> launches = invocation.positionalArguments[0];
        final String searchQuery = invocation.positionalArguments[1];

        // ค้นหาจาก name เท่านั้น
        return launches
            .where(
              (launch) =>
                  launch.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      });

      return SpacexBloc(
          fetchSpacexUseCase: mockFetchSpacexUseCase,
          searchSpacexUseCase: mockSearchSpacexUseCase,
          sortSpacexUseCase: mockSortSpacexUseCase,
        )
        ..allLaunches = [
          SpacexEntity(
            name: 'Falcon 9',
            id: '1',
            dateUtc: '2023-01-01T00:00:00Z',
            details: 'First Falcon 9 launch',
            rocket: 'Falcon 9',
            launchpad: 'LC-39A',
            smallimage: 'https://example.com/small.jpg',
            largeimage: 'https://example.com/large.jpg',
            success: true,
          ),
          SpacexEntity(
            name: 'Starship',
            id: '2',
            dateUtc: '2023-02-01T00:00:00Z',
            details: 'First Starship launch',
            rocket: 'Starship',
            launchpad: 'Boca Chica',
            smallimage: 'https://example.com/starship_small.jpg',
            largeimage: 'https://example.com/starship_large.jpg',
            success: false,
          ),
        ];
    },
    act: (bloc) => bloc.add(SpacexSearchEvent(search: 'Falcon')),
    expect:
        () => [
          SpacexFetchingSuccessfulState(
            spacexLists: [
              SpacexEntity(
                name: 'Falcon 9',
                id: '1',
                dateUtc: '2023-01-01T00:00:00Z',
                details: 'First Falcon 9 launch',
                rocket: 'Falcon 9',
                launchpad: 'LC-39A',
                smallimage: 'https://example.com/small.jpg',
                largeimage: 'https://example.com/large.jpg',
                success: true,
              ),
            ],
          ),
        ],
  );

  blocTest<SpacexBloc, SpacexState>(
    'does nothing when allLaunches is empty',
    build: () {
      return SpacexBloc(
        fetchSpacexUseCase: mockFetchSpacexUseCase,
        searchSpacexUseCase: mockSearchSpacexUseCase,
        sortSpacexUseCase: mockSortSpacexUseCase,
      )..allLaunches = []; // allLaunches ว่าง
    },
    act: (bloc) => bloc.add(SpacexSearchEvent(search: 'Falcon')),
    expect: () => [], // ไม่ emit อะไรเลย
  );

  blocTest<SpacexBloc, SpacexState>(
    'emits [SpacexFetchingFailedState] when searching by name and no match is found',
    build: () {
      when(() => mockSearchSpacexUseCase.call(any(), any())).thenAnswer((
        invocation,
      ) {
        final List<SpacexEntity> launches = invocation.positionalArguments[0];
        final String searchQuery = invocation.positionalArguments[1];

        // ค้นหาจาก name เท่านั้น
        return launches
            .where((launch) => launch.name.contains(searchQuery))
            .toList();
      });

      return SpacexBloc(
          fetchSpacexUseCase: mockFetchSpacexUseCase,
          searchSpacexUseCase: mockSearchSpacexUseCase,
          sortSpacexUseCase: mockSortSpacexUseCase,
        )
        ..allLaunches = [
          SpacexEntity(
            name: 'Falcon 9',
            id: '1',
            dateUtc: '2023-01-01T00:00:00Z',
            details: 'First Falcon 9 launch',
            rocket: 'Falcon 9',
            launchpad: 'LC-39A',
            smallimage: 'https://example.com/small.jpg',
            largeimage: 'https://example.com/large.jpg',
            success: true,
          ),
        ];
    },
    act: (bloc) => bloc.add(SpacexSearchEvent(search: 'Starship')),
    expect: () => [SpacexFetchingFailedState()],
  );
}
