import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/speaker_card.dart';
import '../widgets/stat_card.dart';
import 'speaker_library_screen.dart';
import 'practice_room_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'ShadowSpeak',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6366F1),
                          const Color(0xFF6366F1).withOpacity(0.8),
                          const Color(0xFFEC4899).withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -20,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Continue your journey to becoming a confident speaker.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  statsAsync.when(
                    data: (stats) => _buildStatsSection(context, stats),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const Text('Error loading stats'),
                  ),
                  const SizedBox(height: 24),

                  // Recommended Speakers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended for You',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SpeakerLibraryScreen(),
                          ),
                        ),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final speakers = ref.watch(recommendedSpeakersProvider);
                      if (speakers.isEmpty) {
                        return const Center(
                          child: Text(
                              'You\'ve practiced with all featured speakers!'),
                        );
                      }
                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: speakers.take(3).length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 280,
                                child: SpeakerCard(
                                  speaker: speakers[index],
                                  onTap: () {
                                    ref
                                        .read(selectedSpeakerProvider.notifier)
                                        .state = speakers[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PracticeRoomScreen(
                                          speaker: speakers[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Recent Activity
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Builder(
                    builder: (context) {
                      final sessions = ref.watch(sessionsProvider);
                      final recentSessions = sessions.take(5).toList();
                      if (recentSessions.isEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.videocam_off,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 12),
                                const Text('No practice sessions yet'),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SpeakerLibraryScreen(),
                                    ),
                                  ),
                                  child: const Text('Start Your First Session'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: recentSessions.map((session) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: const Icon(Icons.play_arrow),
                              ),
                              title: Text(session.speakerName),
                              subtitle: Text(
                                '${session.date.day}/${session.date.month}/${session.date.year} · ${session.duration ~/ 60}:${(session.duration % 60).toString().padLeft(2, '0')}',
                              ),
                              trailing: session.grades != null
                                  ? Chip(
                                      label: Text(
                                        session.grades!.overall.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor:
                                          session.grades!.overall >= 80
                                              ? Colors.green[100]
                                              : Colors.orange[100],
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SpeakerLibraryScreen()),
        ),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Practicing'),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map<String, dynamic> stats) {
    const weeklyGoal = 5;
    final weeklyProgress = (stats['thisWeekSessions'] as int) / weeklyGoal;

    return Column(
      children: [
        // Stats Grid
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                title: 'Sessions',
                value: stats['totalSessions'].toString(),
                subtitle: '${stats['thisWeekSessions']} this week',
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.timer,
                title: 'Minutes',
                value: (stats['totalDuration'] ~/ 60).toString(),
                subtitle: 'total practice',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.people,
                title: 'Speakers',
                value: stats['uniqueSpeakers'].toString(),
                subtitle: 'unique',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.trending_up,
                title: 'Avg Score',
                value: stats['averageScore'] > 0
                    ? stats['averageScore'].toString()
                    : 'N/A',
                subtitle: stats['averageScore'] >= 80
                    ? 'Excellent!'
                    : stats['averageScore'] >= 60
                        ? 'Good progress'
                        : 'Keep practicing',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Weekly Goal
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Goal',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weeklyProgress >= 1.0
                              ? 'Goal achieved! You\'re on fire! 🔥'
                              : '${weeklyGoal - stats['thisWeekSessions']} sessions to go',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(weeklyProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          height: 12,
                          width: constraints.maxWidth *
                              weeklyProgress.clamp(0.0, 1.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                const Color(0xFFEC4899),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
