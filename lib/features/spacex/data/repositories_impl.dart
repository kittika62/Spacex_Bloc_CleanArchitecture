import 'package:dartz/dartz.dart';
import 'package:spacex_bloc/features/spacex/data/datasource.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';
import 'package:spacex_bloc/features/spacex/domain/repositories.dart';
import 'package:spacex_bloc/features/spacex/data/model.dart';

class SpacexRepositoryImpl implements SpacexRepository {
  final SpacexRemoteDataSource remoteDataSource;

  SpacexRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<SpacexEntity>>> fetchSpacex() async {
    try {
      final List<SpacexModel> spacexData =
          await remoteDataSource.getSpacexLaunches();

      // ✅ Convert Model → Entity
      final List<SpacexEntity> spacexEntities =
          spacexData.map((model) {
            return SpacexEntity(
              id: model.id,
              name: model.name,
              dateUtc: model.dateUtc,
              details: model.details,
              rocket: model.rocket,
              launchpad: model.launchpad,
              smallimage: model.smallimage,
              largeimage: model.largeimage,
              success: model.success,
            );
          }).toList();

      return Right(
        spacexEntities,
      ); // Return the list wrapped in Right for success
    } catch (e) {
      return Left(
        Exception("Failed to fetch SpaceX data: $e"),
      ); // Catch specific error and provide more context
    }
  }
}
