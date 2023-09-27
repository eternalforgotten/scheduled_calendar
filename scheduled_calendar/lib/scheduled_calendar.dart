library scheduled_calendar;

import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduledCalendar extends StatefulWidget {
  const ScheduledCalendar({super.key});

  @override
  State<ScheduledCalendar> createState() => _ScheduledCalendarState();
}

class _ScheduledCalendarState extends State<ScheduledCalendar> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2023, 9, 25),
      lastDay: DateTime(2023, 10, 27),
    );
  }
}
