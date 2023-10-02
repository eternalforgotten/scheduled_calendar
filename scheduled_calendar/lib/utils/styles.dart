import 'package:flutter/material.dart';

class ScheduledCalendarDayStyle {
  final double? width;
  final double? height;
  final EdgeInsets padding; // отступ от числа до краёв кружочка
  final TextStyle? inscriptionTextStyle; // стиль текста под числом
  final TextStyle? currentDayTextStyle; // стиль текста текущего числа
  final TextStyle? workDayTextStyle; // стиль числа буднего дня
  final String? workDayInscription; // подпись под будним днём
  final TextStyle holidayTextStyle; // стиль числа выходного дня
  final String? holidayInscription; // подпись под выходным
  final TextStyle focusedDayTextStyle; // стиль сфокусированного, нажатого числа
  final Decoration focusedDayDecoration; // стиль фона нажатого числа
  final Decoration
      performerWorkDayDecoration; // стиль фона рабочего дня исполнителя
  final String
      performerWorkDayInscription; // подпись под числом рабочего дня исполнителя
  final TextStyle selectionModeTextStyle; // стиль дней в режиме выделения
  final Decoration
      selectionModeDecoration; // стиль фона чисел дней в режиме выделения
  final TextStyle selectedDayTextStyle; // стиль текста выбранного дня
  final Decoration selectedDayDecoration; // стиль фона выбранного дня
  final Widget
      appointmentNumberBadge; // виджет для количества записей

  ScheduledCalendarDayStyle({
    required this.width,
    required this.height,
    required this.padding,
    required this.inscriptionTextStyle,
    required this.currentDayTextStyle,
    required this.workDayTextStyle,
    required this.workDayInscription,
    required this.holidayTextStyle,
    required this.holidayInscription,
    required this.focusedDayTextStyle,
    required this.focusedDayDecoration,
    required this.performerWorkDayDecoration,
    required this.performerWorkDayInscription,
    required this.selectionModeTextStyle,
    required this.selectionModeDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.appointmentNumberBadge,
  });
}