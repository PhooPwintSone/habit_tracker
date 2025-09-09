import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HabitStorage {
  static const _key = "habits";

  /// Save the habits list to SharedPreferences
  static Future<void> save(List<Map<String, dynamic>> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(habits));
  }

  /// Load habits and migrate if needed
  static Future<List<Map<String, dynamic>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    // Ensure each habit has the new "history" structure
    final List<Map<String, dynamic>> habits = decoded.map((e) {
      final habit = Map<String, dynamic>.from(e);

      if (habit.containsKey("days")) {
        // 🔄 migrate old format → new format
        final now = DateTime.now();
        final key = "${now.year}-${now.month.toString().padLeft(2, '0')}";
        habit["history"] = {key: List<bool>.from(habit["days"] as List)};
        habit.remove("days");
      }

      // Make sure history map exists
      habit["history"] ??= {};
      return habit;
    }).toList();

    return habits;
  }
}
