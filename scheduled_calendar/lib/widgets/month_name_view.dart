import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/enums.dart';

class MonthNameView extends StatefulWidget {
  final Month month;
  final TextStyle monthNameTextStyle;
  final MonthNameDisplay monthNameDisplay;
  final bool displayYear;
  final String? nameLocale;
  final Map<int, String> monthCustomNames;

  const MonthNameView(
    this.month, {
    super.key,
    this.monthNameTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEFD23C),
    ),
    this.monthNameDisplay = MonthNameDisplay.full,
    this.displayYear = false,
    this.nameLocale,
    this.monthCustomNames = const {},
  });

  @override
  State<MonthNameView> createState() => _MonthNameViewState();
}

class _MonthNameViewState extends State<MonthNameView> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.nameLocale ?? Platform.localeName;
    var date = widget.monthCustomNames[widget.month.month] ??
        DateFormat(
          (widget.monthNameDisplay == MonthNameDisplay.full
              ? widget.displayYear
                  ? 'MMMM y'
                  : 'MMMM'
              : widget.displayYear
                  ? 'MMM y'
                  : 'MMM'),
          locale,
        ).format(
          DateTime(
            widget.month.year,
            widget.month.month,
            1,
          ),
        );
    return Text(
      date,
      style: widget.monthNameTextStyle,
    );
  }
}
