library scheduled_calendar;

import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/rendering.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';

/// enum indicating the pagination enpoint direction
enum PaginationDirection {
  up,
  down,
}

/// a minimalistic paginated calendar widget providing infinite customisation
/// options and usefull paginated callbacks. all paremeters are optional.
///
/// ```
/// PagedVerticalCalendar(
///       startDate: DateTime(2021, 1, 1),
///       endDate: DateTime(2021, 12, 31),
///       onDayPressed: (day) {
///            print('Date selected: $day');
///          },
///          onMonthLoaded: (year, month) {
///            print('month loaded: $month-$year');
///          },
///          onPaginationCompleted: () {
///            print('end reached');
///          },
///        ),
/// ```
class ScheduledCalendar extends StatefulWidget {
  ScheduledCalendar({
    this.minDate,
    this.maxDate,
    DateTime? initialDate,
    this.monthBuilder,
    this.dayBuilder,
    this.addAutomaticKeepAlives = false,
    this.onDayPressed,
    this.onMonthLoaded,
    this.onPaginationCompleted,
    this.invisibleMonthsThreshold = 1,
    this.physics,
    this.scrollController,
    this.listPadding = EdgeInsets.zero,
    this.startWeekWithSunday = false,
    this.weekdaysToHide = const [],
  }) : this.initialDate = initialDate ?? DateTime.now().removeTime();

  /// the [DateTime] to start the calendar from, if no [startDate] is provided
  /// `DateTime.now()` will be used
  final DateTime? minDate;

  /// optional [DateTime] to end the calendar pagination, of no [endDate] is
  /// provided the calendar can paginate indefinitely
  final DateTime? maxDate;

  /// the initial date displayed by the calendar.
  /// if inititial date is nulll, the start date will be used
  final DateTime initialDate;

  /// a Builder used for month header generation. a default [MonthBuilder] is
  /// used when no custom [MonthBuilder] is provided.
  /// * [context]
  /// * [int] year: 2021
  /// * [int] month: 1-12
  final MonthBuilder? monthBuilder;

  /// a Builder used for day generation. a default [DayBuilder] is
  /// used when no custom [DayBuilder] is provided.
  /// * [context]
  /// * [DateTime] date
  final DayBuilder? dayBuilder;

  /// if the calendar should stay cached when the widget is no longer loaded.
  /// this can be used for maintaining the last state. defaults to `false`
  final bool addAutomaticKeepAlives;

  /// callback that provides the [DateTime] of the day that's been interacted
  /// with
  final ValueChanged<DateTime>? onDayPressed;

  /// callback when a new paginated month is loaded.
  final OnMonthLoaded? onMonthLoaded;

  /// called when the calendar pagination is completed. if no [minDate] or [maxDate] is
  /// provided this method is never called for that direction
  final ValueChanged<PaginationDirection>? onPaginationCompleted;

  /// how many months should be loaded outside of the view. defaults to `1`
  final int invisibleMonthsThreshold;

  /// list padding, defaults to `0`
  final EdgeInsets listPadding;

  /// scroll physics, defaults to matching platform conventions
  final ScrollPhysics? physics;

  /// scroll controller for making programmable scroll interactions
  final ScrollController? scrollController;

  /// Select start day of the week to be Sunday
  final bool startWeekWithSunday;

  /// Hide certain Weekdays eg.Weekends by providing
  /// `[DateTime.sunday,DateTime.monday]`. By default all weekdays are shown
  final List<int> weekdaysToHide;

  @override
  _ScheduledCalendarState createState() => _ScheduledCalendarState();
}

class _ScheduledCalendarState extends State<ScheduledCalendar> {
  late PagingController<int, Month> _pagingReplyUpController;
  late PagingController<int, Month> _pagingReplyDownController;

  final Key downListKey = UniqueKey();
  late bool hideUp;

  @override
  void initState() {
    super.initState();

    if (widget.minDate != null &&
        widget.initialDate.isBefore(widget.minDate!)) {
      throw ArgumentError("initialDate cannot be before minDate");
    }

    if (widget.maxDate != null && widget.initialDate.isAfter(widget.maxDate!)) {
      throw ArgumentError("initialDate cannot be after maxDate");
    }

    hideUp = !(widget.minDate == null ||
        !widget.minDate!.isSameMonth(widget.initialDate));

    _pagingReplyUpController = PagingController<int, Month>(
      firstPageKey: 0,
      invisibleItemsThreshold: widget.invisibleMonthsThreshold,
    );
    _pagingReplyUpController.addPageRequestListener(_fetchUpPage);
    _pagingReplyUpController.addStatusListener(paginationStatusUp);

    _pagingReplyDownController = PagingController<int, Month>(
      firstPageKey: 0,
      invisibleItemsThreshold: widget.invisibleMonthsThreshold,
    );
    _pagingReplyDownController.addPageRequestListener(_fetchDownPage);
    _pagingReplyDownController.addStatusListener(paginationStatusDown);
  }

  @override
  void didUpdateWidget(covariant ScheduledCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.minDate != oldWidget.minDate) {
      _pagingReplyUpController.refresh();

      hideUp = !(widget.minDate == null ||
          !widget.minDate!.isSameMonth(widget.initialDate));
    }
  }

  void paginationStatusUp(PagingStatus state) {
    if (state == PagingStatus.completed)
      return widget.onPaginationCompleted?.call(PaginationDirection.up);
  }

  void paginationStatusDown(PagingStatus state) {
    if (state == PagingStatus.completed)
      return widget.onPaginationCompleted?.call(PaginationDirection.down);
  }

  /// fetch a new [Month] object based on the [pageKey] which is the Nth month
  /// from the start date
  void _fetchUpPage(int pageKey) async {
    try {
      final month = DateUtils.getMonth(
        DateTime(widget.initialDate.year, widget.initialDate.month - 1, 1),
        widget.minDate,
        pageKey,
        true,
        startWeekWithSunday: widget.startWeekWithSunday,
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onMonthLoaded?.call(month.year, month.month),
      );

      final newItems = [month];
      final isLastPage = widget.minDate != null &&
          widget.minDate!.isSameDayOrAfter(month.weeks.first.firstDay);

      if (isLastPage) {
        return _pagingReplyUpController.appendLastPage(newItems);
      }

      final nextPageKey = pageKey + newItems.length;
      _pagingReplyUpController.appendPage(newItems, nextPageKey);
    } catch (_) {
      _pagingReplyUpController.error;
    }
  }

  void _fetchDownPage(int pageKey) async {
    try {
      final month = DateUtils.getMonth(
        widget.minDate ??
            DateTime(
              widget.initialDate.year,
              widget.initialDate.month,
              1,
            ),
        widget.maxDate,
        pageKey,
        false,
        startWeekWithSunday: widget.startWeekWithSunday,
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onMonthLoaded?.call(month.year, month.month),
      );

      final newItems = [month];
      final isLastPage = widget.maxDate != null &&
          widget.maxDate!.isSameDayOrBefore(month.weeks.last.lastDay);

      if (isLastPage) {
        return _pagingReplyDownController.appendLastPage(newItems);
      }

      final nextPageKey = pageKey + newItems.length;
      _pagingReplyDownController.appendPage(newItems, nextPageKey);
    } catch (_) {
      _pagingReplyDownController.error;
    }
  }

  EdgeInsets _getDownListPadding() {
    final double paddingTop = hideUp ? widget.listPadding.top : 0;
    return EdgeInsets.fromLTRB(widget.listPadding.left, paddingTop,
        widget.listPadding.right, widget.listPadding.bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: widget.scrollController,
      physics: widget.physics,
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          offset: position,
          center: downListKey,
          slivers: [
            if (!hideUp)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(widget.listPadding.left,
                    widget.listPadding.top, widget.listPadding.right, 0),
                sliver: PagedSliverList(
                  pagingController: _pagingReplyUpController,
                  builderDelegate: PagedChildBuilderDelegate<Month>(
                    itemBuilder:
                        (BuildContext context, Month month, int index) {
                      return _MonthView(
                        month: month,
                        monthNameBuilder: widget.monthBuilder,
                        centerMonthName: false,
                        dayBuilder: widget.dayBuilder,
                        onDayPressed: widget.onDayPressed,
                        startWeekWithSunday: widget.startWeekWithSunday,
                        weekDaysToHide: widget.weekdaysToHide,
                        weeksSeparator: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          height: 1,
                          color: const Color(0xFF5C5B5F),
                        ),
                      );
                    },
                  ),
                ),
              ),
            SliverPadding(
              key: downListKey,
              padding: _getDownListPadding(),
              sliver: PagedSliverList(
                pagingController: _pagingReplyDownController,
                builderDelegate: PagedChildBuilderDelegate<Month>(
                  itemBuilder: (BuildContext context, Month month, int index) {
                    return _MonthView(
                      month: month,
                      monthNameBuilder: widget.monthBuilder,
                      centerMonthName: false,
                      dayBuilder: widget.dayBuilder,
                      onDayPressed: widget.onDayPressed,
                      startWeekWithSunday: widget.startWeekWithSunday,
                      weekDaysToHide: widget.weekdaysToHide,
                      weeksSeparator: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 1,
                        color: const Color(0xFF5C5B5F),
                      ),
                      minDate: widget.minDate != null &&
                              widget.minDate!.month == month.month
                          ? widget.minDate
                          : DateTime(month.year, month.month, 1),
                      maxDate: widget.maxDate != null &&
                              widget.maxDate!.month == month.month
                          ? widget.maxDate
                          : DateTime(month.year, month.month + 1, -1),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pagingReplyUpController.dispose();
    _pagingReplyDownController.dispose();
    super.dispose();
  }
}

class _MonthView extends StatelessWidget {
  _MonthView({
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
  });

  final Month month;
  final MonthBuilder? monthNameBuilder;
  final bool centerMonthName;

  final Widget weeksSeparator;
  final DayBuilder? dayBuilder;
  final ValueChanged<DateTime>? onDayPressed;
  final bool startWeekWithSunday;
  final List<int> weekDaysToHide;
  final DateTime? minDate;
  final DateTime? maxDate;

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
                  : weeksList.first.first.weekday > 1 ? Spacer(
                      flex: weeksList.first.first.weekday - 1,
                    ) : const SizedBox(),
              Flexible(
                flex: centerMonthName ? 1 : weeksList.first.length,
                child:
                    monthNameBuilder?.call(context, month.month, month.year) ??
                        _DefaultMonthNameView(
                          month: month,
                          year: month.year,
                          monthNameTextStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEFD23C),
                          ),
                          monthNameDisplay: MonthDisplay.short,
                        ),
              ),
            ],
          ),
          Column(
            children: [
              ...weeksList
                  .map(
                    (week) => Column(
                      children: [
                        Row(
                          children: [
                            if (week.first.weekday > 1)
                              Spacer(
                                flex: week.first.weekday - 1,
                              ),
                            Flexible(
                              flex: week.length,
                              child: weeksSeparator,
                            ),
                            if (week.last.weekday < 7)
                              Spacer(
                                flex: 7 - week.last.weekday,
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (week.first.weekday > 1)
                              Spacer(
                                flex: week.first.weekday - 1,
                              ),
                            ...week
                                .map(
                                  (date) => Flexible(
                                    child: _DefaultDayView(
                                      day: date,
                                      onPressed: (DateTime day) {},
                                      isCalendarMode: false,
                                      isHoliday:
                                          date.weekday == DateTime.saturday ||
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
                                        focusedDayDecoration:
                                            const BoxDecoration(),
                                        performerWorkDayDecoration:
                                            const BoxDecoration(
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
                                        selectionModeTextStyle:
                                            const TextStyle(),
                                        selectionModeDecoration:
                                            const BoxDecoration(),
                                        selectedDayTextStyle: const TextStyle(),
                                        selectedDayDecoration:
                                            const BoxDecoration(),
                                        appointmentNumberBadge:
                                            const AppointmentNumberBadge(
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
                            if (week.last.weekday < 7)
                              Spacer(
                                flex: 7 - week.last.weekday,
                              ),
                          ],
                        ),
                      ],
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

class _DefaultMonthNameView extends StatelessWidget {
  final Month month;
  final int year;
  final TextStyle monthNameTextStyle;
  final MonthDisplay monthNameDisplay;

  _DefaultMonthNameView({
    required this.month,
    required this.year,
    required this.monthNameTextStyle,
    required this.monthNameDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat(monthNameDisplay == MonthDisplay.full ? 'MMMM' : 'MMM').format(
        DateTime(
          month.year,
          month.month,
          1,
        ),
      ),
      style: monthNameTextStyle,
    );
  }
}

class _DefaultDayView extends StatelessWidget {
  final DateTime day;
  final Function(DateTime day) onPressed;
  final bool
      isCalendarMode; // Если режим календаря, а не расписания, будет виджет с числом записей
  final bool isHoliday;
  final bool isPerformerWorkDay;
  final ScheduledCalendarDayStyle style;
  const _DefaultDayView({
    super.key,
    required this.day,
    required this.onPressed,
    required this.isCalendarMode,
    required this.isHoliday,
    required this.isPerformerWorkDay,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: style.selectedDayDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.5),
            decoration:
                isPerformerWorkDay ? style.performerWorkDayDecoration : null,
            child: Center(
              child: Text(
                day.day.toString(),
                style:
                    isHoliday ? style.holidayTextStyle : style.workDayTextStyle,
              ),
            ),
          ),
          const SizedBox(height: 5),
          isCalendarMode
              ? style.appointmentNumberBadge
              : Text(
                  isPerformerWorkDay
                      ? style.workDayInscription ?? ''
                      : style.holidayInscription ?? '',
                  style: style.inscriptionTextStyle,
                ),
        ],
      ),
    );
  }
}

class ScheduledCalendarDayStyle {
  final double? width;
  final double? height;
  final EdgeInsets padding; // отступ от числа до краёв кружочка
  final TextStyle? inscriptionTextStyle; // стиль текста под числом
  final TextStyle? currentDayTextStyle; // стиль текста текущего числа
  final TextStyle? workDayTextStyle; // стиль числа буднего дня
  final String? workDayInscription; // подпись под будним днём
  final TextStyle holidayTextStyle; // стиль числа выходного дня
  final String? holidayInscription; // подпись под выходным
  final TextStyle focusedDayTextStyle; // стиль сфокусированного, нажатого числа
  final Decoration focusedDayDecoration; // стиль фона нажатого числа
  final Decoration
      performerWorkDayDecoration; // стиль фона рабочего дня исполнителя
  final String
      performerWorkDayInscription; // подпись под числом рабочего дня исполнителя
  final TextStyle selectionModeTextStyle; // стиль дней в режиме выделения
  final Decoration
      selectionModeDecoration; // стиль фона чисел дней в режиме выделения
  final TextStyle selectedDayTextStyle; // стиль текста выбранного дня
  final Decoration selectedDayDecoration; // стиль фона выбранного дня
  final AppointmentNumberBadge
      appointmentNumberBadge; // виджет для количества записей

  ScheduledCalendarDayStyle({
    required this.width,
    required this.height,
    required this.padding,
    required this.inscriptionTextStyle,
    required this.currentDayTextStyle,
    required this.workDayTextStyle,
    required this.workDayInscription,
    required this.holidayTextStyle,
    required this.holidayInscription,
    required this.focusedDayTextStyle,
    required this.focusedDayDecoration,
    required this.performerWorkDayDecoration,
    required this.performerWorkDayInscription,
    required this.selectionModeTextStyle,
    required this.selectionModeDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.appointmentNumberBadge,
  });
}

class AppointmentNumberBadge extends StatelessWidget {
  final double width;
  final double height;
  final int appointmentNumber; // количество записей в день
  final Decoration badgeDecoration; // стиль фона
  final TextStyle numberTextStyle; // стиль текста
  const AppointmentNumberBadge({
    super.key,
    required this.width,
    required this.height,
    required this.appointmentNumber,
    required this.badgeDecoration,
    required this.numberTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

enum MonthDisplay {
  full,
  short,
}

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);
typedef DayBuilder = Widget Function(BuildContext context, DateTime date);

typedef OnMonthLoaded = void Function(int year, int month);
