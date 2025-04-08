import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_bloc/features/spacex/bloc/spacex_bloc.dart';
import 'package:spacex_bloc/features/spacex/data/model.dart';

import '../generated/l10n.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var groupValue = context.read<LocalizationBloc>().state.locale.languageCode;
    return BlocConsumer<LocalizationBloc, LocalizationState>(
      listener: (context, state) {
        groupValue = state.locale.languageCode;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(S.current.language)),
          body: ListView.builder(
            itemCount: languageModel.length,
            itemBuilder: (context, index) {
              var item = languageModel[index];
              return RadioListTile(
                value: languageModel[index].languageCode,
                groupValue: groupValue, // ค่าเริ่มต้นของกลุ่ม
                title: Text(item.language),
                subtitle: Text(item.subLanguage),
                onChanged: (value) {
                  BlocProvider.of<LocalizationBloc>(
                    context,
                  ).add(LoadLocalization(Locale(item.languageCode)));
                },
              );
            },
          ),
        );
      },
    );
  }
}
