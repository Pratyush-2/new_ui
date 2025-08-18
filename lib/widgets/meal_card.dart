import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String title;
  final int kcal;
  final String time;
  final IconData icon;

  const MealCard({
    super.key,
    required this.title,
    required this.kcal,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(title, style: theme.textTheme.titleMedium),
          subtitle: Text('$kcal kcal  •  $time', style: theme.textTheme.bodyMedium),
          trailing: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}