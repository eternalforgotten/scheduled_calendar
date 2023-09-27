import 'package:flutter/material.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

class PagedVerticalCalenderPage extends StatelessWidget {
  const PagedVerticalCalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PagedVerticalCalendar(
          minDate: DateTime(2023, 3, 1),
          maxDate: DateTime(2023, 4, 16),
          initialDate: DateTime(2023, 3, 3),
        ),
      ),
    );
  }
}
