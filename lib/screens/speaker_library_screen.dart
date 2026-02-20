import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/speaker_card.dart';
import 'practice_room_screen.dart';

class SpeakerLibraryScreen extends ConsumerWidget {
  const SpeakerLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final difficultyFilter = ref.watch(difficultyFilterProvider);
    final allSpeakers = ref.watch(featuredSpeakersProvider);
    
    // Filter speakers
    var filteredSpeakers = allSpeakers;
    
    if (difficultyFilter != 'all') {
      filteredSpeakers = filteredSpeakers
          .where((s) => s.difficulty == difficultyFilter)
          .toList();
    }
    
    if (searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      filteredSpeakers = filteredSpeakers.where((s) {
        return s.name.toLowerCase().contains(lowerQuery) ||
            s.title.toLowerCase().contains(lowerQuery) ||
            s.topic.toLowerCase().contains(lowerQuery) ||
            s.tags.any((t) => t.toLowerCase().contains(lowerQuery));
      }).toList();
    }

    // Get unique tags
    final allTags = allSpeakers.expand((s) => s.tags).toSet().toList()..sort();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Speaker Library',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
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
                          const Color(0xFF8B5CF6).withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search speakers, topics, or tags...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Difficulty Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'all',
                        'beginner',
                        'intermediate',
                        'advanced'
                      ].map((difficulty) {
                        final isSelected = difficultyFilter == difficulty;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              difficulty[0].toUpperCase() +
                                  difficulty.substring(1),
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              ref.read(difficultyFilterProvider.notifier).state =
                                  difficulty;
                            },
                            selectedColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            checkmarkColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Tags
                  if (searchQuery.isEmpty) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: allTags.take(10).map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(tag),
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state =
                                    tag;
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Results Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${filteredSpeakers.length} speakers found',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          
          // Speakers Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: filteredSpeakers.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No speakers found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final speaker = filteredSpeakers[index];
                        return SpeakerCard(
                          speaker: speaker,
                          onTap: () {
                            ref.read(selectedSpeakerProvider.notifier).state =
                                speaker;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PracticeRoomScreen(speaker: speaker),
                              ),
                            );
                          },
                        );
                      },
                      childCount: filteredSpeakers.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
