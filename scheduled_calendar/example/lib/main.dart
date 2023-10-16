import 'package:example/widgets/performer_card.dart';
import 'package:example/widgets/schedule_inscription.dart';
import 'package:flutter/material.dart';
import 'package:scheduled_calendar/scheduled_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSelection = false;
  List<Period> periods = [];

  CalendarInteraction get interaction => isSelection
      ? CalendarInteraction.selection
      : CalendarInteraction.dateCard;

  void _toggle() {
    setState(() {
      isSelection = !isSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        centerTitle: true,
        title: const Text(
          'Расписание',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [FloatingActionButton(onPressed: _toggle)],
      ),
      body: ScheduledCalendar(
        isWorkDay: (date) {
          final condition = date.day == 8 || date.day == 17;
          return condition;
        },
        selectionModeConfig: SelectionModeConfig(
          onSelectionEnd: (list) {},
        ),
        interaction: interaction,
        minDate: DateTime(2023, 9, 7),
        maxDate: DateTime(2023, 11, 16),
        initialDate: DateTime(2023, 9, 9),
        monthNameStyle: const ScheduleCalendarMonthNameStyle(
          centerMonthName: true,
          monthCustomNames: {
            1: 'Янв.',
            2: 'Фев.',
            3: 'Мар.',
            4: 'Апр.',
            5: 'Май',
            6: 'Июн.',
            7: 'Июл.',
            8: 'Авг.',
            9: 'Сен.',
            10: 'Окт.',
            11: 'Ноя.',
            12: 'Дек.',
          },
        ),
        calendarFooter: ScheduleInscription(DateTime(2023, 9, 11)),
        focusedDateCardAnimationCurve: Curves.easeInOutBack,
        focusedDateCardAnimationDuration: const Duration(milliseconds: 300),
        dayFooterBuilder: (_, date) => const Text(
          'Вых',
          style: TextStyle(fontSize: 12, color: Colors.white38),
        ),
        focusedDateCardBuilder: (_, date) {
          return PerformerCard(
            date,
            initialPeriods: periods,
            onPerformerCardButtonPressed: (_) {},
          );
        },
        dayStyle: const ScheduledCalendarDayStyle(
          currentDayTextStyle: TextStyle(
            color: Colors.yellowAccent,
          ),
          weekdayCustomNames: {
            1: 'Пн',
            2: 'Вт',
            3: 'Ср',
            4: 'Чт',
            5: 'Пт',
            6: 'Сб',
            7: 'Вс',
          },
        ),
      ),
    );
  }
}
