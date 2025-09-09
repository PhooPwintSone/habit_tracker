import 'package:flutter/material.dart';
import 'habits_page.dart';
import 'stats_page.dart';
import 'habit_storage.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.currentTheme,
    required this.onThemeChange,
  });

  final AppTheme currentTheme;
  final Function(AppTheme) onThemeChange;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final loaded = await HabitStorage.load();
    if (mounted) {
      setState(() {
        _habits.clear();
        _habits.addAll(loaded);
      });
    }
  }

  void _addHabit(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final exists = _habits.any(
      (h) => (h['name'] as String).toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    setState(() {
      _habits.add({
        "name": trimmed,
        "days": List<bool>.filled(daysInMonth, false),
      });
    });
    await HabitStorage.save(_habits);
  }

  void _toggleDay(int habitIndex, int dayIndex, DateTime date) async {
    setState(() {
      final days = _habits[habitIndex]["days"] as List<bool>;
      if (dayIndex >= days.length) {
        days.addAll(List<bool>.filled(dayIndex - days.length + 1, false));
      }
      days[dayIndex] = !days[dayIndex];
    });
    await HabitStorage.save(_habits);
  }

  void _deleteHabit(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Habit",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to delete this habit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _habits.removeAt(index);
              });
              await HabitStorage.save(_habits);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _editHabit(int index, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final exists = _habits.asMap().entries.any(
      (e) =>
          e.key != index &&
          (e.value['name'] as String).toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return;

    setState(() {
      _habits[index]["name"] = trimmed;
    });
    await HabitStorage.save(_habits);
  }

  void _addHabitDialog() {
    String habitName = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Add New Habit",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            autofocus: true,
            onChanged: (value) => habitName = value,
            decoration: const InputDecoration(hintText: "Enter habit name..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (habitName.isNotEmpty) {
                  _addHabit(habitName);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HabitsPage(
        habits: _habits,
        onToggleDay: _toggleDay,
        onDeleteHabit: _deleteHabit,
        onEditHabit: _editHabit,
      ),
      StatsPage(habits: _habits, viewDate: DateTime.now()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        actions: [
          PopupMenuButton<AppTheme>(
            initialValue: widget.currentTheme,
            onSelected: widget.onThemeChange,
            itemBuilder: (context) => const [
              PopupMenuItem(value: AppTheme.green, child: Text("Green 🌿")),
              PopupMenuItem(value: AppTheme.pink, child: Text("Pink 🌸")),
              PopupMenuItem(value: AppTheme.blue, child: Text("Blue 💙")),
              PopupMenuItem(value: AppTheme.dark, child: Text("Dark 🌙")),
            ],
          ),
        ],
      ),
      body: screens[_selectedIndex], // ✅ now works
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addHabitDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
