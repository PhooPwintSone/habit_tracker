# Habito – Features Documentation

This documentation is based on the real file structure of the template.

---

## 1. Unlimited Habits
Users can add as many habits as they want.
Implemented in `home_page.dart`.

---

## 2. Daily Check-In
- Tap to mark a day as completed
- Cannot check future dates
- Can check today and past days
Logic stored in:
`habit_page.dart` and `habit_storage.dart`

---

## 3. Calendar View
Full monthly calendar per habit.
Located inside `habit_page.dart`.

Highlights:
- Completed days
- Missed days
- Today indicator
- Current month navigation

---

## 4. Streak Tracking
Monthly streaks are automatically calculated.
Located inside:
`habit_page.dart`

---

## 5. Four Themes (including Dark Mode)
Themes defined in:
`main.dart`

You can edit colors for:
- buttons
- backgrounds
- calendar highlights
- text styles

---

## 6. Local Storage (Hive)
All habit data is saved locally using Hive.
File:
`habit_storage.dart`

---

## 7. Simple & Beginner-Friendly File Structure

lib/
main.dart
home_page.dart
habit_page.dart
habit_storage.dart
stats_page.dart


No complex folders. Easy to read, easy to edit.
