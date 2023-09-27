import 'package:example/pages/calendar_builder_page.dart';
import 'package:example/pages/paged_vertical_calendar_page.dart';
import 'package:example/pages/table_calendar_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const PagedVerticalCalenderPage(),
    );
  }
}