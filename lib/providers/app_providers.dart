import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/practice_session.dart';
import '../models/speaker.dart';
import '../models/user_settings.dart';
import '../services/storage_service.dart';
import '../data/featured_speakers.dart';

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  return SettingsNotifier(ref.read(storageServiceProvider));
});

class SettingsNotifier extends StateNotifier<UserSettings> {
  final StorageService _storage;

  SettingsNotifier(this._storage) : super(UserSettings.defaultSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await _storage.getSettings();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    await _storage.saveSettings(newSettings);
    state = newSettings;
  }
}

// Sessions Provider
final sessionsProvider = StateNotifierProvider<SessionsNotifier, List<PracticeSession>>((ref) {
  return SessionsNotifier(ref.read(storageServiceProvider));
});

class SessionsNotifier extends StateNotifier<List<PracticeSession>> {
  final StorageService _storage;

  SessionsNotifier(this._storage) : super([]) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    state = await _storage.getSessions();
  }

  Future<void> addSession(PracticeSession session) async {
    await _storage.addSession(session);
    state = await _storage.getSessions();
  }

  Future<void> deleteSession(String id) async {
    await _storage.deleteSession(id);
    state = await _storage.getSessions();
  }

  Future<List<PracticeSession>> getSessionsForSpeaker(String speakerId) async {
    return await _storage.getSessionsForSpeaker(speakerId);
  }
}

// Stats Provider
final statsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getStats();
});

// Featured Speakers Provider
final featuredSpeakersProvider = Provider<List<Speaker>>((ref) {
  return featuredSpeakers;
});

// Recommended Speakers Provider
final recommendedSpeakersProvider = Provider<List<Speaker>>((ref) {
  final sessions = ref.watch(sessionsProvider);
  final completedSpeakerIds = sessions.map((s) => s.speakerId).toSet().toList();
  return getRecommendedSpeakers(completedSpeakerIds);
});

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Speakers Provider
final filteredSpeakersProvider = Provider<List<Speaker>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final allSpeakers = ref.watch(featuredSpeakersProvider);
  
  if (query.isEmpty) return allSpeakers;
  
  final lowerQuery = query.toLowerCase();
  return allSpeakers.where((s) {
    return s.name.toLowerCase().contains(lowerQuery) ||
        s.title.toLowerCase().contains(lowerQuery) ||
        s.topic.toLowerCase().contains(lowerQuery) ||
        s.tags.any((t) => t.toLowerCase().contains(lowerQuery));
  }).toList();
});

// Selected Speaker Provider
final selectedSpeakerProvider = StateProvider<Speaker?>((ref) => null);

// Difficulty Filter Provider
final difficultyFilterProvider = StateProvider<String>((ref) => 'all');

// Recording State Provider
final isRecordingProvider = StateProvider<bool>((ref) => false);
final recordingDurationProvider = StateProvider<int>((ref) => 0);
