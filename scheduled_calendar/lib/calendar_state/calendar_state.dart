import 'package:mobx/mobx.dart';
import 'package:scheduled_calendar/utils/enums.dart';

part 'calendar_state.g.dart';

class CalendarState = CalendarStateBase with _$CalendarState;

abstract class CalendarStateBase with Store {
  final CalendarInteraction interaction;

  CalendarStateBase({required this.interaction});

  @observable
  DateTime? selectedDate;

  @action
  void setDate(DateTime? date) {
    selectedDate = date;
  }
}
