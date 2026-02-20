import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/practice_session.dart';
import '../models/user_settings.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _sessionsFile = 'sessions.json';
  static const String _settingsFile = 'settings.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _sessionsFilePath async {
    final path = await _localPath;
    return File('$path/$_sessionsFile');
  }

  Future<File> get _settingsFilePath async {
    final path = await _localPath;
    return File('$path/$_settingsFile');
  }

  Future<void> init() async {
    // Ensure files exist
    final sessionsFile = await _sessionsFilePath;
    if (!await sessionsFile.exists()) {
      await sessionsFile.writeAsString(jsonEncode([]));
    }

    final settingsFile = await _settingsFilePath;
    if (!await settingsFile.exists()) {
      await settingsFile.writeAsString(
        jsonEncode(UserSettings.defaultSettings().toJson()),
      );
    }
  }

  // Sessions
  Future<List<PracticeSession>> getSessions() async {
    try {
      final file = await _sessionsFilePath;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => PracticeSession.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<PracticeSession>> getSessionsForSpeaker(String speakerId) async {
    final sessions = await getSessions();
    return sessions.where((s) => s.speakerId == speakerId).toList();
  }

  Future<void> addSession(PracticeSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    await _saveSessions(sessions);
  }

  Future<void> deleteSession(String id) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == id);
    await _saveSessions(sessions);
  }

  Future<void> _saveSessions(List<PracticeSession> sessions) async {
    final file = await _sessionsFilePath;
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  // Settings
  Future<UserSettings> getSettings() async {
    try {
      final file = await _settingsFilePath;
      final contents = await file.readAsString();
      final json = jsonDecode(contents);
      return UserSettings.fromJson(json);
    } catch (e) {
      return UserSettings.defaultSettings();
    }
  }

  Future<void> saveSettings(UserSettings settings) async {
    final file = await _settingsFilePath;
    await file.writeAsString(jsonEncode(settings.toJson()));
  }

  // Stats
  Future<Map<String, dynamic>> getStats() async {
    final sessions = await getSessions();
    final totalSessions = sessions.length;
    final totalDuration = sessions.fold<int>(0, (sum, s) => sum + s.duration);
    final uniqueSpeakers = sessions.map((s) => s.speakerId).toSet().length;

    final gradedSessions = sessions.where((s) => s.grades != null).toList();
    final averageScore = gradedSessions.isEmpty
        ? 0
        : gradedSessions.fold<int>(0, (sum, s) => sum + s.grades!.overall) ~/
            gradedSessions.length;

    // Weekly progress
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final thisWeekSessions =
        sessions.where((s) => s.date.isAfter(weekAgo)).length;

    return {
      'totalSessions': totalSessions,
      'totalDuration': totalDuration,
      'uniqueSpeakers': uniqueSpeakers,
      'averageScore': averageScore,
      'thisWeekSessions': thisWeekSessions,
    };
  }

  Future<void> clearAllData() async {
    final sessionsFile = await _sessionsFilePath;
    final settingsFile = await _settingsFilePath;

    if (await sessionsFile.exists()) {
      await sessionsFile.writeAsString(jsonEncode([]));
    }

    if (await settingsFile.exists()) {
      await settingsFile.writeAsString(
        jsonEncode(UserSettings.defaultSettings().toJson()),
      );
    }
  }
}
