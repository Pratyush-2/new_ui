import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/log_food_screen.dart';
import 'package:nutrition_app/widgets/calorie_progress_card.dart';
import 'package:nutrition_app/widgets/macro_progress.dart';
import '../widgets/meal_card.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:nutrition_app/services/api_client.dart'; // Import ApiService
import 'dart:developer' as developer;
import 'package:nutrition_app/models/log.dart';
import 'package:nutrition_app/models/goal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _getHomeData();
  }

  Future<Map<String, dynamic>> _getHomeData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final results = await Future.wait([
        apiService.getTotals(today),
        apiService.getAllGoals(),
        apiService.getLogs(today),
        apiService.getProfileById(1), // Assuming user_id 1
      ]);
      developer.log('Totals: ${results[0]}', name: 'HomeScreen');
      developer.log('Goals: ${results[1]}', name: 'HomeScreen');
      developer.log('Logs: ${results[2]}', name: 'HomeScreen');
      developer.log('Profile: ${results[3]}', name: 'HomeScreen');
      return {
        'totals': results[0],
        'goals': results[1],
        'logs': results[2],
        'profile': results[3],
      };
    } catch (e) {
      developer.log('Error fetching home screen data: $e', name: 'HomeScreen');
      rethrow; // Rethrow to be caught by FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(today);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final homeData = snapshot.data!;
            final totals = homeData['totals'] as Map<String, dynamic>;
            final goals = homeData['goals'] as List<Goal>;
            final logs = homeData['logs'] as List<DailyLogModel>;
            final profile = homeData['profile'] as Map<String, dynamic>;
            final goal = goals.isNotEmpty ? goals.first : null;

            return CustomScrollView(
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
                          'Good morning, ${profile['name'] ?? 'User'}!',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(178),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: CalorieProgressCard(
                      caloriesConsumed: (totals['calories'] as num?)?.toDouble() ?? 0.0,
                      caloriesGoal: goal?.caloriesGoal ?? 2000.0,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: goal != null
                        ? Column(
                            children: [
                              MacroProgress(
                                title: 'Protein',
                                currentValue: (totals['protein'] as num?)?.toDouble() ?? 0.0,
                                goalValue: goal.proteinGoal,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              MacroProgress(
                                title: 'Carbs',
                                currentValue: (totals['carbs'] as num?)?.toDouble() ?? 0.0,
                                goalValue: goal.carbsGoal,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(height: 16),
                              MacroProgress(
                                title: 'Fats',
                                currentValue: (totals['fats'] as num?)?.toDouble() ?? 0.0,
                                goalValue: goal.fatsGoal,
                                color: theme.colorScheme.tertiary,
                              ),
                            ],
                          )
                        : _buildMacroProgressPlaceholders(theme),
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
                if (logs.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final log = logs[index];
                        final food = log.food;
                        if (food == null) return const SizedBox.shrink();
                        return MealCard(
                          title: food.name,
                          kcal: food.calories.toInt(),
                          time: DateFormat('yyyy-MM-dd').format(log.date),
                          icon: Icons.fastfood,
                        );
                      },
                      childCount: logs.length,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text('No meals logged for today.'),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LogFoodScreen(),
            ),
          ).then((_) => setState(() {
            _homeDataFuture = _getHomeData();
          })); // Refetch data when returning to the screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMacroProgressPlaceholders(ThemeData theme) {
    return Column(
      children: [
        MacroProgress(
          title: 'Protein',
          currentValue: 0,
          goalValue: 0,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        MacroProgress(
          title: 'Carbs',
          currentValue: 0,
          goalValue: 0,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(height: 16),
        MacroProgress(
          title: 'Fats',
          currentValue: 0,
          goalValue: 0,
          color: theme.colorScheme.tertiary,
        ),
      ],
    );
  }
}
