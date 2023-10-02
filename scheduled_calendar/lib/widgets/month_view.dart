import 'package:flutter/material.dart' hide DateUtils;
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
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
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.onDayPressed,
  });

  final Month month;
  final bool
      centerMonthName; // расположить ли название месяца по центру, а не над началом недели
  final Widget weeksSeparator; // разделитель между неделями
  final bool
      startWeekWithSunday; // начинать ли неделю с воскресенья, а не с понедельника
  final MonthNameBuilder?
      monthNameBuilder; // билдер кастомного виджета для названия месяца
  final DayBuilder? dayBuilder; // билдер кастомного виджета для дня
  final DateTime? minDate; // дата начала периода
  final DateTime? maxDate; // дата конца периода
  final DateTime? selectedDate; // выбранная дата
  final ScheduledCalendarDayStyle dayStyle;
  final ValueChanged<DateTime?>?
      onDayPressed; // тип действия при нажатии на день

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
                  MonthNameView(month),
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
