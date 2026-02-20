import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../services/storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6366F1).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        children: [
          // Practice Preferences
          Text(
            'Practice Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-enable Camera'),
                  subtitle: const Text(
                      'Automatically turn on camera when starting practice'),
                  value: settings.cameraEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings..cameraEnabled = value,
                        );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Auto-record Sessions'),
                  subtitle:
                      const Text('Automatically start recording when practicing'),
                  value: settings.autoRecord,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings..autoRecord = value,
                        );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Show Grades'),
                  subtitle: const Text(
                      'Display AI-generated performance grades after sessions'),
                  value: settings.showGrades,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).updateSettings(
                          settings..showGrades = value,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Difficulty Preference
          Text(
            'Difficulty Preference',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: [
                  'all',
                  'beginner',
                  'intermediate',
                  'advanced',
                ].map((difficulty) {
                  final isSelected = settings.preferredDifficulty == difficulty;
                  return ChoiceChip(
                    label: Text(
                      difficulty[0].toUpperCase() + difficulty.substring(1),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(settingsProvider.notifier).updateSettings(
                            settings..preferredDifficulty = difficulty,
                          );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data Management
          Text(
            'Data Management',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All your data is stored locally on your device. No data is sent to any server.',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showClearDataDialog(context, ref),
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text(
                        'Clear All Data',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ShadowSpeak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Version 1.0.0'),
                  SizedBox(height: 12),
                  Text(
                    'Master your presentation skills by shadowing the world\'s best speakers. Practice anywhere, anytime.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your practice sessions, recordings, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService().clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared')),
                );
              }
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
