import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/utils/enums.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/widgets/badge_view.dart';

class DayView extends StatelessWidget {
  final DateTime day;
  final void Function(DateTime day)? onPressed;
  final bool isCalendarMode;

  /// Is the day the calendar holiday
  final bool isDayOff;

  /// Is the day the performer work day
  final bool isPerformerWorkDay;

  /// Widget for displaying of the appointments number
  final AppointmentBadgeStyle appointmentBadgeStyle;
  final ScheduledCalendarDayStyle style;
  final CalendarInteraction interaction;
  const DayView(
    this.day, {
    super.key,
    required this.onPressed,
    this.isCalendarMode = false,
    this.isDayOff = false,
    this.isPerformerWorkDay = false,
    this.appointmentBadgeStyle = const AppointmentBadgeStyle(),
    this.style = const ScheduledCalendarDayStyle(),
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<CalendarState>();
    final selected = state.dateInSelectedList(day) != null;
    BoxDecoration? dayDecoration;
    TextStyle? textStyle;
    if (interaction == CalendarInteraction.selection) {
      dayDecoration = selected
          ? style.selectionModeActiveDecoration
          : style.selectionModeInactiveDecoration;
      textStyle = selected
          ? style.selectionModeActiveTextStyle
          : style.selectionModeInactiveTextStyle;
    }
    return GestureDetector(
      onTap: () => onPressed?.call(day),

      //TODO: add decoration
      child: Container(
        decoration: null,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.5),
              decoration: dayDecoration ??
                  (isPerformerWorkDay
                      ? style.performerWorkDayDecoration
                      : null),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: textStyle ??
                      (isDayOff
                          ? style.dayOffTextStyle
                          : style.workDayTextStyle),
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
