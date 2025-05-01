import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/theme/theme_provider.dart';

class ToggleThemeSwitch extends StatelessWidget {
  const ToggleThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: context.read<ThemeProvider>().isLightTheme,
          onChanged: (value) {
            context.read<ThemeProvider>().toggleTheme();
          },
        ),
        Text(
          context.read<ThemeProvider>().isLightTheme ? 'Light' : 'Dark',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
