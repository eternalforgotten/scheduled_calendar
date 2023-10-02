import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/enums.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/utils/typedefs.dart';
import 'package:scheduled_calendar/widgets/day_view.dart';
import 'package:scheduled_calendar/widgets/weeks_separator.dart';

class WeekView extends StatefulWidget {
  final List<DateTime> week;
  final DateTime? selectedDate;
  final Widget weeksSeparator;
  final DateCallback? onDayPressed;
  final DateBuilder? selectedDateCardBuilder;
  final Duration selectedDateCardAnimationDuration;
  final Curve selectedDateCardAnimationCurve;
  final ScheduledCalendarDayStyle dayStyle;
  final bool isCalendarMode;
  final AppointmentBadgeStyle appointmentBadgeStyle;
  final bool startWeekWithSunday;
  final bool isFirstWeek;
  final bool isLastWeek;
  const WeekView(
    this.week, {
    this.startWeekWithSunday = false,
    super.key,
    this.selectedDate,
    this.weeksSeparator = const WeeksSeparator(),
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.onDayPressed,
    this.isCalendarMode = false,
    this.appointmentBadgeStyle = const AppointmentBadgeStyle(),
    this.selectedDateCardBuilder,
    Duration? selectedDateCardAnimationDuration,
    Curve? selectedDateCardAnimationCurve,
    required this.isFirstWeek,
    required this.isLastWeek,
  })  : selectedDateCardAnimationCurve =
            selectedDateCardAnimationCurve ?? Curves.linear,
        selectedDateCardAnimationDuration = selectedDateCardAnimationDuration ??
            const Duration(milliseconds: 400);

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  DateTime? dateToDisplay;
  late AnimationController animationController;
  late CalendarInteraction interaction;

  @override
  void initState() {
    super.initState();
    interaction = context.read<CalendarState>().interaction;
    animationController = AnimationController(
      vsync: this,
      duration: widget.selectedDateCardAnimationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant WeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (interaction == CalendarInteraction.dateCard) {
      final date = widget.selectedDate;
      final oldDate = oldWidget.selectedDate;
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
                      onPressed: (date) {
                        if (interaction == CalendarInteraction.dateCard) {
                          final newSelectedDate = widget.selectedDate;
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
                      style: widget.dayStyle,
                      appointmentBadgeStyle: widget.appointmentBadgeStyle,
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
        widget.selectedDateCardBuilder != null
            ? SizeTransition(
                sizeFactor: CurvedAnimation(
                  curve: widget.selectedDateCardAnimationCurve,
                  parent: animationController,
                ),
                child: widget.selectedDateCardBuilder!(
                  context,
                  dateToDisplay ?? DateTime.now(),
                ),
              )
            : _DefaultDateCard(
                date: dateToDisplay ?? DateTime.now(),
                controller: animationController,
              ),
      ],
    );
  }
}

class _DefaultDateCard extends StatelessWidget {
  final DateTime date;
  final AnimationController controller;
  const _DefaultDateCard({
    required this.date,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: controller,
      child: Container(
        alignment: Alignment.center,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),
        child: Text(
          date.toString(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
