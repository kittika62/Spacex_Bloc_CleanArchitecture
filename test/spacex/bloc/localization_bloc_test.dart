import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';

void main() {
  late LocalizationBloc localizationBloc;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // ใช้ Mock Storage
    localizationBloc = LocalizationBloc();
  });

  tearDown(() {
    localizationBloc.close();
  });

  test('initial state should be LocalizationState with default locale', () {
    expect(localizationBloc.state, LocalizationState(Locale('en')));
  });

  blocTest<LocalizationBloc, LocalizationState>(
    'emits new LocalizationState when LoadLocalization is added',
    build: () => localizationBloc,
    act: (bloc) => bloc.add(LoadLocalization(Locale('th'))),
    expect: () => [LocalizationState(Locale('th'))],
  );

  blocTest<LocalizationBloc, LocalizationState>(
    'loads saved language from SharedPreferences',
    build: () {
      SharedPreferences.setMockInitialValues({'language': 'th'});
      return localizationBloc;
    },
    act: (bloc) => bloc.add(LoadSavedLocalization()),
    expect: () => [LocalizationState(Locale('th'))],
  );
}
