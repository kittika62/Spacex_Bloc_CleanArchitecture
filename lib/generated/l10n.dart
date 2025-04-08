// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `SpaceX`
  String get app_title {
    return Intl.message(
      'SpaceX',
      name: 'app_title',
      desc: 'Title of the app',
      args: [],
    );
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: 'language',
      args: [],
    );
  }

  /// `Search...`
  String get search_hint {
    return Intl.message(
      'Search...',
      name: 'search_hint',
      desc: 'Hint text for the search bar',
      args: [],
    );
  }

  /// `Success`
  String get launch_success {
    return Intl.message(
      'Success',
      name: 'launch_success',
      desc: 'Text displayed when the launch is successful',
      args: [],
    );
  }

  /// `Failure`
  String get launch_failure {
    return Intl.message(
      'Failure',
      name: 'launch_failure',
      desc: 'Text displayed when the launch fails',
      args: [],
    );
  }

  /// `Error No Data`
  String get error_no_data {
    return Intl.message(
      'Error No Data',
      name: 'error_no_data',
      desc: 'Displayed when no data is available',
      args: [],
    );
  }

  /// `Details: {details}`
  String details(Object details) {
    return Intl.message(
      'Details: $details',
      name: 'details',
      desc: 'Label for details of the launch',
      args: [details],
    );
  }

  /// `Rocket: {rocket}`
  String rocket(Object rocket) {
    return Intl.message(
      'Rocket: $rocket',
      name: 'rocket',
      desc: 'Label for the rocket used in the launch',
      args: [rocket],
    );
  }

  /// `Launchpad: {launchpad}`
  String launchpad(Object launchpad) {
    return Intl.message(
      'Launchpad: $launchpad',
      name: 'launchpad',
      desc: 'Label for the launchpad',
      args: [launchpad],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: 'Button label for closing dialogs',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'th'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
