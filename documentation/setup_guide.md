# Habito – Setup Guide

This guide matches the real structure of your Habito project.

---

## 1. Installation

1. Unzip the product package.
2. Open the folder in VS Code or Android Studio.
3. Run:
 flutter pub get
 flutter run

---

## 2. File Structure Overview

All core features are located inside the main `lib/` folder:

- `main.dart` – entry point, themes, routing
- `home_page.dart` – habit list, add habit UI, check-in logic
- `habit_page.dart` – calendar view, streak, habit detail page
- `habit_storage.dart` – Hive box, saving/loading habits
- `stats_page.dart` – progress and statistics screen

This template intentionally uses a simple structure for beginners.

---

## 3. Changing Theme Colors

Themes are defined inside `main.dart`.

Look for: theme: ThemeData( ... )

You can edit:
- primary color
- background color
- text styles
- light/dark mode settings

---

## 4. Managing Habits (Hive)

Habit storage logic is inside:
`lib/habit_storage.dart`


Inside this file, you can:
- edit habit model
- change how habits are saved
- modify check-in behavior
- extend features (notes, category, reminders)

---

## 5. Editing Calendar View

Calendar logic is located inside:
`lib/habit_page.dart`

Search for:
- calendar loop
- streak logic
- date highlighting

You can modify:
- colors
- dot markers
- streak style
- calendar formatting

---

## 6. Editing Home Screen

In: `lib/home_page.dart`



You can:
- change layout
- customize add-habit dialog
- change habit card UI
- modify check-in buttons

---

## 7. Stats Page
`lib/stats_page.dart`


You can:
- edit progress calculation
- change chart style
- update UI layout

---

## 8. Build Release APK
flutter build apk --release
