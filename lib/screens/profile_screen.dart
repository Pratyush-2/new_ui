import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // Mock data for now — later this will come from backend API
  final Map<String, dynamic> userProfile = {
    "name": "John Doe",
    "age": 28,
    "height": 175, // cm
    "weight": 70, // kg
    "allergies": "Peanuts, Shellfish",
    "medical": "None",
    "goal": "Muscle Gain",
    "nutritionGoals": {
      "calories": 2400,
      "protein": 80,
      "fats": 40,
      "carbs": 150,
    },
  };

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = userProfile["nutritionGoals"];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Info", theme),
            _buildInfoTile("Name", userProfile["name"], theme),
            _buildInfoTile("Age", "${userProfile["age"]} years", theme),
            _buildInfoTile("Height", "${userProfile["height"]} cm", theme),
            _buildInfoTile("Weight", "${userProfile["weight"]} kg", theme),
            _buildInfoTile("Allergies", userProfile["allergies"], theme),
            _buildInfoTile("Medical Conditions", userProfile["medical"], theme),
            _buildInfoTile("Goal", userProfile["goal"], theme),

            const SizedBox(height: 20),
            _buildSectionTitle("Daily Nutrition Goals", theme),
            _buildNutritionCard(nutrition, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, ThemeData theme) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: theme.textTheme.titleMedium),
      subtitle: Text(value, style: theme.textTheme.bodyMedium),
    );
  }

  Widget _buildNutritionCard(Map<String, dynamic> nutrition, ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNutritionItem("Calories", "${nutrition["calories"]} kcal", theme),
            _buildNutritionItem("Protein", "${nutrition["protein"]} g", theme),
            _buildNutritionItem("Fats", "${nutrition["fats"]} g", theme),
            _buildNutritionItem("Carbs", "${nutrition["carbs"]} g", theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
