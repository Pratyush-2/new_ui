class Food {
  final int id;
  final String name;
  final String? barcode;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final String? servingSize;

  Food({
    required this.id,
    required this.name,
    this.barcode,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.servingSize,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as int,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      servingSize: json['serving_size'] as String?,
    );
  }

  factory Food.fromOpenFoodFacts(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] as Map<String, dynamic>? ?? {};
    return Food(
      id: 0, // Will be assigned by the backend
      name: json['product_name'] as String? ?? 'Unknown Food',
      barcode: json['code'] as String?,
      calories: (nutriments['energy-kcal_100g'] as num?)?.toDouble() ?? 0.0,
      protein: (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0.0,
      carbs: (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0,
      fats: (nutriments['fat_100g'] as num?)?.toDouble() ?? 0.0,
      servingSize: json['serving_size'] as String? ?? '100g',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'serving_size': servingSize,
    };
  }
}


