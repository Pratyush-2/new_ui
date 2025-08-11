import 'package:flutter/material.dart';
import '../../main.dart' as app_main;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = app_main.themeNotifier.value == ThemeMode.dark;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Your Name'),
              subtitle: const Text('Daily goal: 2000 kcal'),
              onTap: () {},
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme (Light / Dark)'),
              trailing: Switch(
                value: isDark,
                onChanged: (v) {
                  app_main.themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}