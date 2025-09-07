import 'package:flutter/material.dart';
import 'package:nutrition_app/models/profile.dart';
import 'package:nutrition_app/services/api_client.dart';
import 'dart:developer' as developer;

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _activityCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _genderCtrl.dispose();
    _activityCtrl.dispose();
    _goalCtrl.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _saving = true);
      try {
        final newProfile = {
          'name': _nameCtrl.text,
          'age': double.tryParse(_ageCtrl.text) ?? 0,
          'height_cm': double.tryParse(_heightCtrl.text) ?? 0,
          'weight_kg': double.tryParse(_weightCtrl.text) ?? 0,
          'gender': _genderCtrl.text,
          'activity_level': _activityCtrl.text,
          'goal': _goalCtrl.text,
        };
        final created = await apiService.createProfile(newProfile);
        developer.log('Profile created: $created');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile created')));
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        developer.log('Create profile error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create profile')));
        }
      } finally {
        if (mounted) {
          setState(() => _saving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _createProfile,
            icon: _saving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter an age' : null,
              ),
              TextFormField(
                controller: _heightCtrl,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a height' : null,
              ),
              TextFormField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a weight' : null,
              ),
              TextFormField(
                controller: _genderCtrl,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Please enter a gender' : null,
              ),
              TextFormField(
                controller: _activityCtrl,
                decoration: const InputDecoration(labelText: 'Activity Level'),
                validator: (value) => value!.isEmpty ? 'Please enter an activity level' : null,
              ),
              TextFormField(
                controller: _goalCtrl,
                decoration: const InputDecoration(labelText: 'Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
