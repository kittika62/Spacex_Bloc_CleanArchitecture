import 'package:dartz/dartz.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';

abstract class SpacexRepository {
  Future<Either<Exception, List<SpacexEntity>>> fetchSpacex();
}
