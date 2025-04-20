import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskaroo/core/theme/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

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
