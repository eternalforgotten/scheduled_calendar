import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/scheduled_calendar.dart';
import 'package:scheduled_calendar/src/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/src/utils/date_utils.dart';
import 'package:scheduled_calendar/src/widgets/day_view.dart';
import 'package:scheduled_calendar/src/widgets/weeks_separator.dart';

class WeekView extends StatefulWidget {
  final List<DateTime> week;
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
  final bool displayWeekdays;
  final double dayFooterPadding;
  final Widget firstWeekSeparator;
  final double weekdayPadding;
  const WeekView(
    this.week, {
    this.startWeekWithSunday = false,
    super.key,
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
    required this.displayWeekdays,
    required this.dayFooterPadding,
    required this.firstWeekSeparator,
    this.weekdayPadding = 3,
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
  late CalendarState state;

  @override
  void initState() {
    super.initState();
    state = context.read<CalendarState>();
    animationController = AnimationController(
      vsync: this,
      duration: widget.focusedDateCardAnimationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant WeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interaction != CalendarInteraction.action) {
      final focusedDate = state.focusedDate;
      if (focusedDate != null) {
        final dateInWeek = focusedDate.isSameDayOrAfter(widget.week.first) &&
            focusedDate.isSameDayOrBefore(widget.week.last);
        if (dateInWeek) {
          dateToDisplay = focusedDate;
          _expand();
        } else {
          dateToDisplay = state.previousFocusedDate;
          _collapse();
        }
      } else {
        dateToDisplay = state.previousFocusedDate;
        _collapse();
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
              if (isFirstWeek && !isLastWeek && week.length < 7)
                Spacer(
                  flex: 7 - week.length,
                ),
              if (isFirstWeek && isLastWeek && week.length < 7)
                Spacer(
                  flex: week.first.weekday - 1,
                ),
              Flexible(
                flex: week.length,
                child: isFirstWeek
                    ? widget.firstWeekSeparator
                    : widget.weeksSeparator,
              ),
              if (isFirstWeek && isLastWeek && week.length < 7)
                Spacer(
                  flex: 7 - week.last.weekday,
                ),
              if (isLastWeek && !isFirstWeek && week.length < 7)
                Spacer(
                  flex: 7 - week.length,
                ),
            ],
          ),
        Row(
          children: [
            if (isFirstWeek && !isLastWeek && week.length < 7)
              Spacer(
                flex: 7 - week.length,
              ),
            if (!widget.isHorizontalCalendar &&
                isFirstWeek &&
                isLastWeek &&
                week.length < 7)
              Spacer(
                flex: week.first.weekday - 1,
              ),
            ...week
                .map(
                  (date) => Flexible(
                    child: DayView(
                      date,
                      interaction: widget.interaction,
                      onPressed: (date, offset) {
                        if (widget.interaction ==
                            CalendarInteraction.dateCard) {
                          final newSelectedDate = state.focusedDate;
                          if (newSelectedDate != null &&
                              date.isSameDay(newSelectedDate)) {
                            widget.onDayPressed?.call(null);
                          } else {
                            final controller =
                                ScheduledCalendar.controllerOf(context);
                            widget.onDayPressed?.call(date);
                            final box = (cardKey.currentContext
                                ?.findRenderObject()) as RenderBox?;
                            if (box != null && controller != null) {
                              final boxHeight = box.size.height;
                              final diff = offset.dy +
                                  boxHeight -
                                  MediaQuery.of(context).size.height;
                              if (diff > 0) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  final targetPosition =
                                      controller.position.pixels + diff + 50;
                                  final maxExtent =
                                      controller.position.maxScrollExtent;
                                  if (targetPosition > maxExtent) {
                                    controller.position
                                        .correctPixels(targetPosition + 100);
                                  } else {
                                    controller.animateTo(
                                      targetPosition,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                  }
                                });
                              }
                            }
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
                      displayWeekdays: widget.displayWeekdays,
                      dayFooterPadding: widget.dayFooterPadding,
                      weekdayPadding: widget.weekdayPadding,
                    ),
                  ),
                )
                .toList(),
            if (!widget.isHorizontalCalendar &&
                isFirstWeek &&
                isLastWeek &&
                week.length < 7)
              Spacer(
                flex: 7 - week.last.weekday,
              ),
            if (isLastWeek && !isFirstWeek && week.length < 7)
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
              child: FocusedCardContent(
                key: cardKey,
                child: widget.focusedDateCardBuilder!(
                  context,
                  dateToDisplay ?? DateTime.now(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  GlobalKey cardKey = GlobalKey();
}

class FocusedCardContent extends StatelessWidget {
  final Widget child;
  const FocusedCardContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
