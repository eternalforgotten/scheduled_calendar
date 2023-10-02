import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/enums.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/utils/typedefs.dart';
import 'package:scheduled_calendar/widgets/badge_view.dart';
import 'package:scheduled_calendar/widgets/default_day_view.dart';

class WeekView extends StatefulWidget {
  final DateTime? selectedDate;
  final List<DateTime> week;
  final Widget weeksSeparator;
  final DateCallback? onDayPressed;
  final DateBuilder? selectedDateCardBuilder;
  final Duration selectedDateCardAnimationDuration;
  final Curve selectedDateCardAnimationCurve;
  const WeekView(
    this.week, {
    super.key,
    required this.weeksSeparator,
    this.onDayPressed,
    this.selectedDate,
    this.selectedDateCardBuilder,
    Duration? selectedDateCardAnimationDuration,
    Curve? selectedDateCardAnimationCurve,
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
    return Column(
      children: [
        Row(
          children: [
            if (widget.week.first.weekday > 1)
              Spacer(
                flex: widget.week.first.weekday - 1,
              ),
            Flexible(
              flex: widget.week.length,
              child: widget.weeksSeparator,
            ),
            if (widget.week.last.weekday < 7)
              Spacer(
                flex: 7 - widget.week.last.weekday,
              ),
          ],
        ),
        Row(
          children: [
            if (widget.week.first.weekday > 1)
              Spacer(
                flex: widget.week.first.weekday - 1,
              ),
            ...widget.week
                .map(
                  (date) => Flexible(
                    child: DefaultDayView(
                      day: date,
                      onPressed: (date) {
                        if (interaction == CalendarInteraction.dateCard) {
                          final newSelectedDate = widget.selectedDate;
                          if (newSelectedDate != null &&
                              date.isSameDay(newSelectedDate)) {
                            widget.onDayPressed?.call(null);
                          } else {
                            widget.onDayPressed?.call(date);
                          }
                        }
                        else {
                          widget.onDayPressed?.call(date);
                        }
                      },
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
            if (widget.week.last.weekday < 7)
              Spacer(
                flex: 7 - widget.week.last.weekday,
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
    super.key,
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
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
