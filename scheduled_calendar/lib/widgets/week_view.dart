import 'package:flutter/material.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/widgets/day_view.dart';
import 'package:scheduled_calendar/widgets/weeks_separator.dart';

class WeekView extends StatefulWidget {
  final List<DateTime> week;
  final DateTime? selectedDate;
  final Widget weeksSeparator;
  final ScheduledCalendarDayStyle dayStyle;
  final void Function(DateTime?)? onDayPressed;
  const WeekView(
    this.week, {
    super.key,
    this.selectedDate,
    this.weeksSeparator = const WeeksSeparator(), // разделитель между неделями
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.onDayPressed,
  });

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  bool expanded = false;
  DateTime? dateToDisplay;
  @override
  void didUpdateWidget(covariant WeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  void _expand() {
    setState(() {
      expanded = true;
    });
  }

  void _collapse() {
    setState(() {
      expanded = false;
    });
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
                    child: DayView(
                      date,
                      onPressed: (date) {
                        final newSelectedDate = widget.selectedDate;
                        if (newSelectedDate != null &&
                            date.isSameDay(newSelectedDate)) {
                          widget.onDayPressed?.call(null);
                        } else {
                          widget.onDayPressed?.call(date);
                        }
                      },
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
        _DateCard(
          expanded: expanded,
          date: dateToDisplay,
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  final DateTime? date;
  final bool expanded;
  const _DateCard({
    super.key,
    required this.date,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      alignment: Alignment.center,
      height: expanded ? 100 : 0,
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
    );
  }
}
