import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/screens/language_screen.dart';
import 'package:spacex_bloc/generated/l10n.dart';

class MockLocalizationBloc
    extends MockBloc<LocalizationEvent, LocalizationState>
    implements LocalizationBloc {}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('LanguageScreen golden test', (tester) async {
    final mockBloc = MockLocalizationBloc();

    whenListen(
      mockBloc,
      Stream.fromIterable([
        LocalizationState(const Locale('th')), // สมมุติว่าใช้ภาษาไทย
      ]),
      initialState: const LocalizationState(Locale('th')),
    );

    await tester.pumpWidgetBuilder(
      BlocProvider<LocalizationBloc>.value(
        value: mockBloc,
        child: const LanguageScreen(),
      ),
      wrapper:
          (child) => MaterialApp(
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: child,
          ),
    );

    await screenMatchesGolden(tester, 'language_screen_golden');
  });
}
