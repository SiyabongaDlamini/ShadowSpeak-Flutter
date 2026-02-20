class Speaker {
  final String id;
  final String name;
  final String title;
  final String topic;
  final String youtubeId;
  final String thumbnail;
  final String duration;
  final String difficulty;
  final List<String> tags;
  final double rating;

  Speaker({
    required this.id,
    required this.name,
    required this.title,
    required this.topic,
    required this.youtubeId,
    required this.thumbnail,
    required this.duration,
    required this.difficulty,
    required this.tags,
    required this.rating,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      topic: json['topic'] ?? '',
      youtubeId: json['youtubeId'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? 'beginner',
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'topic': topic,
      'youtubeId': youtubeId,
      'thumbnail': thumbnail,
      'duration': duration,
      'difficulty': difficulty,
      'tags': tags,
      'rating': rating,
    };
  }
}
