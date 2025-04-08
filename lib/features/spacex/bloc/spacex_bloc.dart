import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacex_bloc/features/spacex/domain/entities.dart';
import 'package:spacex_bloc/features/spacex/domain/usecases.dart';

part 'spacex_event.dart';
part 'spacex_state.dart';

class SpacexBloc extends Bloc<SpacexEvent, SpacexState> {
  final FetchSpacexUseCase fetchSpacexUseCase;
  final SearchSpacexUseCase searchSpacexUseCase;
  final SortSpacexUseCase sortSpacexUseCase;

  List<SpacexEntity> allLaunches = [];

  SpacexBloc({
    required this.fetchSpacexUseCase,
    required this.searchSpacexUseCase,
    required this.sortSpacexUseCase,
  }) : super(SpacexInitial()) {
    on<SpacexFetchEvent>(spacexFetchEvent);
    on<SpacexSearchEvent>(spacexSearchEvent);
  }

  FutureOr<void> spacexFetchEvent(
    SpacexFetchEvent event,
    Emitter<SpacexState> emit,
  ) async {
    emit(SpacexFetchingLoadingState());
    print('Fetching data...');
    final result =
        await fetchSpacexUseCase
            .call(); // ใช้ fetchSpacexUseCase ที่ส่งมาจาก constructor
    print('Fetch result: $result');

    result.fold((failure) => emit(SpacexFetchingFailedState()), (spacexLists) {
      allLaunches = spacexLists; // เก็บข้อมูลลงใน allLaunches
      sortSpacexUseCase.call(allLaunches); //เรียก usecase sort มาใข้
      print('Sorting completed');
      emit(SpacexFetchingSuccessfulState(spacexLists: spacexLists));
    });
  }

  FutureOr<void> spacexSearchEvent(
    SpacexSearchEvent event,
    Emitter<SpacexState> emit,
  ) async {
    if (allLaunches.isEmpty) return; // หยุดการทำงานหากไม่มีข้อมูล

    // ใช้ searchSpacexUseCase ที่ได้รับจาก constructor
    final searchResult = searchSpacexUseCase.call(allLaunches, event.search);

    if (searchResult.isEmpty) {
      emit(SpacexFetchingFailedState()); // ไม่มีผลลัพธ์
      return;
    }
    emit(
      SpacexFetchingSuccessfulState(spacexLists: searchResult),
    ); // ส่งผลลัพธ์ที่ค้นพบ
  }
}

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationState.initial()) {
    on<LoadSavedLocalization>(getLanguage);
    on<LoadLocalization>(changeLanguage);
  }

  void changeLanguage(LoadLocalization event, Emitter<LocalizationState> emit) {
    if (event.locale == state.locale) return;
    saveLocale(event.locale);
    emit(LocalizationState(event.locale));
  }

  Future<void> getLanguage(
    LoadSavedLocalization event,
    Emitter<LocalizationState> emit,
  ) async {
    Locale saveLocale = await getLocale();
    emit(LocalizationState(saveLocale));
  }

  Future<void> saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
  }

  Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language') ?? 'en';
    print(languageCode);
    return Locale(languageCode);
  }
}
