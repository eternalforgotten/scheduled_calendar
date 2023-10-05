import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:scheduled_calendar/utils/date_utils.dart';

part 'calendar_state.g.dart';

class CalendarState = CalendarStateBase with _$CalendarState;

abstract class CalendarStateBase with Store {
  @observable
  DateTime? focusedDate;

  @action
  void setDate(DateTime? date) {
    focusedDate = date;
  }

  @observable
  List<DateTime> selectedDates = [];

  @action
  void onSelected(DateTime date) {
    final dateInList = dateInSelectedList(date);
    if (dateInList == null) {
      selectedDates.add(date);
    } else {
      selectedDates.remove(dateInList);
    }
  }

  DateTime? dateInSelectedList(DateTime date) {
    return selectedDates.firstWhereOrNull((element) => element.isSameDay(date));
  }

  @action
  void clearDates() {
    selectedDates.clear();
  }
}
