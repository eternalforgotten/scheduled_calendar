import 'package:flutter/material.dart' hide DateUtils;
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'calendar_state/calendar_state.dart';
import 'helpers/selection_mode.dart';
import 'utils/date_models.dart';
import 'utils/date_utils.dart';
import 'utils/enums.dart';
import 'utils/styles.dart';
import 'utils/typedefs.dart';
import 'widgets/month_view.dart';
import 'widgets/weeks_separator.dart';

///Calendar, which allows to interact with calendar for scheduling purposes.
///For day pressing interaction, override [interaction] parameter.
///
///For [CalendarInteraction.dateCard], a widget below the week of selected day
///will be shown. [focusedDateCardBuilder] must be provided in that case.
///
///For [CalendarInteraction.action], callback [onDayPressed] will be called,
///which has to be provided in that case.
///
///[CalendarInteraction.selection] differs from abovementioned types.
///It's purpose is to select a group of days, for further interaction.
///This interaction mode should not be passed directly, but to enter this mode
///provide the new widget with [interaction] set to [CalendarInteraction.selection]
///(for example, via [setState]).
///
///The example below shows the possible correct usage of [CalendarInteraction.selection]
///
/// ```dart
/// bool isSelection = false;

///CalendarInteraction get interaction => isSelection
///    ? CalendarInteraction.selection
///    : CalendarInteraction.dateCard;

/// void _toggle() {
///  setState(() {
///    isSelection = !isSelection;
///  });
///}
///...
///ScheduledCalendar(
///   interaction: interaction
///)
/// ```
/// On the end of the selection mode (when widget with the new [interaction] is provided),
/// [selectionModeConfig.onSelectionEnd] callback with the list of selected days will be called, if provided
class ScheduledCalendar extends StatefulWidget {
  ///Creates a [ScheduledCalendar].
  ///
  ///[initialDate] defaults to [DateTime.now] and must be equal or after [minDate] and equal or before [maxDate].
  ///
  ///Provide the [onDayPressed] callback for [CalendarInteraction.action].
  ///
  ///Provide the [focusedDateCardBuilder] callback for [CalendarInteraction.dateCard]
  ///
  ///Otherwise, [ArgumentError] is thrown
  ScheduledCalendar({
    super.key,
    this.minDate,
    this.maxDate,
    DateTime? initialDate,
    this.onMonthLoaded,
    this.onPaginationCompleted,
    this.invisibleMonthsThreshold = 1,
    this.physics,
    this.scrollController,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.startWeekWithSunday = false,
    this.onDayPressed,
    this.focusedDateCardBuilder,
    this.focusedDateCardAnimationDuration,
    this.focusedDateCardAnimationCurve,
    this.calendarFooter,
    this.dayStyle = const ScheduledCalendarDayStyle(),
    this.weeksSeparator = const WeeksSeparator(),
    this.isCalendarMode = false,
    this.daysOff = const [DateTime.saturday, DateTime.sunday],
    this.selectionModeConfig = const SelectionModeConfig(),
    this.interaction = CalendarInteraction.disabled,
    this.dayFooterBuilder,
    this.monthNameStyle = const ScheduleCalendarMonthNameStyle(),
    this.isWorkDay,
    this.displayWeekdays = false,
    this.dayFooterPadding = 5,
    this.firstWeekSeparator,
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

  ///Month name style
  final ScheduleCalendarMonthNameStyle monthNameStyle;

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

  /// Select start day of the week to be Sunday. Defaults to [false]
  final bool startWeekWithSunday;

  /// Date when the next schedule week will be available
  final Widget? calendarFooter;

  /// Default day view style
  final ScheduledCalendarDayStyle dayStyle;

  /// Separator between weeks in month
  final Widget weeksSeparator;

  /// If calender mode is, badge view with appointments number is displaying under the date.
  /// Defaults to [false]
  final bool isCalendarMode;

  /// List of days that are calendar days off and have different text style in calendar
  final List<int> daysOff;

  ///Callback that will be called when [interaction] is set to [CalendarInteraction.action]
  final DateCallback? onDayPressed;

  ///Widget, used to display card when a day is tapped
  final DateBuilder? focusedDateCardBuilder;

  ///Animation duration of card appearing for
  ///[CalendarInteraction.dateCard]
  final Duration? focusedDateCardAnimationDuration;

  ///Animation curve of card appearing for
  ///[CalendarInteraction.dateCard]
  final Curve? focusedDateCardAnimationCurve;

  ///Interaction mode of the calendar. By default, [CalendarInteraction.disabled] is set.
  ///For [CalendarInteraction.dateCard], provide [focusedDateCardBuilder]
  ///to display a card below the week of focused day.
  ///For [CalendarInteraction.action], provide [onDayPressed] callback
  ///Otherwise, [ArgumentError] is thrown
  final CalendarInteraction interaction;

  ///Customizable config for selection mode.
  ///To enter this mode, provide new widget with [interaction]
  ///set to [CalendarInteraction.selection].
  ///To exit the mode, provide new widget with different [interaction]
  final SelectionModeConfig selectionModeConfig;

  final DateBuilder? dayFooterBuilder;

  final double dayFooterPadding;

  final bool Function(DateTime)? isWorkDay;

  final bool displayWeekdays;

  final Widget? firstWeekSeparator;

  @override
  ScheduledCalendarState createState() => ScheduledCalendarState();
}

class ScheduledCalendarState extends State<ScheduledCalendar> {
  late PagingController<int, Month> _pagingReplyUpController;
  late PagingController<int, Month> _pagingReplyDownController;

  final Key downListKey = UniqueKey();
  late bool hideUp;

  BuildContext? realContext;

  @override
  void didUpdateWidget(covariant ScheduledCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final state = realContext!.read<CalendarState>();
    final oldSelected = oldWidget.interaction == CalendarInteraction.selection;
    final newSelected = widget.interaction == CalendarInteraction.selection;

    if (widget.minDate != oldWidget.minDate ||
        widget.maxDate != oldWidget.maxDate) {
      _pagingReplyUpController.refresh();

      hideUp = !(widget.minDate == null ||
          !widget.minDate!.isSameMonth(widget.initialDate));
    }

    if (!oldSelected && newSelected) {
      state.clearDates();
    }

    if (oldSelected && !newSelected) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        widget.selectionModeConfig.onSelectionEnd?.call(state.selectedDates);
      });
    }

    if (oldSelected && newSelected) {
      final oldSelectedAll = oldWidget.selectionModeConfig.selectedAll;
      final newSelectedAll = widget.selectionModeConfig.selectedAll;
      final minDate = widget.minDate;
      final maxDate = widget.maxDate;
      if (minDate == null || maxDate == null) return;
      if (!oldSelectedAll && newSelectedAll) {
        state.selectAll(minDate, maxDate);
      }
      if (oldSelectedAll && !newSelectedAll) {
        state.deselectAll(minDate, maxDate);
      }
    }
  }

  void _onDayTapped(BuildContext context, DateTime? date) {
    final state = context.read<CalendarState>();
    if (widget.interaction == CalendarInteraction.selection) {
      assert(date != null);
      state.onSelected(date!);
      setState(() {});
    } else {
      if (widget.interaction == CalendarInteraction.action) {
        widget.onDayPressed!(date!);
      }
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

    if (widget.onDayPressed == null &&
        widget.interaction == CalendarInteraction.action) {
      throw ArgumentError(
        'Provide the onDayPressed callback for CalendarInteraction.action',
      );
    }

    if (widget.focusedDateCardBuilder == null &&
        widget.interaction == CalendarInteraction.dateCard) {
      throw ArgumentError(
        'Provide the focusedDateCardBuilder callback for CalendarInteraction.dateCard',
      );
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
      create: (_) => CalendarState(),
      builder: (context, child) {
        realContext = context;
        return child!;
      },
      child: Observer(
        builder: (context) {
          final state = context.watch<CalendarState>();
          final focusedDate = state.focusedDate;
          return Scrollable(
            controller: widget.scrollController,
            physics: widget.physics,
            viewportBuilder: (context, position) {
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
                            return IgnorePointer(
                              ignoring: widget.interaction ==
                                  CalendarInteraction.disabled,
                              child: MonthView(
                                dayFooterBuilder: widget.dayFooterBuilder,
                                interaction: widget.interaction,
                                focusedDateCardAnimationCurve:
                                    widget.focusedDateCardAnimationCurve,
                                focusedDateCardAnimationDuration:
                                    widget.focusedDateCardAnimationDuration,
                                focusedDateCardBuilder:
                                    widget.focusedDateCardBuilder,
                                month: month,
                                focusedDate: focusedDate,
                                onDayPressed: (date) =>
                                    _onDayTapped(context, date),
                                startWeekWithSunday: widget.startWeekWithSunday,
                                weeksSeparator: widget.weeksSeparator,
                                dayStyle: widget.dayStyle,
                                monthNameStyle: widget.monthNameStyle,
                                daysOff: widget.daysOff,
                                isWorkDay: widget.isWorkDay,
                                displayWeekdays: widget.displayWeekdays,
                                dayFooterPadding: widget.dayFooterPadding,
                                firstWeekSeparator: widget.firstWeekSeparator ??
                                    widget.weeksSeparator,
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
                        itemBuilder:
                            (BuildContext context, Month month, int index) {
                          return IgnorePointer(
                            ignoring: widget.interaction ==
                                CalendarInteraction.disabled,
                            child: MonthView(
                              dayFooterBuilder: widget.dayFooterBuilder,
                              interaction: widget.interaction,
                              focusedDateCardAnimationCurve:
                                  widget.focusedDateCardAnimationCurve,
                              focusedDateCardAnimationDuration:
                                  widget.focusedDateCardAnimationDuration,
                              focusedDateCardBuilder:
                                  widget.focusedDateCardBuilder,
                              focusedDate: focusedDate,
                              month: month,
                              onDayPressed: (date) =>
                                  _onDayTapped(context, date),
                              startWeekWithSunday: widget.startWeekWithSunday,
                              weeksSeparator: widget.weeksSeparator,
                              dayStyle: widget.dayStyle,
                              monthNameStyle: widget.monthNameStyle,
                              daysOff: widget.daysOff,
                              isWorkDay: widget.isWorkDay,
                              displayWeekdays: widget.displayWeekdays,
                              dayFooterPadding: widget.dayFooterPadding,
                              firstWeekSeparator: widget.firstWeekSeparator ??
                                  widget.weeksSeparator,
                            ),
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
                        widget.calendarFooter != null && !widget.isCalendarMode
                            ? 16
                            : 0),
                    sliver: SliverToBoxAdapter(
                      child: widget.calendarFooter != null &&
                              !widget.isCalendarMode
                          ? widget.calendarFooter
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
