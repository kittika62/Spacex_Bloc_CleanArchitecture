// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'spacex_bloc.dart';

@immutable
abstract class SpacexState {}

abstract class SpacexActionState extends SpacexState {}

class SpacexInitial extends SpacexState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpacexInitial;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class SpacexFetchingLoadingState extends SpacexState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SpacexFetchingFailedState extends SpacexState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SpacexFetchingSuccessfulState extends SpacexState with EquatableMixin {
  final List<SpacexEntity> spacexLists;

  SpacexFetchingSuccessfulState({required this.spacexLists});

  @override
  List<Object?> get props => [spacexLists];
}

class LocalizationState extends Equatable {
  final Locale locale;
  const LocalizationState(this.locale);

  factory LocalizationState.initial() {
    return const LocalizationState(Locale('en'));
  }

  LocalizationState copyWith(Locale? locale) {
    return LocalizationState(locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
