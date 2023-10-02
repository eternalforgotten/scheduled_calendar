import 'package:flutter/material.dart';

class BadgeView extends StatelessWidget {
  final int appointmentNumber; // количество записей в день
  final double width;
  final double height;
  final Decoration badgeDecoration; // стиль фона
  final TextStyle numberTextStyle; // стиль текста
  const BadgeView({
    super.key,
    required this.appointmentNumber,
    this.width = 16,
    this.height = 16,
    this.badgeDecoration = const BoxDecoration(
      color: Color(0xFFEFD23C),
      shape: BoxShape.circle,
    ),
    this.numberTextStyle = const TextStyle(fontSize: 10),
  });

  @override
  Widget build(BuildContext context) {
    return appointmentNumber == 0
        ? const SizedBox()
        : Container(
            width: width,
            height: height,
            decoration: badgeDecoration,
            child: Center(
              child: Text(
                appointmentNumber.toString(),
                style: numberTextStyle,
              ),
            ),
          );
  }
}
