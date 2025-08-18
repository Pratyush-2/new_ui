import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/log_food_screen.dart';
import 'package:nutrition_app/widgets/calorie_progress_card.dart';
import 'package:nutrition_app/widgets/macro_progress.dart';
import '../widgets/meal_card.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(today);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, John!', // Replace with actual user name
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: CalorieProgressCard(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  MacroProgress(
                    title: 'Protein',
                    currentValue: 60,
                    goalValue: 150,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  MacroProgress(
                    title: 'Carbs',
                    currentValue: 180,
                    goalValue: 300,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  MacroProgress(
                    title: 'Fats',
                    currentValue: 50,
                    goalValue: 70,
                    color: theme.colorScheme.tertiary,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent meals', style: theme.textTheme.headlineSmall),
                  TextButton(
                    onPressed: () {
                      // Navigate to history screen
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              const [
                MealCard(
                  title: 'Oats with banana',
                  kcal: 350,
                  time: '08:30 AM',
                  icon: Icons.breakfast_dining,
                ),
                MealCard(
                  title: 'Chicken salad',
                  kcal: 520,
                  time: '01:15 PM',
                  icon: Icons.lunch_dining,
                ),
                MealCard(
                  title: 'Apple',
                  kcal: 80,
                  time: '04:00 PM',
                  icon: Icons.fastfood,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LogFoodScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
