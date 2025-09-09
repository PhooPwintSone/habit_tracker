import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum AppTheme { green, pink, blue, dark }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.green; // default
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('selectedTheme') ?? 0; // default green
    setState(() {
      _currentTheme = AppTheme.values[themeIndex];
      _isLoading = false;
    });
  }

  Future<void> _changeTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', theme.index);
    setState(() {
      _currentTheme = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: appThemes[_currentTheme],
      home: HomePage(currentTheme: _currentTheme, onThemeChange: _changeTheme),
    );
  }
}

/// ---- THEMES ----

final Map<AppTheme, ThemeData> appThemes = {
  AppTheme.green: _buildGreenTheme(),
  AppTheme.pink: _buildPinkTheme(),
  AppTheme.blue: _buildBlueTheme(),
  AppTheme.dark: _buildDarkTheme(),
};

// --- Green Theme ---
ThemeData _buildGreenTheme() {
  const seed = Color(0xFF1F5969);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(
      surface: const Color(0xFFCCEDE7),
      surfaceVariant: const Color(0xFF89C8CC),
    ),
    scaffoldBackgroundColor: const Color(0xFFCCEDE7),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F5969),
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF89C8CC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      elevation: 3,
    ),
  );
}

// --- Pink Theme ---
ThemeData _buildPinkTheme() {
  const seed = Color(0xFFFF7DAA);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
    ),
  );
}

// --- Blue Theme ---
ThemeData _buildBlueTheme() {
  const seed = Color(0xFF3A7BD5);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
    ),
  );
}

// --- Dark Theme ---
ThemeData _buildDarkTheme() {
  const seed = Color(0xFF1F5969);
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surfaceContainerHighest,
      foregroundColor: scheme.onSurface,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      elevation: 2,
    ),
  );
}
