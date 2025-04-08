import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/generated/l10n.dart';
import 'package:spacex_bloc/screens/spacex_home.dart';

class MockSpacexBloc extends MockBloc<SpacexEvent, SpacexState>
    implements SpacexBloc {}

void main() {
  setUpAll(() async {
    await loadAppFonts(); // จาก golden_toolkit
  });

  testGoldens('SpacexHome golden test with MockBloc', (
    WidgetTester tester,
  ) async {
    final mockBloc = MockSpacexBloc();

    whenListen(
      mockBloc,
      Stream.fromIterable([
        SpacexFetchingSuccessfulState(
          spacexLists: [
            // ใส่ข้อมูลจำลองเพื่อให้ golden UI แสดงผลลัพธ์
            // SpacexEntity(
            //   id: "1",
            //   name: "Falcon 9",
            //   dateUtc: "2023-06-10T12:00:00Z",
            //   details: "A reusable rocket by SpaceX.",
            //   rocket: "Falcon 9",
            //   launchpad: "LC-39A",
            //   smallimage: "https://images2.imgbox.com/73/7f/u7BKqv2C_o.png",
            //   largeimage: "https://images2.imgbox.com/73/7f/u7BKqv2C_o.png",
            //   success: true,
            // ),
          ],
        ),
      ]),
      initialState: SpacexInitial(),
    );

    await tester.pumpWidgetBuilder(
      BlocProvider<SpacexBloc>.value(
        value: mockBloc,
        child: const SpacexHome(),
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

    await screenMatchesGolden(tester, 'spacex_home_mock_bloc');
    // ชื่อไฟล์ที่ต้องการบันทึกภาพ
    await tester.pumpAndSettle(); // รอให้ UI อัปเดต
    await tester.pump(const Duration(seconds: 1)); // รอให้ UI อัปเดต
  });
}
