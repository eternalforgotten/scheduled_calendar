import 'package:flutter/material.dart';
import 'package:scheduled_calendar/src/utils/date_utils.dart';
import 'package:scheduled_calendar/src/utils/enums.dart';
import 'package:scheduled_calendar/src/utils/styles.dart';
import 'package:scheduled_calendar/src/utils/typedefs.dart';
import 'package:scheduled_calendar/src/widgets/day_view.dart';
import 'package:scheduled_calendar/src/widgets/weeks_separator.dart';

class WeekView extends StatefulWidget {
  final List<DateTime> week;
  final DateTime? focusedDate;
  final Widget weeksSeparator;
  final DateCallback? onDayPressed;
  final DateBuilder? focusedDateCardBuilder;
  final Duration focusedDateCardAnimationDuration;
  final Curve focusedDateCardAnimationCurve;
  final ScheduledCalendarDayStyle dayStyle;
  final bool isCalendarMode;
  final bool startWeekWithSunday;
  final bool isFirstWeek;
  final bool isLastWeek;
  final List<int> daysOff;
  final String? locale;
  final CalendarInteraction interaction;
  final DateBuilder? dayFooterBuilder;
  final bool isHorizontalCalendar;
  final bool Function(DateTime)? isWorkDay;
  const WeekView(
    this.week, {
    this.startWeekWithSunday = false,
    super.key,
    this.focusedDate,
    this.weeksSeparator = const WeeksSeparator(),
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.onDayPressed,
    this.isCalendarMode = false,
    this.focusedDateCardBuilder,
    Duration? selectedDateCardAnimationDuration,
    Curve? selectedDateCardAnimationCurve,
    required this.isFirstWeek,
    required this.isLastWeek,
    required this.daysOff,
    this.locale,
    required this.interaction,
    required this.dayFooterBuilder,
    this.isHorizontalCalendar = false,
    this.isWorkDay,
  })  : focusedDateCardAnimationCurve =
            selectedDateCardAnimationCurve ?? Curves.linear,
        focusedDateCardAnimationDuration = selectedDateCardAnimationDuration ??
            const Duration(milliseconds: 400);

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  DateTime? dateToDisplay;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.focusedDateCardAnimationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant WeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interaction == CalendarInteraction.dateCard) {
      final date = widget.focusedDate;
      final oldDate = oldWidget.focusedDate;
      if (date != null) {
        final dateInWeek = date.isSameDayOrAfter(widget.week.first) &&
            date.isSameDayOrBefore(widget.week.last);
        if (dateInWeek) {
          dateToDisplay = date;
          _expand();
        } else {
          dateToDisplay = oldDate;
          _collapse();
        }
      } else {
        if (oldDate != null) {
          dateToDisplay = oldDate;
          _collapse();
        }
      }
    }
  }

  void _expand() {
    if (!animationController.isCompleted) {
      animationController.forward();
    }
  }

  void _collapse() {
    if (animationController.isCompleted) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastWeek = widget.isLastWeek;
    final isFirstWeek = widget.isFirstWeek;
    final week = widget.week;
    return Column(
      children: [
        if (!widget.isHorizontalCalendar)
          Row(
            children: [
              if (isFirstWeek && week.length < 7)
                Spacer(
                  flex: 7 - week.length,
                ),
              Flexible(
                flex: week.length,
                child: widget.weeksSeparator,
              ),
              if (isLastWeek && week.length < 7)
                Spacer(
                  flex: 7 - week.length,
                ),
            ],
          ),
        Row(
          children: [
            if (isFirstWeek && week.length < 7)
              Spacer(
                flex: 7 - week.length,
              ),
            ...widget.week
                .map(
                  (date) => Flexible(
                    child: DayView(
                      date,
                      interaction: widget.interaction,
                      onPressed: (date) {
                        if (widget.interaction ==
                            CalendarInteraction.dateCard) {
                          final newSelectedDate = widget.focusedDate;
                          if (newSelectedDate != null &&
                              date.isSameDay(newSelectedDate)) {
                            widget.onDayPressed?.call(null);
                          } else {
                            widget.onDayPressed?.call(date);
                          }
                        } else {
                          widget.onDayPressed?.call(date);
                        }
                      },
                      isCalendarMode: widget.isCalendarMode,
                      isDayOff: widget.daysOff.any(
                        (day) => date.weekday == day,
                      ),
                      isPerformerWorkDay: widget.isWorkDay?.call(date) ?? false,
                      style: widget.dayStyle,
                      dayFooterBuilder: widget.dayFooterBuilder,
                      isHorizontalCalendar: widget.isHorizontalCalendar,
                    ),
                  ),
                )
                .toList(),
            if (isLastWeek && week.length < 7)
              Spacer(
                flex: 7 - week.length,
              ),
          ],
        ),
        if (widget.focusedDateCardBuilder != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                curve: widget.focusedDateCardAnimationCurve,
                parent: animationController,
              ),
              child: widget.focusedDateCardBuilder!(
                context,
                dateToDisplay ?? DateTime.now(),
              ),
            ),
          ),
      ],
    );
  }
}
