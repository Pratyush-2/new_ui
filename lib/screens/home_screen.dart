import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/log_food_screen.dart';
import '../widgets/macro_summary.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MacroSummary(title: 'Calories', currentValue: 1450, goalValue: 2000, color: Colors.blue),
                    SizedBox(width: 8),
                    MacroSummary(title: 'Protein', currentValue: 60, goalValue: 150, color: Colors.red),
                    SizedBox(width: 8),
                    MacroSummary(title: 'Carbs', currentValue: 180, goalValue: 300, color: Colors.green),
                    SizedBox(width: 8),
                    MacroSummary(title: 'Fats', currentValue: 50, goalValue: 70, color: Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Recent meals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 72),
                  children: const [
                    MealCard(title: 'Oats with banana', kcal: 350, time: '08:30 AM'),
                    MealCard(title: 'Chicken salad', kcal: 520, time: '01:15 PM'),
                    MealCard(title: 'Apple', kcal: 80, time: '04:00 PM'),
                  ],
                ),
              ),
            ],
          ),
        ),
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