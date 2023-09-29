import 'package:flutter/material.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/widgets/badge_widget.dart';
import 'package:scheduled_calendar/widgets/default_day_view.dart';

class WeekView extends StatelessWidget {
  final List<DateTime> week;
  final Widget weeksSeparator;
  const WeekView(this.week, {super.key, required this.weeksSeparator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (week.first.weekday > 1)
              Spacer(
                flex: week.first.weekday - 1,
              ),
            Flexible(
              flex: week.length,
              child: weeksSeparator,
            ),
            if (week.last.weekday < 7)
              Spacer(
                flex: 7 - week.last.weekday,
              ),
          ],
        ),
        Row(
          children: [
            if (week.first.weekday > 1)
              Spacer(
                flex: week.first.weekday - 1,
              ),
            ...week
                .map(
                  (date) => Flexible(
                    child: DefaultDayView(
                      day: date,
                      onPressed: (DateTime day) {},
                      isCalendarMode: false,
                      isHoliday: date.weekday == DateTime.saturday ||
                          date.weekday == DateTime.sunday,
                      isPerformerWorkDay: date.month == 3 &&
                          (date.day == 1 ||
                              date.day == 1 ||
                              date.day == 2 ||
                              date.day == 3 ||
                              date.day == 4 ||
                              date.day == 5 ||
                              date.day == 6 ||
                              date.day == 7 ||
                              date.day == 8),
                      style: ScheduledCalendarDayStyle(
                        width: null,
                        height: null,
                        padding: const EdgeInsets.all(8),
                        inscriptionTextStyle: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5C5B5F),
                        ),
                        currentDayTextStyle: const TextStyle(),
                        workDayTextStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        workDayInscription: 'Раб.',
                        holidayTextStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5C5B5F),
                        ),
                        holidayInscription: 'Вых.',
                        focusedDayTextStyle: const TextStyle(),
                        focusedDayDecoration: const BoxDecoration(),
                        performerWorkDayDecoration: const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 1,
                              color: Color(0xFF5C5B5F),
                            ),
                          ),
                          shape: BoxShape.circle,
                        ),
                        performerWorkDayInscription:
                            'performerWorkDayInscription',
                        selectionModeTextStyle: const TextStyle(),
                        selectionModeDecoration: const BoxDecoration(),
                        selectedDayTextStyle: const TextStyle(),
                        selectedDayDecoration: const BoxDecoration(),
                        appointmentNumberBadge: const AppointmentNumberBadge(
                          width: 10,
                          height: 10,
                          appointmentNumber: 3,
                          badgeDecoration: BoxDecoration(),
                          numberTextStyle: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            if (week.last.weekday < 7)
              Spacer(
                flex: 7 - week.last.weekday,
              ),
          ],
        ),
      ],
    );
  }
}
