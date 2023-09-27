import 'package:calendar_builder/calendar_builder.dart';
import 'package:flutter/material.dart';

class CalendarBuilderPage extends StatelessWidget {
  const CalendarBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CbMonthBuilder(
                monthCustomizer: MonthCustomizer(
                    monthButtonCustomizer: MonthButtonCustomizer(
                  colorOnSelected: Colors.white,
                  textStyleOnSelected: TextStyle(color: Colors.yellow),
                  borderColorOnEnabled: Colors.yellow,
                )),
                cbConfig: CbConfig(
                  startDate: DateTime(2023, 3, 1),
                  endDate: DateTime(2023, 4, 16),
                  selectedDate: DateTime(2023, 3, 3),
                  selectedYear: DateTime(2023),
                  weekStartsFrom: WeekStartsFrom.monday,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
