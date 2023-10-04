import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_calendar/utils/date_models.dart';
import 'package:scheduled_calendar/utils/styles.dart';

class PerformerCard extends StatefulWidget {
  final DateTime date;
  final List<Period> periods;
  final PerformerCardStyle style;
  final ValueChanged<Period> onPerformerCardButtonPressed;
  final String? locale;
  final AnimationController controller;
  const PerformerCard(
    this.date, {
    super.key,
    required this.periods,
    this.style = const PerformerCardStyle(),
    required this.onPerformerCardButtonPressed,
    this.locale,
    required this.controller,
  });

  @override
  State<PerformerCard> createState() => _PerformerCardState();
}

class _PerformerCardState extends State<PerformerCard> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale ?? Platform.localeName;
    var date = DateFormat('EEEE, d MMMM', locale).format(widget.date);
    date = date = date.replaceRange(
      0,
      1,
      date.substring(0, 1).toUpperCase(),
    );

    return SizeTransition(
      sizeFactor: widget.controller,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        decoration: widget.style.cardDecoration,
        child: Column(
          children: [
            Text(
              date,
              style: widget.style.dateTextStyle,
            ),
            Text(
              widget.periods.isEmpty
                  ? widget.style.emptyInstructionText
                  : widget.style.instructionText,
              style: widget.style.instructionTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Column(
                children: [
                  ...widget.periods
                      .mapIndexed(
                        (index, timeSlot) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Container(
                            width: 100,
                            height: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: widget.style.addButtonStyle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.style.addButtonIcon,
                  const SizedBox(width: 8),
                  Text(
                    widget.style.addButtonText,
                    style: widget.style.addButtonTextStyle,
                  ),
                ],
              ),
            ),
            TextButton(
              style: widget.style.requestButtonStyle,
              onPressed: () {},
              child: Text(
                widget.style.requestButtonText,
                style: widget.style.requestButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
