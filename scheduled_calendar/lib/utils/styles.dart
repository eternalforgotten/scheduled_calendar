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
  final TextStyle dayOffTextStyle;

  /// Inscription under the holiday
  final String? dayOffInscription;

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
    this.dayOffTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5C5B5F),
    ),
    this.dayOffInscription = 'Вых.',
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

class ScheduleInscriptionStyle {
  final TextStyle textStyle;
  final String instructionText;
  final TextStyle instructionTextStyle;
  final TextStyle dateTextStyle;

  const ScheduleInscriptionStyle({
    this.textStyle = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
    ),
    this.instructionText = 'Расписание на дальнейшую неделю будет доступно',
    this.instructionTextStyle = const TextStyle(
      color: Color(0xFF5C5B5F),
    ),
    this.dateTextStyle = const TextStyle(
      color: Color(0xFFEFD23C),
    ),
  });
}

class ClientBookingCardStyle {
  final Decoration cardDecoration;
  final TextStyle dateTextStyle;
  final String instructionText;
  final TextStyle instructionTextStyle;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final ButtonStyle buttonStyle;
  final TextStyle inactiveButtonTextStyle;
  final TextStyle timeSlotTextStyle;
  final Decoration timeSlotDecoration;
  final EdgeInsets timeSlotPadding;
  final TextStyle selectedTimeSlotTextStyle;
  final Decoration selectedTimeSlotDecoration;

  const ClientBookingCardStyle({
    this.cardDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Color(0xFF1C1C1F),
    ),
    this.dateTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF6F5F8),
      height: 24.51 / 18,
    ),
    this.instructionText = 'Выберите время на этот день',
    this.instructionTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF5C5B5F),
      height: 16 / 12,
    ),
    this.buttonText = 'Выбрать',
    this.buttonTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
      height: 22 / 14,
    ),
    this.buttonStyle = const ButtonStyle(),
    this.inactiveButtonTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF5C5B5F),
    ),
    this.timeSlotTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 22 / 14,
    ),
    this.timeSlotDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          width: 1,
          color: Color(0xFFEFD23C),
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    this.timeSlotPadding = const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 5,
    ),
    this.selectedTimeSlotTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF0A0A0A),
      height: 22 / 14,
    ),
    this.selectedTimeSlotDecoration = const BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(
          width: 1,
          color: Color(0xFFEFD23C),
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      color: Color(0xFFEFD23C),
    ),
  });
}
