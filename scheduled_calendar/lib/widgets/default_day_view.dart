import 'package:flutter/widgets.dart';
import 'package:scheduled_calendar/utils/styles.dart';

class DefaultDayView extends StatelessWidget {
  final DateTime day;
  final void Function(DateTime day)? onPressed;
  final bool
      isCalendarMode; // Если режим календаря, а не расписания, будет виджет с числом записей
  final bool isHoliday;
  final bool isPerformerWorkDay;
  final ScheduledCalendarDayStyle style;
  const DefaultDayView({
    super.key,
    required this.day,
    required this.onPressed,
    required this.isCalendarMode,
    required this.isHoliday,
    required this.isPerformerWorkDay,
    required this.style,
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
                  style:
                      isHoliday ? style.holidayTextStyle : style.workDayTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            isCalendarMode
                ? style.appointmentNumberBadge
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
