import 'package:flutter/material.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(actions: [ThemeSwitch()]));
  }
}
