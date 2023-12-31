import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class PerformerCardStyle {
  final BoxDecoration cardDecoration;
  final TextStyle dateTextStyle;
  final String instructionText;
  final String emptyInstructionText;
  final TextStyle instructionTextStyle;
  final String requestButtonText;
  final TextStyle requestButtonTextStyle;
  final ButtonStyle requestButtonStyle;
  final String addButtonText;
  final TextStyle addButtonTextStyle;
  final ButtonStyle addButtonStyle;
  final Widget addButtonIcon;

  const PerformerCardStyle({
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
    this.instructionText = 'Задайте рабочее время на этот день',
    this.emptyInstructionText = 'Рабочее время на этот день не задано',
    this.instructionTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFF5C5B5F),
      height: 16 / 12,
    ),
    this.requestButtonText = 'Готово',
    this.requestButtonTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
      height: 22 / 14,
    ),
    this.requestButtonStyle = const ButtonStyle(),
    this.addButtonText = 'Добавить окно',
    this.addButtonTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF6F5F8),
      height: 22 / 13,
    ),
    this.addButtonStyle = const ButtonStyle(
      padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      ),
      backgroundColor: MaterialStatePropertyAll(Color(0xFF323137)),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
    ),
    this.addButtonIcon = const Icon(
      Icons.add,
      color: Colors.white,
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

class ClueStyle {
  final double width;
  final double height;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final Color backgroundColor;
  final double? arrowLeftPadding;
  final TooltipPosition toolTipPosition;

  const ClueStyle({
    this.width = 259,
    this.height = 101,
    this.titleTextStyle = const TextStyle(
        fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFF6F5F8)),
    this.descriptionTextStyle = const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF6F5F8)),
    this.backgroundColor = const Color(0xFF064EFF),
    this.toolTipPosition = TooltipPosition.bottom,
    this.arrowLeftPadding = 259 / 2,
  });
}

class AppointmentCardStyle {
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final TextStyle priceTextStyle;
  final TextStyle timeStyle;
  final Decoration timeDecoration;
  final Decoration cardDecoration;
  final double width;
  final double height;
  final double timeCardWidth;
  final double timeCardHeight;
  final EdgeInsets padding;
  final TextStyle dateTimeStyle;

  const AppointmentCardStyle({
    this.titleTextStyle = const TextStyle(
      color: Color(0xFFF6F5F8),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    this.descriptionTextStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Color(0xFFACACAC),
    ),
    this.priceTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color(0xFFF6F5F8),
    ),
    this.timeStyle = const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: Color(0xFF0A0A0A),
    ),
    this.timeDecoration = const BoxDecoration(
      color: Color(0xFFEFD23C),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    this.cardDecoration = const BoxDecoration(
      color: Color(0xFF323137),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    this.width = 289,
    this.height = 126,
    this.timeCardWidth = 58,
    this.timeCardHeight = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.dateTimeStyle = const TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    ),
  });
}

class NoAppointmentsCardStyle {
  final String title;
  final String description;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final Widget icon;

  const NoAppointmentsCardStyle({
    this.title = 'Записей нет',
    this.description = 'Вы не записаны ни на один сеанс \nна этот день',
    this.titleTextStyle = const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: Color(0xFFF6F5F8),
    ),
    this.descriptionTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFFF6F5F8),
    ),
    this.icon = const Icon(
      Icons.calendar_today,
      size: 84,
      color: Color(0xFF323137),
    ),
  });
}
