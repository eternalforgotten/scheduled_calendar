library scheduled_calendar;

import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:scheduled_calendar/calendar_state/calendar_state.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';
import 'package:scheduled_calendar/utils/enums.dart';
import 'package:scheduled_calendar/utils/styles.dart';
import 'package:scheduled_calendar/utils/typedefs.dart';
import 'package:scheduled_calendar/widgets/month_view.dart';
import 'package:scheduled_calendar/widgets/schedule_inscription.dart';
import 'package:scheduled_calendar/widgets/weeks_separator.dart';

class ScheduledCalendar extends StatefulWidget {
  ScheduledCalendar({
    super.key,
    this.minDate,
    this.maxDate,
    DateTime? initialDate,
    this.monthNameBuilder,
    this.dayBuilder,
    this.addAutomaticKeepAlives = false,
    this.onMonthLoaded,
    this.onPaginationCompleted,
    this.invisibleMonthsThreshold = 1,
    this.physics,
    this.scrollController,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.startWeekWithSunday = false,
    this.onDayPressed,
    this.selectedDateCardBuilder,
    this.disableInteraction = false,
    this.selectedDateCardAnimationDuration,
    this.selectedDateCardAnimationCurve,
    this.nextAvailableDate,
    this.role = Role.client,
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.weeksSeparator = const WeeksSeparator(),
    this.centerMonthName = false,
    this.monthNameTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
    ),
    this.monthNameDisplay = MonthNameDisplay.full,
    this.displayYearInMonthName = false,
    this.monthNameLocale,
    this.appointmentBadgeStyle = const AppointmentBadgeStyle(),
    this.isCalendarMode = false,
    this.monthCustomNames = const {},
    this.daysOff = const [DateTime.saturday, DateTime.sunday],
    this.scheduleInscriptionTextStyle = const ScheduleInscriptionStyle(),
    this.displayScheduleInscription = true,
  }) : initialDate = initialDate ?? DateTime.now().removeTime();

  /// the [DateTime] to start the calendar from, if no [startDate] is provided
  /// `DateTime.now()` will be used
  final DateTime? minDate;

  /// optional [DateTime] to end the calendar pagination, of no [endDate] is
  /// provided the calendar can paginate indefinitely
  final DateTime? maxDate;

  /// the initial date displayed by the calendar.
  /// if inititial date is nulll, the start date will be used
  final DateTime initialDate;

  /// a Builder used for month header generation. a default [MonthNameBuilder] is
  /// used when no custom [MonthNameBuilder] is provided.
  /// * [context]
  /// * [int] year: 2021
  /// * [int] month: 1-12
  final MonthNameBuilder? monthNameBuilder;

  /// a Builder used for day generation. a default [DateBuilder] is
  /// used when no custom [DateBuilder] is provided.
  /// * [context]
  /// * [DateTime] date
  final DateBuilder? dayBuilder;

  /// if the calendar should stay cached when the widget is no longer loaded.
  /// this can be used for maintaining the last state. defaults to `false`
  final bool addAutomaticKeepAlives;

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

  /// Select start day of the week to be Sunday. Defaults to 'false'
  final bool startWeekWithSunday;

  /// Date when the next schedule week will be available
  final DateTime? nextAvailableDate;

  /// User role: performer or client
  final Role role;

  /// Default day view style
  final ScheduledCalendarDayStyle dayStyle;

  /// Select wether center month name or leave it below the week start. Defaults to 'false'
  final bool centerMonthName;

  /// Separator between weeks in month
  final Widget weeksSeparator;

  /// Text style of month name
  final TextStyle monthNameTextStyle;

  /// Way of the month name displaying: full or short. Defaults to 'full'
  final MonthNameDisplay monthNameDisplay;

  /// Select wether display year in month name or no. Defaults to 'false'
  final bool displayYearInMonthName;

  /// Locale of month name
  final String? monthNameLocale;

  /// Map of custom names for months
  final Map<int, String> monthCustomNames;

  /// If calender mode is, badge view with appointments number is displaying under the date.
  /// Defaults to 'false'
  final bool isCalendarMode;

  /// Appointments number badge style
  final AppointmentBadgeStyle appointmentBadgeStyle;

  /// List of days that are calendar days off and have different text style in calendar
  final List<int> daysOff;

  /// Text style of the schedule inscription
  final ScheduleInscriptionStyle scheduleInscriptionTextStyle;

  /// Select wether display schedule inscription or not. Defaults to 'true'.
  /// If [nextAvailableDate] == null, schedule inscription won't be displayed
  final bool displayScheduleInscription;

  ///Callback that overrides behavior of calendar day interaction
  ///By default, calendar will show a card, appearing below the week of selected day,
  ///which is customizable via [selectedDateCardBuilder]
  ///The argument is null when pressing the selected day again
  final DateCallback? onDayPressed;

  ///Widget, used to display card when a day is tapped
  final DateBuilder? selectedDateCardBuilder;

  ///Whether to disable calendar interaction or not
  ///if this is set to true, [onDayPressed] will be ignored
  final bool disableInteraction;

  final Duration? selectedDateCardAnimationDuration;

  final Curve? selectedDateCardAnimationCurve;

  @override
  _ScheduledCalendarState createState() => _ScheduledCalendarState();
}

class _ScheduledCalendarState extends State<ScheduledCalendar> {
  late PagingController<int, Month> _pagingReplyUpController;
  late PagingController<int, Month> _pagingReplyDownController;

  final Key downListKey = UniqueKey();
  late bool hideUp;

  void _onDayTapped(BuildContext context, DateTime? date) {
    final state = context.read<CalendarState>();
    if (state.interaction != CalendarInteraction.disabled) {
      widget.onDayPressed?.call(date);
      state.setDate(date);
    }
  }

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
    if (state == PagingStatus.completed) {
      return widget.onPaginationCompleted?.call(PaginationDirection.up);
    }
  }

  void paginationStatusDown(PagingStatus state) {
    if (state == PagingStatus.completed) {
      return widget.onPaginationCompleted?.call(PaginationDirection.down);
    }
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
    return Provider(
      create: (_) {
        CalendarInteraction interaction;
        if (widget.disableInteraction) {
          interaction = CalendarInteraction.disabled;
        } else {
          interaction = widget.onDayPressed != null
              ? CalendarInteraction.action
              : CalendarInteraction.dateCard;
        }
        return CalendarState(interaction: interaction);
      },
      child: Observer(
        builder: (context) {
          final selectedDate = context.watch<CalendarState>().selectedDate;
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
                            return MonthView(
                              selectedDateCardAnimationCurve:
                                  widget.selectedDateCardAnimationCurve,
                              selectedDateCardAnimationDuration:
                                  widget.selectedDateCardAnimationDuration,
                              selectedDateCardBuilder:
                                  widget.selectedDateCardBuilder,
                              month: month,
                              selectedDate: selectedDate,
                              monthNameBuilder: widget.monthNameBuilder,
                              centerMonthName: false,
                              dayBuilder: widget.dayBuilder,
                              onDayPressed: (date) =>
                                  _onDayTapped(context, date),
                              startWeekWithSunday: widget.startWeekWithSunday,
                              weeksSeparator: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                height: 1,
                                color: const Color(0xFF5C5B5F),
                              ),
                              dayStyle: widget.dayStyle,
                              monthNameTextStyle: widget.monthNameTextStyle,
                              monthNameDisplay: widget.monthNameDisplay,
                              displayYearInMonthName:
                                  widget.displayYearInMonthName,
                              isCalendarMode: widget.isCalendarMode,
                              appointmentBadgeStyle:
                                  widget.appointmentBadgeStyle,
                              monthCustomNames: widget.monthCustomNames,
                              daysOff: widget.daysOff,
                              role: widget.role,
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
                        itemBuilder:
                            (BuildContext context, Month month, int index) {
                          return MonthView(
                            selectedDateCardAnimationCurve:
                                widget.selectedDateCardAnimationCurve,
                            selectedDateCardAnimationDuration:
                                widget.selectedDateCardAnimationDuration,
                            selectedDateCardBuilder:
                                widget.selectedDateCardBuilder,
                            selectedDate: selectedDate,
                            month: month,
                            monthNameBuilder: widget.monthNameBuilder,
                            centerMonthName: false,
                            dayBuilder: widget.dayBuilder,
                            onDayPressed: (date) => _onDayTapped(context, date),
                            startWeekWithSunday: widget.startWeekWithSunday,
                            weeksSeparator: Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              height: 1,
                              color: const Color(0xFF5C5B5F),
                            ),
                            dayStyle: widget.dayStyle,
                            monthNameTextStyle: widget.monthNameTextStyle,
                            monthNameDisplay: widget.monthNameDisplay,
                            displayYearInMonthName:
                                widget.displayYearInMonthName,
                            isCalendarMode: widget.isCalendarMode,
                            appointmentBadgeStyle: widget.appointmentBadgeStyle,
                            monthCustomNames: widget.monthCustomNames,
                            daysOff: widget.daysOff,
                            role: widget.role,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        widget.listPadding.left,
                        0,
                        widget.listPadding.right,
                        widget.nextAvailableDate != null &&
                                widget.displayScheduleInscription &&
                                !widget.isCalendarMode
                            ? 16
                            : 0),
                    sliver: SliverToBoxAdapter(
                      child: widget.nextAvailableDate != null &&
                              widget.displayScheduleInscription &&
                              !widget.isCalendarMode
                          ? ScheduleInscription(
                              widget.nextAvailableDate!,
                              style: widget.scheduleInscriptionTextStyle,
                              locale: widget.monthNameLocale,
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingReplyUpController.dispose();
    _pagingReplyDownController.dispose();
    super.dispose();
  }
}
