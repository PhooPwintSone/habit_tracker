import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  final DateTime viewDate;

  const StatsPage({super.key, required this.habits, required this.viewDate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final key = "${viewDate.year}-${viewDate.month.toString().padLeft(2, '0')}";
    final daysInMonth = DateTime(viewDate.year, viewDate.month + 1, 0).day;

    if (habits.isEmpty) {
      return const Center(child: Text("No habits yet 👀"));
    }

    // calculate stats
    int totalCompleted = 0;
    int totalPossible = 0;
    int bestStreak = 0;

    for (var habit in habits) {
      habit["history"] ??= {};
      if (habit["history"][key] == null) {
        habit["history"][key] = List<bool>.filled(daysInMonth, false);
      }

      final List<bool> days = List<bool>.from(habit["history"][key]);

      // count progress
      totalCompleted += days.where((d) => d).length;
      totalPossible += days.length;

      // streak
      int currentStreak = 0;
      int maxStreak = 0;
      for (int i = 0; i < days.length; i++) {
        if (days[i]) {
          currentStreak++;
          maxStreak = maxStreak < currentStreak ? currentStreak : maxStreak;
        } else {
          currentStreak = 0;
        }
      }
      if (maxStreak > bestStreak) bestStreak = maxStreak;
    }

    final percent = totalPossible > 0 ? totalCompleted / totalPossible : 0.0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Stats for ${DateFormat.yMMMM().format(viewDate)}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Completion
          Text(
            "${(percent * 100).toStringAsFixed(0)}% of all habits completed",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: cs.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            minHeight: 10,
            borderRadius: BorderRadius.circular(12),
          ),

          const SizedBox(height: 32),

          // Best streak
          Text(
            "🔥 Best streak this month: $bestStreak days",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 32),

          // Total habits overview
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final List<bool> days = List<bool>.from(
                  habit["history"][key] ?? [],
                );

                final done = days.where((d) => d).length;
                final percent = days.isNotEmpty ? done / days.length : 0.0;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(habit["name"]),
                    subtitle: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: cs.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.secondary),
                      minHeight: 8,
                    ),
                    trailing: Text("${(percent * 100).toStringAsFixed(0)}%"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
