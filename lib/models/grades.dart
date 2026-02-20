class Grades {
  final int overall;
  final int pacing;
  final int clarity;
  final int engagement;
  final int bodyLanguage;
  final int voiceVariation;
  final List<String> feedback;
  final List<String> improvements;

  Grades({
    required this.overall,
    required this.pacing,
    required this.clarity,
    required this.engagement,
    required this.bodyLanguage,
    required this.voiceVariation,
    required this.feedback,
    required this.improvements,
  });

  factory Grades.fromJson(Map<String, dynamic> json) {
    return Grades(
      overall: json['overall'] ?? 0,
      pacing: json['pacing'] ?? 0,
      clarity: json['clarity'] ?? 0,
      engagement: json['engagement'] ?? 0,
      bodyLanguage: json['bodyLanguage'] ?? 0,
      voiceVariation: json['voiceVariation'] ?? 0,
      feedback: List<String>.from(json['feedback'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'pacing': pacing,
      'clarity': clarity,
      'engagement': engagement,
      'bodyLanguage': bodyLanguage,
      'voiceVariation': voiceVariation,
      'feedback': feedback,
      'improvements': improvements,
    };
  }

  static Grades generateMock() {
    final baseScore = 70 + (DateTime.now().millisecond % 25);
    return Grades(
      overall: baseScore,
      pacing: (baseScore + (DateTime.now().millisecond % 10 - 5)).clamp(60, 98),
      clarity: (baseScore + (DateTime.now().millisecond % 10 - 5)).clamp(60, 98),
      engagement: (baseScore + (DateTime.now().millisecond % 15 - 7)).clamp(60, 98),
      bodyLanguage: (baseScore + (DateTime.now().millisecond % 12 - 6)).clamp(60, 98),
      voiceVariation: (baseScore + (DateTime.now().millisecond % 8 - 4)).clamp(60, 98),
      feedback: [
        'Good eye contact with the camera',
        'Clear articulation of key points',
        'Effective use of pauses',
        'Consider varying your tone more',
      ],
      improvements: [
        'Practice more hand gestures',
        'Work on vocal variety',
        'Maintain consistent energy throughout',
      ],
    );
  }
}
