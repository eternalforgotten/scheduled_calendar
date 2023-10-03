import 'dart:io';

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
  const ClientBookingCard(
    this.date, {
    super.key,
    required this.timeSlots,
    this.style = const ClientBookingCardStyle(),
    required this.onClientCardButtonPressed,
    this.locale,
  });

  @override
  State<ClientBookingCard> createState() => _ClientBookingCardState();
}

class _ClientBookingCardState extends State<ClientBookingCard> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale ?? Platform.localeName;
    final slots = [
      DateTime(2023, 10, 1, 22, 00),
      DateTime(2023, 10, 1, 22, 30),
      DateTime(2023, 10, 1, 23, 00),
      DateTime(2023, 10, 1, 23, 30),
      DateTime(2023, 10, 1, 22, 30),
      DateTime(2023, 10, 1, 22, 30),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
      decoration: widget.style.cardDecoration,
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM', locale).format(widget.date),
            style: widget.style.dateTextStyle,
          ),
          Text(
            widget.style.instructionText,
            style: widget.style.instructionTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 62 / 32,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
              ),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: widget.style.timeSlotDecoration,
                child: Text(
                  DateFormat('Hm', locale).format(slots[index]),
                  style: widget.style.timeSlotTextStyle,
                ),
              ),
              itemCount: slots.length,
            ),
          ),
          TextButton(
            style: widget.style.buttonStyle,
            onPressed: () => widget.onClientCardButtonPressed(widget.date),
            child: Text(
              widget.style.buttonText,
              style: widget.style.buttonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
