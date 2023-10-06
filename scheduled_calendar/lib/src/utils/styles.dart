import 'package:flutter/material.dart';

import 'enums.dart';

class ScheduledCalendarDayStyle {
  /// Padding between date and circle border
  final EdgeInsets padding;

  /// Style of the current date text
  final TextStyle? currentDayTextStyle;

  /// Text style of the work day
  final TextStyle? workDayTextStyle;

  /// Text style of the day off
  final TextStyle dayOffTextStyle;

  /// Text style of the focused, active day
  final TextStyle focusedDayTextStyle;

  /// Background decoration of the focused, active day
  final BoxDecoration focusedDayDecoration;

  /// Background decoration of the performer's work day,
  /// when they are active
  final BoxDecoration performerWorkDayDecoration;

  /// Background decoration by default
  final BoxDecoration defaultWorkDayDecoration;

  /// Text style of the inactive days in selection mode
  final TextStyle selectionModeInactiveTextStyle;

  /// Background decoration of inactive days in selection mode
  final BoxDecoration selectionModeInactiveDecoration;

  /// Text style of the active days in selection mode
  final TextStyle selectionModeActiveTextStyle;

  /// Background decoration of the active days in selection mode
  final BoxDecoration selectionModeActiveDecoration;

  const ScheduledCalendarDayStyle({
    this.padding = const EdgeInsets.all(8),
    this.currentDayTextStyle = const TextStyle(),
    this.workDayTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    this.dayOffTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5C5B5F),
    ),
    this.focusedDayTextStyle = const TextStyle(),
    this.focusedDayDecoration = const BoxDecoration(),
    this.performerWorkDayDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          width: 1,
          color: Color(0xFF5C5B5F),
        ),
      ),
      shape: BoxShape.circle,
    ),
    this.defaultWorkDayDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          width: 1,
        ),
      ),
      shape: BoxShape.circle,
    ),
    this.selectionModeInactiveTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    this.selectionModeInactiveDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          width: 1,
          color: Color(0xFFEFD23C),
        ),
      ),
      shape: BoxShape.circle,
    ),
    this.selectionModeActiveTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    this.selectionModeActiveDecoration = const BoxDecoration(
      color: Color(0xFFEFD23C),
      shape: BoxShape.circle,
    ),
  });
}

class ScheduleCalendarMonthNameStyle {
  /// Text style of month name
  final TextStyle monthNameTextStyle;

  /// Select whether center month name or leave it above the start week. Defaults to [false]
  final bool centerMonthName;

  /// Way of the month name displaying: full or short. Defaults to [MonthNameDisplay.full]
  final MonthNameDisplay monthNameDisplay;

  /// Map of custom names for months
  final Map<int, String> monthCustomNames;

  /// Locale of month name
  final String? monthNameLocale;

  /// Select whether display year in month name or no. Defaults to [false]
  final bool displayYearInMonthName;

  const ScheduleCalendarMonthNameStyle({
    this.monthCustomNames = const {},
    this.centerMonthName = false,
    this.monthNameTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
    ),
    this.monthNameDisplay = MonthNameDisplay.full,
    this.displayYearInMonthName = false,
    this.monthNameLocale,
  });
}
