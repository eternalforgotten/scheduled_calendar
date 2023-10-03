import 'package:flutter/widgets.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/widgets/badge_view.dart';

class DayView extends StatelessWidget {
  final DateTime day;
  final void Function(DateTime day)? onPressed;
  final bool
      isCalendarMode;
      /// Is the day the calendar holiday
       final bool isDayOff;
       /// Is the day the performer work day
  final bool isPerformerWorkDay;
  /// Widget for displaying of the appointments number
  final AppointmentBadgeStyle
      appointmentBadgeStyle;
  final ScheduledCalendarDayStyle style;
  const DayView(
    this.day, {
    super.key,
    required this.onPressed,
    this.isCalendarMode = false,
    this.isDayOff = false,
    this.isPerformerWorkDay = false,
    this.appointmentBadgeStyle = const AppointmentBadgeStyle(),
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
                  style: isDayOff
                      ? style.dayOffTextStyle
                      : style.workDayTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 5),
            isCalendarMode
                ? BadgeView(
                    3,
                    style: appointmentBadgeStyle,
                  )
                : Text(
                    isPerformerWorkDay
                        ? style.workDayInscription ?? ''
                        : style.dayOffInscription ?? '',
                    style: style.inscriptionTextStyle,
                  ),
          ],
        ),
      ),
    );
  }
}
