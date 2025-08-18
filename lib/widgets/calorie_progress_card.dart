import 'package:flutter/material.dart';

class CalorieProgressCard extends StatelessWidget {
  const CalorieProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Goal", style: theme.textTheme.titleLarge),
                const Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 0.7,
                    strokeWidth: 12,
                    backgroundColor: theme.colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "1450",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "kcal left",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMacroInfo("Carbs", "180g", "300g"),
                _buildMacroInfo("Protein", "60g", "150g"),
                _buildMacroInfo("Fat", "50g", "70g"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroInfo(String title, String value, String goal) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value),
        const SizedBox(height: 4),
        Text(goal, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
