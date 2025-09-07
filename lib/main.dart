import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_tabs.dart';
import 'services/api_service.dart';

// Global notifier for theme mode (simple and easy to use)
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

final ApiService apiService = ApiService('http://10.0.2.2:8000');

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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          themeMode: mode,
          home: const MainTabs(),
        );
      },
    );
  }
}