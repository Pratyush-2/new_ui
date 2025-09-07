import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_app/main.dart';
import 'package:nutrition_app/models/food.dart';
import 'dart:developer' as developer;

class LogFoodScreen extends StatefulWidget {
  const LogFoodScreen({super.key});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();

  List<Food> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      _performSearch(_searchController.text);
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });
    try {
      final results = await apiService.searchFood(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      developer.log('Error searching food: $e');
      _showSnackBar('Failed to search food: $e');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _populateFoodFields(Food food) {
    _foodNameController.text = food.name;
    _caloriesController.text = food.calories.toString();
    _proteinController.text = food.protein.toString();
    _carbsController.text = food.carbs.toString();
    _fatsController.text = food.fats.toString();
    setState(() {
      _searchResults = []; // Clear search results after selection
      _searchController.text = ''; // Clear search bar
    });
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      setState(() => _image = picked);
      // Optionally, call API to identify food from image here
      // try {
      //   final identifiedFood = await apiService.identifyFoodFromImage(_image!.path);
      //   _foodNameController.text = identifiedFood['name'] ?? '';
      //   _caloriesController.text = identifiedFood['calories']?.toString() ?? '';
      //   // ... populate other fields
      // } catch (e) {
      //   _showSnackBar('Failed to identify food: $e');
      // }
    }
  }

  Future<void> _logFood() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final food = Food(
        id: 0,
        name: _foodNameController.text,
        calories: double.tryParse(_caloriesController.text) ?? 0.0,
        protein: double.tryParse(_proteinController.text) ?? 0.0,
        carbs: double.tryParse(_carbsController.text) ?? 0.0,
        fats: double.tryParse(_fatsController.text) ?? 0.0,
      );

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final foodJson = food.toJson();
      foodJson.remove('id'); // Remove the id before sending

      final logData = {
        'food': foodJson,
        'quantity': double.tryParse(_quantityController.text) ?? 1.0,
        'date': today,
        'user_id': 1, // Assuming user_id 1 for now
      };
      await apiService.addLog(logData);

      if (mounted) {
        _showSnackBar('Food logged successfully!');
        Navigator.of(context).pop(); // Go back after successful log
      }
    } catch (e, s) {
      developer.log('Error logging food: $e');
      developer.log('Stack trace: $s');
      _showSnackBar('Failed to log food: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Food (e.g., Apple, Chicken Breast)',
                  border: OutlineInputBorder(),
                  suffixIcon: _isSearching
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.search),
                ),
              ),
              if (_searchResults.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 200), // Limit height of search results
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final food = _searchResults[index];
                      return ListTile(
                        title: Text(food.name),
                        subtitle: Text('Per ${food.servingSize ?? 'N/A'}'),
                        onTap: () => _populateFoodFields(food),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Take Photo (AI identify)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  _showSnackBar('Barcode scanning not implemented yet.');
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  _showSnackBar('Manual food search not implemented yet.');
                },
                icon: const Icon(Icons.search),
                label: const Text('Search Food Manually'),
              ),
              const SizedBox(height: 16),
              if (_image != null)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.file(
                          File(_image!.path),
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image ready to send to AI for recognition',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              const Divider(),
              const SizedBox(height: 16),
              Text('Or Log Manually', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                controller: _foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Protein (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _carbsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fats (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity (e.g., 1, 100)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: _logFood,
                      child: const Text('Log Food'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
