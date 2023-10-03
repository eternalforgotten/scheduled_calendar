import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scheduled_calendar/utils/styles.dart';

class ClientBookingCard extends StatefulWidget {
  final DateTime date;
  final List<DateTime> timeSlots;
  final ClientBookingCardStyle style;
  final ValueChanged<DateTime> onClientCardButtonPressed;
  final String? locale;
  final AnimationController controller;
  const ClientBookingCard(
    this.date, {
    super.key,
    required this.timeSlots,
    this.style = const ClientBookingCardStyle(),
    required this.onClientCardButtonPressed,
    this.locale,
    required this.controller,
  });

  @override
  State<ClientBookingCard> createState() => _ClientBookingCardState();
}

class _ClientBookingCardState extends State<ClientBookingCard> {
  int selectedSlotIndex = -1;

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
              widget.style.instructionText,
              style: widget.style.instructionTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 16),
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                alignment: WrapAlignment.center,
                children: [
                  ...widget.timeSlots
                      .mapIndexed(
                        (index, timeSlot) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedSlotIndex != index) {
                                selectedSlotIndex = index;
                              } else {
                                selectedSlotIndex = -1;
                              }
                            });
                          },
                          child: Container(
                            padding: widget.style.timeSlotPadding,
                            decoration: selectedSlotIndex == index
                                ? widget.style.selectedTimeSlotDecoration
                                : widget.style.timeSlotDecoration,
                            child: Text(
                              DateFormat('Hm', locale).format(timeSlot),
                              style: selectedSlotIndex == index
                                  ? widget.style.selectedTimeSlotTextStyle
                                  : widget.style.timeSlotTextStyle,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            TextButton(
              style: widget.style.buttonStyle,
              onPressed: selectedSlotIndex == -1
                  ? null
                  : () => widget.onClientCardButtonPressed(
                      widget.timeSlots[selectedSlotIndex]),
              child: Text(
                widget.style.buttonText,
                style: selectedSlotIndex == -1
                    ? widget.style.inactiveButtonTextStyle
                    : widget.style.buttonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
