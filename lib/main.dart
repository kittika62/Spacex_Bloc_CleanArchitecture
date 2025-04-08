import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spacex_bloc/di/injection_container.dart' as di;

import 'features/spacex/bloc/spacex_bloc.dart';
import 'generated/l10n.dart';
import 'screens/spacex_home.dart';

void main() {
  di.init(); // เรียกใช้ฟังก์ชัน init() เพื่อทำการลงทะเบียน dependencies
  runApp(
    MultiBlocProvider(
      providers: [
        // ใช้ GetIt เพื่อดึง SpacexBloc จาก DI
        BlocProvider(
          create: (context) => di.sl<SpacexBloc>()..add(SpacexFetchEvent()),
        ),
        // ใช้ GetIt เพื่อดึง LocalizationBloc จาก DI
        BlocProvider(create: (context) => di.sl<LocalizationBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: state.locale,
          home: const SpacexHome(),
        );
      },
    );
  }
}
