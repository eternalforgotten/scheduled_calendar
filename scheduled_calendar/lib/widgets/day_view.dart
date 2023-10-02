import 'package:flutter/widgets.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/widgets/badge_view.dart';

class DayView extends StatelessWidget {
  final DateTime day;
  final void Function(DateTime day)? onPressed;
  final bool
      isCalendarMode; // если режим календаря, а не расписания, будет виджет с числом записей
  final bool isHoliday; // является ли день календарным выходным
  final bool isPerformerWorkDay; // является ли день рабочим днём исполнителя
  final Widget appointmentNumberBadge; // виджет для количества записей
  final ScheduledCalendarDayStyle style;
  const DayView(
    this.day, {
    super.key,
    required this.onPressed,
    this.isCalendarMode = false,
    this.isHoliday = false,
    this.isPerformerWorkDay = false,
    this.appointmentNumberBadge = const BadgeView(3),
    this.style = const ScheduledCalendarDayStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed?.call(day),
      child: Container(
        decoration: style.selectedDayDecoration,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.5),
              decoration:
                  isPerformerWorkDay ? style.performerWorkDayDecoration : null,
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: isHoliday
                      ? style.holidayTextStyle
                      : style.workDayTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            isCalendarMode
                ? appointmentNumberBadge
                : Text(
                    isPerformerWorkDay
                        ? style.workDayInscription ?? ''
                        : style.holidayInscription ?? '',
                    style: style.inscriptionTextStyle,
                  ),
          ],
        ),
      ),
    );
  }
}
