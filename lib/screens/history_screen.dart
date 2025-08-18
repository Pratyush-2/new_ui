import 'package:flutter/material.dart';
import '../widgets/meal_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  MealCard(title: '2025-08-08 — Breakfast', kcal: 420, time: '08:10 AM', icon: Icons.breakfast_dining),
                  MealCard(title: '2025-08-08 — Lunch', kcal: 700, time: '01:05 PM', icon: Icons.lunch_dining),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}