import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String title;
  final int kcal;
  final String time;
  const MealCard({super.key, required this.title, required this.kcal, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('$kcal kcal  •  $time', style: const TextStyle(color: Colors.grey)),
          trailing: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}