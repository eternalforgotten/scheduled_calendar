import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/enums.dart';

class DefaultMonthNameView extends StatelessWidget {
  final Month month;
  final int year;
  final TextStyle monthNameTextStyle;
  final MonthDisplay monthNameDisplay;

  const DefaultMonthNameView({
    super.key,
    required this.month,
    required this.year,
    required this.monthNameTextStyle,
    required this.monthNameDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat(monthNameDisplay == MonthDisplay.full ? 'MMMM' : 'MMM').format(
        DateTime(
          month.year,
          month.month,
          1,
        ),
      ),
      style: monthNameTextStyle,
    );
  }
}
