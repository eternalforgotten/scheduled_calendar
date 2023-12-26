import 'package:example/widgets/performer_card.dart';
import 'package:example/widgets/schedule_inscription.dart';
import 'package:flutter/material.dart';
import 'package:scheduled_calendar/scheduled_calendar.dart';

class HorizontalCalendarPage extends StatefulWidget {
  final DateTime? focusedDate;

  const HorizontalCalendarPage({super.key, this.focusedDate});

  @override
  State<HorizontalCalendarPage> createState() => _HorizontalCalendarPageState();
}

class _HorizontalCalendarPageState extends State<HorizontalCalendarPage> {
  late DateTime? focusedDate;

  @override
  void initState() {
    focusedDate = widget.focusedDate;
    super.initState();
  }

  void _changeCalendarMode() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        centerTitle: true,
        title: const Text(
          'Расписание',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          FloatingActionButton(
            heroTag: 'mode',
            onPressed: _changeCalendarMode,
            backgroundColor: Colors.amber,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                focusedDate = DateTime(2023, 11, 14);
              });
            },
            child: const Text('Сегодня'),
          ),
        ],
      ),
      body: Center(
        child: HorizontalScheduledCalendar(
          interaction: CalendarInteraction.dateCard,
          minDate: DateTime(2023, 11, 14),
          maxDate: DateTime(2024, 1, 25),
          initialDate: DateTime(2023, 12, 14),
          monthNameStyle: const ScheduleCalendarMonthNameStyle(
            centerMonthName: true,
            monthCustomNames: {
              1: 'Янв.',
              2: 'Фев.',
              3: 'Мар.',
              4: 'Апр.',
              5: 'Май',
              6: 'Июн.',
              7: 'Июл.',
              8: 'Авг.',
              9: 'Сен.',
              10: 'Окт.',
              11: 'Ноя.',
              12: 'Дек.',
            },
          ),
          calendarFooter: ScheduleInscription(DateTime(2023, 9, 11)),
          focusedDateCardAnimationCurve: Curves.easeInOutBack,
          focusedDateCardAnimationDuration: const Duration(milliseconds: 300),
          dayFooterBuilder: (_, date) => const Text(
            'Вых',
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
          focusedDateCardBuilder: (_, date) => PerformerCard(
            date,
            initialPeriods: const [],
            onPerformerCardButtonPressed: (_) {},
          ),
          dayStyle: const ScheduledCalendarDayStyle(
            focusedDayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 1, color: Colors.red),
              ),
            ),
            focusedDayTextStyle: TextStyle(
              color: Colors.red,
            ),
            currentDayTextStyle: TextStyle(
              color: Colors.yellowAccent,
            ),
          ),
          dayFooterPadding: 5,
          firstWeekSeparator: null,
          focusedDate: focusedDate,
        ),
      ),
    );
  }
}
