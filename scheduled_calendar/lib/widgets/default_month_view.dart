import 'package:flutter/material.dart';
import 'package:scheduled_calendar/utils/enums.dart';

class DefaultMonthNameView extends StatelessWidget {
  final int month;
  final int year;
  final TextStyle monthNameTextStyle;
  final MonthDisplay monthNameDisplay;

  DefaultMonthNameView({
    super.key,
    required this.month,
    required this.year,
    required this.monthNameTextStyle,
    required this.monthNameDisplay,
  });

  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Text(
      months[month - 1],
      style: monthNameTextStyle,
    );
  }
}
