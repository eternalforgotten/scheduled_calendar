import 'package:flutter/material.dart';
import 'package:scheduled_calendar/utils/styles.dart';

class BadgeView extends StatelessWidget {
  /// Appointments number in the day
  final int appointmentNumber;
  final AppointmentBadgeStyle style;

  const BadgeView(
    this.appointmentNumber, {
    super.key,
    this.style = const AppointmentBadgeStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return appointmentNumber == 0
        ? const SizedBox()
        : Container(
            width: style.width,
            height: style.height,
            decoration: style.badgeDecoration,
            child: Center(
              child: Text(
                appointmentNumber.toString(),
                style: style.numberTextStyle,
              ),
            ),
          );
  }
}
