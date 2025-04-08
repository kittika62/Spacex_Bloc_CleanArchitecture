part of 'spacex_bloc.dart';

@immutable
sealed class SpacexEvent {}

class SpacexFetchEvent extends SpacexEvent {}

class SpacexSearchEvent extends SpacexEvent {
  final String search;
  SpacexSearchEvent({required this.search});
}

sealed class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LoadLocalization extends LocalizationEvent {
  final Locale locale;
  const LoadLocalization(this.locale);

  @override
  List<Object> get props => [locale];
}

class LoadSavedLocalization extends LocalizationEvent {}
