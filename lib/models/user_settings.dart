class UserSettings {
  bool cameraEnabled;
  bool microphoneEnabled;
  bool autoRecord;
  bool showGrades;
  String preferredDifficulty;

  UserSettings({
    this.cameraEnabled = true,
    this.microphoneEnabled = true,
    this.autoRecord = false,
    this.showGrades = true,
    this.preferredDifficulty = 'all',
  });

  factory UserSettings.defaultSettings() {
    return UserSettings();
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      cameraEnabled: json['cameraEnabled'] ?? true,
      microphoneEnabled: json['microphoneEnabled'] ?? true,
      autoRecord: json['autoRecord'] ?? false,
      showGrades: json['showGrades'] ?? true,
      preferredDifficulty: json['preferredDifficulty'] ?? 'all',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cameraEnabled': cameraEnabled,
      'microphoneEnabled': microphoneEnabled,
      'autoRecord': autoRecord,
      'showGrades': showGrades,
      'preferredDifficulty': preferredDifficulty,
    };
  }
}
