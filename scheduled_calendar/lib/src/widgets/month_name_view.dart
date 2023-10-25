import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scheduled_calendar/scheduled_calendar.dart';
import 'package:scheduled_calendar/src/utils/date_models.dart';

class MonthNameView extends StatefulWidget {
  final Month month;
  final ScheduleCalendarMonthNameStyle monthNameStyle;

  const MonthNameView(
    this.month, {
    super.key,
    required this.monthNameStyle,
  });

  @override
  State<MonthNameView> createState() => _MonthNameViewState();
}

class _MonthNameViewState extends State<MonthNameView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final monthNameStyle = widget.monthNameStyle;
    final locale = monthNameStyle.monthNameLocale ?? Platform.localeName;
    var date = monthNameStyle.monthCustomNames[widget.month.month] ??
        DateFormat(
          (monthNameStyle.monthNameDisplay == MonthNameDisplay.full
              ? monthNameStyle.displayYearInMonthName
                  ? 'MMMM y'
                  : 'MMMM'
              : monthNameStyle.displayYearInMonthName
                  ? 'MMM y'
                  : 'MMM'),
          locale,
        ).format(
          DateTime(
            widget.month.year,
            widget.month.month,
            1,
          ),
        );
    return Padding(
      padding:
          EdgeInsets.fromLTRB(monthNameStyle.monthNamePadding ?? 0, 0, 0, 0),
      child: Text(
        date,
        style: monthNameStyle.monthNameTextStyle,
      ),
    );
  }
}
