import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_progress_model.dart';

class ProgressRepository {
  static const _key = 'user_progress';

  Future<UserProgressModel> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) {
      return UserProgressModel.empty();
    }
    return UserProgressModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProgress(UserProgressModel progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(progress.toMap()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
