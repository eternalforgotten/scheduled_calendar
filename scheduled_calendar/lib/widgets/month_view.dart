import 'package:flutter/material.dart' hide DateUtils;
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/typedefs.dart';
import 'package:scheduled_calendar/widgets/month_name_view.dart';
import 'package:scheduled_calendar/widgets/week_view.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    super.key,
    required this.month,
    this.monthNameBuilder,
    required this.centerMonthName,
    required this.weeksSeparator,
    this.dayBuilder,
    this.onDayPressed,
    required this.weekDaysToHide,
    required this.startWeekWithSunday,
    this.minDate,
    this.maxDate,
    this.selectedDate,
  });

  final Month month;
  final MonthBuilder? monthNameBuilder;
  final bool centerMonthName;

  final Widget weeksSeparator;
  final DayBuilder? dayBuilder;
  final ValueChanged<DateTime?>? onDayPressed;
  final bool startWeekWithSunday;
  final List<int> weekDaysToHide;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final weeksList = DateUtils.weeksList(
      month: month,
      minDate: minDate,
      maxDate: maxDate,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
                child:
                    monthNameBuilder?.call(context, month.month, month.year) ??
                        MonthNameView(
                          month: month,
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
                    ),
                  )
                  .toList(),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
