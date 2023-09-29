import 'package:flutter/material.dart';

class AppointmentNumberBadge extends StatelessWidget {
  final double width;
  final double height;
  final int appointmentNumber; // количество записей в день
  final Decoration badgeDecoration; // стиль фона
  final TextStyle numberTextStyle; // стиль текста
  const AppointmentNumberBadge({
    super.key,
    required this.width,
    required this.height,
    required this.appointmentNumber,
    required this.badgeDecoration,
    required this.numberTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}