import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../calendar_state/calendar_state.dart';
import '../utils/date_utils.dart';
import '../utils/enums.dart';
import '../utils/styles.dart';
import '../utils/typedefs.dart';

class DayView extends StatefulWidget {
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
  final bool isHorizontalCalendar;
  final bool displayWeekdays;
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
    required this.isHorizontalCalendar,
    required this.displayWeekdays,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.style.weekdayLocale ?? Platform.localeName;
    final state = context.read<CalendarState>();
    final selectedInSelectionMode =
        state.dateInSelectedList(widget.day) != null;
    final focused =
        state.focusedDate != null && state.focusedDate!.isSameDay(widget.day);
    final isToday = widget.day.isSameDay(DateTime.now());
    BoxDecoration? highlightedDayDecoration;
    BoxDecoration? horizontalHighlightedDayDecoration;
    TextStyle? textStyle;
    if (widget.isHorizontalCalendar) {
      highlightedDayDecoration = const BoxDecoration();
      if (focused) {
        horizontalHighlightedDayDecoration =
            widget.style.horizontalFocusedDayDecoration;
      }
    } else {
      if (widget.interaction == CalendarInteraction.selection) {
        highlightedDayDecoration = selectedInSelectionMode
            ? widget.style.selectionModeActiveDecoration
            : widget.style.selectionModeInactiveDecoration;
        textStyle = selectedInSelectionMode
            ? widget.style.selectionModeActiveTextStyle
            : widget.style.selectionModeInactiveTextStyle;
      } else if (focused) {
        highlightedDayDecoration = widget.style.focusedDayDecoration;
        textStyle = widget.style.focusedDayTextStyle;
      } else if (isToday) {
        textStyle = widget.style.currentDayTextStyle;
      }
    }
    var weekdayName = widget.style.weekdayCustomNames[widget.day.weekday] ??
        DateFormat('E', locale).format(widget.day);
    return GestureDetector(
      onTap: () => widget.onPressed?.call(widget.day),
      child: Container(
        decoration: widget.isHorizontalCalendar
            ? horizontalHighlightedDayDecoration
            : null,
        child: Column(
          children: [
            if (widget.displayWeekdays)
              Text(
                weekdayName,
                style: widget.style.weekdayTextStyle,
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.5),
              decoration: highlightedDayDecoration ??
                  (widget.isPerformerWorkDay
                      ? widget.style.performerWorkDayDecoration
                      : widget.style.defaultWorkDayDecoration),
              child: Center(
                child: Text(
                  widget.day.day.toString(),
                  style: textStyle ??
                      (widget.isDayOff
                          ? widget.style.dayOffTextStyle
                          : widget.style.workDayTextStyle),
                ),
              ),
            ),
            if (widget.dayFooterBuilder != null) ...[
              const SizedBox(height: 5),
              widget.dayFooterBuilder!(context, widget.day),
              const SizedBox(height: 3),
            ],
          ],
        ),
      ),
    );
  }
}