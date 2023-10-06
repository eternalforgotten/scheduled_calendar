import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/src/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/src/utils/date_utils.dart';
import 'package:scheduled_calendar/src/utils/enums.dart';
import 'package:scheduled_calendar/src/utils/styles.dart';
import 'package:scheduled_calendar/src/utils/typedefs.dart';

class DayView extends StatelessWidget {
  final DateTime day;
  final void Function(DateTime day)? onPressed;
  final bool isCalendarMode;
  final DateBuilder? dayFooterBuilder;

  /// Is the day the calendar holiday
  final bool isDayOff;

  /// Is the day the performer work day
  final bool isPerformerWorkDay;

  final ScheduledCalendarDayStyle style;
  final CalendarInteraction interaction;
  const DayView(
    this.day, {
    super.key,
    required this.onPressed,
    this.isCalendarMode = false,
    this.isDayOff = false,
    this.isPerformerWorkDay = false,
    this.style = const ScheduledCalendarDayStyle(),
    required this.interaction,
    required this.dayFooterBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<CalendarState>();
    final selectedInSelectionMode = state.dateInSelectedList(day) != null;
    final focused =
        state.focusedDate != null && state.focusedDate!.isSameDay(day);
    final isToday = day.isSameDay(DateTime.now());
    BoxDecoration? highlightedDayDecoration;
    TextStyle? textStyle;
    if (interaction == CalendarInteraction.selection) {
      highlightedDayDecoration = selectedInSelectionMode
          ? style.selectionModeActiveDecoration
          : style.selectionModeInactiveDecoration;
      textStyle = selectedInSelectionMode
          ? style.selectionModeActiveTextStyle
          : style.selectionModeInactiveTextStyle;
    } else if (focused) {
      highlightedDayDecoration = style.focusedDayDecoration;
      textStyle = style.focusedDayTextStyle;
    } else if (isToday) {
      textStyle = style.currentDayTextStyle;
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
              decoration: highlightedDayDecoration ??
                  (isPerformerWorkDay
                      ? style.performerWorkDayDecoration
                      : style.defaultWorkDayDecoration),
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
            if (dayFooterBuilder != null) ...[
              const SizedBox(height: 5),
              dayFooterBuilder!(context, day),
            ],
          ],
        ),
      ),
    );
  }
}
