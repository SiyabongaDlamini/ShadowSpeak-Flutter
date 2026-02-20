import '../models/speaker.dart';

final List<Speaker> featuredSpeakers = [
  Speaker(
    id: '1',
    name: 'Simon Sinek',
    title: 'How Great Leaders Inspire Action',
    topic: 'Leadership & Motivation',
    youtubeId: 'qp0HIF3SfI4',
    thumbnail: 'https://img.youtube.com/vi/qp0HIF3SfI4/maxresdefault.jpg',
    duration: '18:04',
    difficulty: 'intermediate',
    tags: ['leadership', 'motivation', 'business', 'inspiration'],
    rating: 4.9,
  ),
  Speaker(
    id: '2',
    name: 'Brené Brown',
    title: 'The Power of Vulnerability',
    topic: 'Personal Growth',
    youtubeId: 'iCvmsMzlF7o',
    thumbnail: 'https://img.youtube.com/vi/iCvmsMzlF7o/maxresdefault.jpg',
    duration: '20:19',
    difficulty: 'beginner',
    tags: ['vulnerability', 'courage', 'connection', 'empathy'],
    rating: 4.8,
  ),
  Speaker(
    id: '3',
    name: 'Sir Ken Robinson',
    title: 'Do Schools Kill Creativity?',
    topic: 'Education & Creativity',
    youtubeId: 'iG9CE55wbtY',
    thumbnail: 'https://img.youtube.com/vi/iG9CE55wbtY/maxresdefault.jpg',
    duration: '19:29',
    difficulty: 'beginner',
    tags: ['education', 'creativity', 'humor', 'children'],
    rating: 4.9,
  ),
  Speaker(
    id: '4',
    name: 'Amy Cuddy',
    title: 'Your Body Language May Shape Who You Are',
    topic: 'Body Language & Confidence',
    youtubeId: 'Ks-_Mh1QhMc',
    thumbnail: 'https://img.youtube.com/vi/Ks-_Mh1QhMc/maxresdefault.jpg',
    duration: '21:02',
    difficulty: 'intermediate',
    tags: ['body language', 'confidence', 'power posing', 'psychology'],
    rating: 4.7,
  ),
  Speaker(
    id: '5',
    name: 'Julian Treasure',
    title: 'How to Speak So People Want to Listen',
    topic: 'Communication Skills',
    youtubeId: 'eIho2S0ZahI',
    thumbnail: 'https://img.youtube.com/vi/eIho2S0ZahI/maxresdefault.jpg',
    duration: '9:58',
    difficulty: 'beginner',
    tags: ['communication', 'voice', 'listening', 'speaking'],
    rating: 4.8,
  ),
  Speaker(
    id: '6',
    name: 'Nancy Duarte',
    title: 'The Secret Structure of Great Talks',
    topic: 'Presentation Design',
    youtubeId: 'uYt4u-4EXyo',
    thumbnail: 'https://img.youtube.com/vi/uYt4u-4EXyo/maxresdefault.jpg',
    duration: '17:52',
    difficulty: 'advanced',
    tags: ['presentations', 'storytelling', 'structure', 'design'],
    rating: 4.6,
  ),
  Speaker(
    id: '7',
    name: 'Dan Pink',
    title: 'The Puzzle of Motivation',
    topic: 'Motivation & Psychology',
    youtubeId: 'rrkrvAUbU9Y',
    thumbnail: 'https://img.youtube.com/vi/rrkrvAUbU9Y/maxresdefault.jpg',
    duration: '18:36',
    difficulty: 'intermediate',
    tags: ['motivation', 'psychology', 'business', 'science'],
    rating: 4.7,
  ),
  Speaker(
    id: '8',
    name: 'Elizabeth Gilbert',
    title: 'Your Elusive Creative Genius',
    topic: 'Creativity & Writing',
    youtubeId: '86x-u-tz0MA',
    thumbnail: 'https://img.youtube.com/vi/86x-u-tz0MA/maxresdefault.jpg',
    duration: '19:29',
    difficulty: 'intermediate',
    tags: ['creativity', 'writing', 'fear', 'inspiration'],
    rating: 4.8,
  ),
  Speaker(
    id: '9',
    name: 'Hans Rosling',
    title: 'The Best Stats You\'ve Ever Seen',
    topic: 'Data & Storytelling',
    youtubeId: 'hVimVzgtD6w',
    thumbnail: 'https://img.youtube.com/vi/hVimVzgtD6w/maxresdefault.jpg',
    duration: '19:50',
    difficulty: 'advanced',
    tags: ['data', 'statistics', 'storytelling', 'global development'],
    rating: 4.9,
  ),
  Speaker(
    id: '10',
    name: 'Mel Robbins',
    title: 'How to Stop Screwing Yourself Over',
    topic: 'Self-Improvement',
    youtubeId: 'Lp7E973zozc',
    thumbnail: 'https://img.youtube.com/vi/Lp7E973zozc/maxresdefault.jpg',
    duration: '21:40',
    difficulty: 'beginner',
    tags: ['motivation', 'action', 'habits', 'confidence'],
    rating: 4.7,
  ),
  Speaker(
    id: '11',
    name: 'Chris Anderson',
    title: 'TED\'s Secret to Great Public Speaking',
    topic: 'Public Speaking',
    youtubeId: '-FOCpMAww28',
    thumbnail: 'https://img.youtube.com/vi/-FOCpMAww28/maxresdefault.jpg',
    duration: '7:56',
    difficulty: 'intermediate',
    tags: ['public speaking', 'TED', 'ideas', 'communication'],
    rating: 4.8,
  ),
  Speaker(
    id: '12',
    name: 'Angela Lee Duckworth',
    title: 'Grit: The Power of Passion and Perseverance',
    topic: 'Psychology & Success',
    youtubeId: 'H14bBuluwB8',
    thumbnail: 'https://img.youtube.com/vi/H14bBuluwB8/maxresdefault.jpg',
    duration: '6:12',
    difficulty: 'beginner',
    tags: ['grit', 'perseverance', 'success', 'education'],
    rating: 4.6,
  ),
];

List<Speaker> getRecommendedSpeakers(List<String> completedSpeakerIds) {
  return featuredSpeakers
      .where((s) => !completedSpeakerIds.contains(s.id))
      .toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));
}

List<Speaker> getSpeakersByDifficulty(String difficulty) {
  if (difficulty == 'all') return featuredSpeakers;
  return featuredSpeakers.where((s) => s.difficulty == difficulty).toList();
}

List<Speaker> searchSpeakers(String query) {
  final lowerQuery = query.toLowerCase();
  return featuredSpeakers.where((s) {
    return s.name.toLowerCase().contains(lowerQuery) ||
        s.title.toLowerCase().contains(lowerQuery) ||
        s.topic.toLowerCase().contains(lowerQuery) ||
        s.tags.any((t) => t.toLowerCase().contains(lowerQuery));
  }).toList();
}
