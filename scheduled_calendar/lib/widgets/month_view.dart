import 'package:flutter/material.dart' hide DateUtils;
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/enums.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/utils/typedefs.dart';
import 'package:scheduled_calendar/widgets/month_name_view.dart';
import 'package:scheduled_calendar/widgets/week_view.dart';
import 'package:scheduled_calendar/widgets/weeks_separator.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    super.key,
    required this.month,
    this.centerMonthName = false,
    this.weeksSeparator = const WeeksSeparator(),
    required this.startWeekWithSunday,
    this.monthNameBuilder,
    this.dayBuilder,
    this.minDate,
    this.maxDate,
    this.selectedDate,
    this.selectedDateCardBuilder,
    this.selectedDateCardAnimationCurve,
    this.selectedDateCardAnimationDuration,
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.onDayPressed,
    this.monthNameTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
    ),
    this.monthNameDisplay = MonthNameDisplay.full,
    this.displayYearInMonthName = false,
    this.monthNameLocale,
    this.isCalendarMode = false,
    this.appointmentBadgeStyle = const AppointmentBadgeStyle(),
    this.monthCustomNames = const {},
  });

  final Month month;
  final bool centerMonthName;
  final Widget weeksSeparator;
  final DateBuilder? dayBuilder;
  final bool startWeekWithSunday;
  final MonthNameBuilder? monthNameBuilder;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? selectedDate;
  final DateBuilder? selectedDateCardBuilder;
  final Duration? selectedDateCardAnimationDuration;
  final Curve? selectedDateCardAnimationCurve;
  final TextStyle monthNameTextStyle;
  final MonthNameDisplay monthNameDisplay;
  final bool displayYearInMonthName;
  final String? monthNameLocale;
  final ScheduledCalendarDayStyle dayStyle;
  final bool isCalendarMode;
  final AppointmentBadgeStyle appointmentBadgeStyle;
  final Map<int, String> monthCustomNames;
  final ValueChanged<DateTime?>? onDayPressed;

  @override
  Widget build(BuildContext context) {
    final weeksList = DateUtils.weeksList(
      month: month,
      minDate: minDate,
      maxDate: maxDate,
    );

    return Column(
      children: <Widget>[
        /// display the default month header if none is provided
        Row(
          mainAxisAlignment: centerMonthName
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            centerMonthName
                ? const SizedBox()
                : weeksList.first.first.weekday > 1
                    ? Spacer(
                        flex: weeksList.first.first.weekday - 1,
                      )
                    : const SizedBox(),
            Flexible(
              flex: centerMonthName ? 1 : weeksList.first.length,
              child: monthNameBuilder?.call(context, month.month, month.year) ??
                  MonthNameView(
                    month,
                    monthNameTextStyle: monthNameTextStyle,
                    monthNameDisplay: monthNameDisplay,
                    displayYear: displayYearInMonthName,
                    nameLocale: monthNameLocale,
                    monthCustomNames: monthCustomNames,
                  ),
            ),
          ],
        ),
        Column(
          children: [
            ...weeksList
                .map(
                  (week) => WeekView(
                    week,
                    weeksSeparator: weeksSeparator,
                    onDayPressed: onDayPressed,
                    selectedDate: selectedDate,
                    dayStyle: dayStyle,
                    appointmentBadgeStyle: appointmentBadgeStyle,
                    isCalendarMode: isCalendarMode,
                    selectedDateCardBuilder: selectedDateCardBuilder,
                    selectedDateCardAnimationCurve:
                        selectedDateCardAnimationCurve,
                    selectedDateCardAnimationDuration:
                        selectedDateCardAnimationDuration,
                  ),
                )
                .toList(),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
