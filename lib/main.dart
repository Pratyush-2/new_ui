import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_tabs.dart';

// Global notifier for theme mode (simple and easy to use)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const NutritionApp());
}

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Nutrition AI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: Colors.grey[900],
          ),
          themeMode: mode,
          home: const MainTabs(),
        );
      },
    );
  }
}