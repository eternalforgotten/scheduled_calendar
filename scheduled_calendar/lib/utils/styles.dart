import 'package:flutter/material.dart';

class ScheduledCalendarDayStyle {
  /// Padding between date and circle border
  final EdgeInsets padding;

  /// Style of the text under the date
  final TextStyle? inscriptionTextStyle;

  /// Style of the current date text
  final TextStyle? currentDayTextStyle;

  /// Text style of the work day
  final TextStyle? workDayTextStyle;

  /// Inscription under the work day
  final String? workDayInscription;

  /// Text style of the holiday
  final TextStyle holidayTextStyle;

  /// Inscription under the holiday
  final String? holidayInscription;

  /// Text style of the focused, pressed day
  final TextStyle focusedDayTextStyle;

  /// Background decoration if the focused day
  final Decoration focusedDayDecoration;

  /// Background decoration if the performer's work day
  final Decoration performerWorkDayDecoration;

  /// Inscription under the performer's work day
  final String performerWorkDayInscription;

  /// Text style of the days in selection mode
  final TextStyle selectionModeTextStyle;

  /// Background decoration of days in selection mode
  final Decoration selectionModeDecoration;

  /// Text style of the selected day
  final TextStyle selectedDayTextStyle;

  /// Background decoration of the selected day
  final Decoration selectedDayDecoration;

  const ScheduledCalendarDayStyle({
    this.padding = const EdgeInsets.all(8),
    this.inscriptionTextStyle = const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w400,
      color: Color(0xFF5C5B5F),
    ),
    this.currentDayTextStyle = const TextStyle(),
    this.workDayTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    this.workDayInscription = 'Раб.',
    this.holidayTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5C5B5F),
    ),
    this.holidayInscription = 'Вых.',
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
    this.performerWorkDayInscription = '3 окна',
    this.selectionModeTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    this.selectionModeDecoration = const BoxDecoration(
      color: Color(0xFFEFD23C),
      shape: BoxShape.circle,
    ),
    this.selectedDayTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFFEFD23C),
    ),
    this.selectedDayDecoration = const BoxDecoration(),
  });
}

class AppointmentBadgeStyle {
  final double width;
  final double height;
  final Decoration badgeDecoration;
  final TextStyle numberTextStyle;

  const AppointmentBadgeStyle({
    this.width = 16,
    this.height = 16,
    this.badgeDecoration = const BoxDecoration(
      color: Color(0xFFEFD23C),
      shape: BoxShape.circle,
    ),
    this.numberTextStyle = const TextStyle(fontSize: 10),
  });
}
