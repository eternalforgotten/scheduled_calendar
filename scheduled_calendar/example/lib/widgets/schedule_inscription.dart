import 'dart:io';

import 'package:example/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ScheduleInscription extends StatefulWidget {
  final DateTime nextAvailableDate;
  final ScheduleInscriptionStyle style;
  final String? locale;
  const ScheduleInscription(
    this.nextAvailableDate, {
    super.key,
    this.style = const ScheduleInscriptionStyle(),
    this.locale,
  });

  @override
  State<ScheduleInscription> createState() => _ScheduleInscriptionState();
}

class _ScheduleInscriptionState extends State<ScheduleInscription> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale ?? Platform.localeName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: widget.style.textStyle,
          children: [
            TextSpan(
              text: '${widget.style.instructionText} ',
              style: widget.style.instructionTextStyle,
            ),
            TextSpan(
              text:
                  DateFormat('d MMMM', locale).format(widget.nextAvailableDate),
              style: widget.style.dateTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
