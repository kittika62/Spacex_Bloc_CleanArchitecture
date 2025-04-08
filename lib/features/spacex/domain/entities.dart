import 'package:equatable/equatable.dart';

class SpacexEntity extends Equatable {
  final String id;
  final String name;
  final String dateUtc;
  final String details;
  final String rocket;
  final String launchpad;
  final String smallimage;
  final String largeimage;
  final bool success;

  const SpacexEntity({
    required this.id,
    required this.name,
    required this.dateUtc,
    required this.details,
    required this.rocket,
    required this.launchpad,
    required this.smallimage,
    required this.largeimage,
    required this.success,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    dateUtc,
    details,
    rocket,
    launchpad,
    smallimage,
    largeimage,
    success,
  ];
}
