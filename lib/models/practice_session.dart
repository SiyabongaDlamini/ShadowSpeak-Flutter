import 'grades.dart';

class PracticeSession {
  final String id;
  final String speakerId;
  final String speakerName;
  final DateTime date;
  final int duration;
  final String? recordingPath;
  final Grades? grades;
  final String? notes;

  PracticeSession({
    required this.id,
    required this.speakerId,
    required this.speakerName,
    required this.date,
    required this.duration,
    this.recordingPath,
    this.grades,
    this.notes,
  });

  factory PracticeSession.fromJson(Map<String, dynamic> json) {
    return PracticeSession(
      id: json['id'] ?? '',
      speakerId: json['speakerId'] ?? '',
      speakerName: json['speakerName'] ?? '',
      date: DateTime.parse(json['date']),
      duration: json['duration'] ?? 0,
      recordingPath: json['recordingPath'],
      grades: json['grades'] != null ? Grades.fromJson(json['grades']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speakerId': speakerId,
      'speakerName': speakerName,
      'date': date.toIso8601String(),
      'duration': duration,
      'recordingPath': recordingPath,
      'grades': grades?.toJson(),
      'notes': notes,
    };
  }
}
