import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// --- Streak & Progress helpers ---

int currentStreak(List<bool> days, DateTime now) {
  if (days.isEmpty) return 0;

  final todayIdx = now.day - 1;
  int i = todayIdx;

  if (i >= days.length || !days[i]) i = todayIdx - 1;

  int streak = 0;
  while (i >= 0 && i < days.length && days[i]) {
    streak++;
    i--;
  }
  return streak;
}

double monthProgress(List<bool> days) {
  if (days.isEmpty) return 0;
  final completed = days.where((d) => d).length;
  return completed / days.length;
}

/// --- Habits Page ---

class HabitsPage extends StatefulWidget {
  final List<Map<String, dynamic>> habits;
  final Function(int, int, DateTime) onToggleDay;
  final Function(int) onDeleteHabit;
  final Function(int, String) onEditHabit;

  const HabitsPage({
    super.key,
    required this.habits,
    required this.onToggleDay,
    required this.onDeleteHabit,
    required this.onEditHabit,
  });

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  DateTime _viewDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final daysInMonth = DateTime(_viewDate.year, _viewDate.month + 1, 0).day;
    final key =
        "${_viewDate.year}-${_viewDate.month.toString().padLeft(2, '0')}";

    if (widget.habits.isEmpty) {
      return const Center(child: Text("No habits yet 👀"));
    }

    return Column(
      children: [
        // Month navigation bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
                  });
                },
              ),
              Text(
                DateFormat.yMMMM().format(_viewDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
                  });
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.habits.length,
            itemBuilder: (context, index) {
              final habit = widget.habits[index];
              habit["history"] ??= {};

              // ensure this month exists in history
              if (habit["history"][key] == null) {
                habit["history"][key] = List<bool>.filled(daysInMonth, false);
              }

              final List<bool> days = List<bool>.from(habit["history"][key]);
              final streak = currentStreak(days, DateTime.now());
              final progress = monthProgress(days);

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            habit["name"],
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: cs.primary),
                                onPressed: () {
                                  _showEditDialog(habit["name"], (newName) {
                                    widget.onEditHabit(index, newName);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => widget.onDeleteHabit(index),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Weekday headers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("MON"),
                          Text("TUE"),
                          Text("WED"),
                          Text("THU"),
                          Text("FRI"),
                          Text("SAT"),
                          Text("SUN"),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Calendar grid
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1,
                            ),
                        itemCount: daysInMonth,
                        itemBuilder: (context, dayIndex) {
                          final bool checked = days[dayIndex];
                          final bool isFuture =
                              (_viewDate.year == DateTime.now().year &&
                              _viewDate.month == DateTime.now().month &&
                              (dayIndex + 1 > DateTime.now().day));

                          final bg = checked ? cs.primary : cs.surface;
                          final border = isFuture ? cs.outline : cs.primary;
                          final textColor = checked
                              ? cs.onPrimary
                              : cs.onSurface;

                          // inside GridView.builder itemBuilder
                          return GestureDetector(
                            onTap: isFuture
                                ? null
                                : () => widget.onToggleDay(
                                    index,
                                    dayIndex,
                                    _viewDate,
                                  ), // ✅ pass viewDate
                            child: Container(
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: border, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  "${dayIndex + 1}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isFuture
                                        ? cs.onSurface.withOpacity(0.4)
                                        : textColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Streak + Progress
                      Text(
                        "Current streak: $streak day${streak == 1 ? '' : 's'} 🔥",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}% complete",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: cs.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showEditDialog(String oldName, Function(String) onSave) {
    String newName = oldName;
    final controller = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Edit Habit",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            onChanged: (val) => newName = val,
            decoration: const InputDecoration(hintText: "Enter new name..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.trim().isNotEmpty) {
                  onSave(newName.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
