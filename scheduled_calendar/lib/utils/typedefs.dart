import 'package:flutter/material.dart';

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);

typedef DateBuilder = Widget Function(BuildContext context, DateTime date);

typedef DateCallback = void Function(DateTime? date);

typedef OnMonthLoaded = void Function(int year, int month);
