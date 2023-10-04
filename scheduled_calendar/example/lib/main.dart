import 'package:flutter/material.dart';
import 'package:scheduled_calendar/scheduled_calendar.dart';
import 'package:scheduled_calendar/utils/styles.dart';

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
      ),
      body: Center(
        child: ScheduledCalendar(
          dayStyle: ScheduledCalendarDayStyle(),
          minDate: DateTime(2023, 9, 7),
          maxDate: DateTime(2023, 11, 16),
          initialDate: DateTime(2023, 9, 9),
          monthCustomNames: const {
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
          nextAvailableDate: DateTime(2023, 9, 11),
          selectedDateCardAnimationCurve: Curves.easeInOutBack,
          selectedDateCardAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
