import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/enums.dart';

class MonthNameView extends StatelessWidget {
  final Month month;
  final TextStyle monthNameTextStyle;
  final MonthDisplay monthNameDisplay;

  const MonthNameView({
    super.key,
    required this.month,
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
