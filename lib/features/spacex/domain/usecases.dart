import 'package:dartz/dartz.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';
import 'package:spacex_bloc/features/spacex/domain/repositories.dart';

class FetchSpacexUseCase {
  final SpacexRepository repository;

  FetchSpacexUseCase(this.repository);

  Future<Either<Exception, List<SpacexEntity>>> call() {
    return repository.fetchSpacex();
  }
}

class SearchSpacexUseCase {
  List<SpacexEntity> call(List<SpacexEntity> allLaunches, String searchQuery) {
    return allLaunches
        .where(
          (launch) =>
              launch.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }
}

class SortSpacexUseCase {
  List<SpacexEntity> call(List<SpacexEntity> launches) {
    launches.sort((a, b) {
      int nameComparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (nameComparison != 0) {
        return nameComparison;
      }
      DateTime dateA = DateTime.parse(a.dateUtc);
      DateTime dateB = DateTime.parse(b.dateUtc);
      return dateA.compareTo(dateB);
    });
    return launches;
  }
}
