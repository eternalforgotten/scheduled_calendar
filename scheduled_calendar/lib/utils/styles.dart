import 'package:flutter/material.dart';

class ScheduledCalendarDayStyle {
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
