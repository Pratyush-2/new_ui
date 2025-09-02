import 'package:flutter/material.dart';
import 'package:nutrition_app/services/api_client.dart';
import 'package:nutrition_app/models/profile.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<UserProfileModel>> _profilesFuture;
  late Future<List<dynamic>> _userGoalsFuture;
  UserProfileModel? _currentProfile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _profilesFuture = apiService.getProfiles();
    _userGoalsFuture = apiService.getAllGoals();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onEditProfile(UserProfileModel initial) async {
    final nameCtrl = TextEditingController(text: initial.name);
    final ageCtrl = TextEditingController(text: initial.age.toString());
    final heightCtrl = TextEditingController(text: initial.heightCm.toString());
    final weightCtrl = TextEditingController(text: initial.weightKg.toString());
    final genderCtrl = TextEditingController(text: initial.gender);
    final activityCtrl = TextEditingController(text: initial.activityLevel);
    final goalCtrl = TextEditingController(text: initial.goal ?? '');

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
                TextField(controller: heightCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Height (cm)')),
                TextField(controller: weightCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight (kg)')),
                TextField(controller: genderCtrl, decoration: const InputDecoration(labelText: 'Gender')),
                TextField(controller: activityCtrl, decoration: const InputDecoration(labelText: 'Activity Level')),
                TextField(controller: goalCtrl, decoration: const InputDecoration(labelText: 'Goal')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                setState(() => _saving = true);
                try {
                  final updatedModel = UserProfileModel(
                    id: initial.id,
                    name: nameCtrl.text,
                    age: double.tryParse(ageCtrl.text) ?? initial.age,
                    heightCm: double.tryParse(heightCtrl.text) ?? initial.heightCm,
                    weightKg: double.tryParse(weightCtrl.text) ?? initial.weightKg,
                    gender: genderCtrl.text,
                    activityLevel: activityCtrl.text,
                    goal: goalCtrl.text,
                  );
                  final updated = await apiService.updateProfile(updatedModel.toJson());
                  developer.log('Profile updated: $updated');
                  _showSnack('Profile saved');
                  setState(() {
                    _currentProfile = updatedModel;
                    _fetchData();
                  });
                  if (mounted) Navigator.of(ctx).pop();
                } catch (e) {
                  developer.log('Update profile error: $e');
                  _showSnack('Failed to save profile');
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
              child: _saving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_profilesFuture, _userGoalsFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading profile"));
          } else if (snapshot.hasData) {
            final profiles = snapshot.data![0] as List<UserProfileModel>;
            final userGoals = snapshot.data![1] as List<dynamic>;

            final userProfile = (profiles.isNotEmpty ? profiles.first : null);
            _currentProfile ??= userProfile;

            // Assuming there's at least one goal, or handle empty case
            final nutritionGoals = userGoals.isNotEmpty ? userGoals[0] : {};

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Personal Info", theme),
                  _buildInfoTile("Name", (userProfile?.name ?? 'N/A'), theme),
                  _buildInfoTile("Age", (userProfile?.age.toString() ?? ''), theme),
                  _buildInfoTile("Height", (userProfile?.heightCm.toString() ?? ''), theme),
                  _buildInfoTile("Weight", (userProfile?.weightKg.toString() ?? ''), theme),
                  _buildInfoTile("Gender", (userProfile?.gender ?? 'N/A'), theme),
                  _buildInfoTile("Activity Level", (userProfile?.activityLevel ?? 'N/A'), theme),
                  _buildInfoTile("Goal", (userProfile?.goal ?? 'N/A'), theme),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Daily Nutrition Goals", theme),
                  _buildNutritionCard(nutritionGoals, theme),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: userProfile == null ? null : () => _onEditProfile(userProfile),
                      child: const Text('Edit Profile'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No profile data available."));
          }
        },
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
            _buildNutritionItem("Calories", "", theme),
            _buildNutritionItem("Protein", "", theme),
            _buildNutritionItem("Fats", "", theme),
            _buildNutritionItem("Carbs", "", theme),
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