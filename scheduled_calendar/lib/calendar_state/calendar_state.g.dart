// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CalendarState on CalendarStateBase, Store {
  late final _$selectedDateAtom =
      Atom(name: 'CalendarStateBase.selectedDate', context: context);

  @override
  DateTime? get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime? value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$selectedDatesAtom =
      Atom(name: 'CalendarStateBase.selectedDates', context: context);

  @override
  List<DateTime> get selectedDates {
    _$selectedDatesAtom.reportRead();
    return super.selectedDates;
  }

  @override
  set selectedDates(List<DateTime> value) {
    _$selectedDatesAtom.reportWrite(value, super.selectedDates, () {
      super.selectedDates = value;
    });
  }

  late final _$CalendarStateBaseActionController =
      ActionController(name: 'CalendarStateBase', context: context);

  @override
  void setDate(DateTime? date) {
    final _$actionInfo = _$CalendarStateBaseActionController.startAction(
        name: 'CalendarStateBase.setDate');
    try {
      return super.setDate(date);
    } finally {
      _$CalendarStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSelected(DateTime date) {
    final _$actionInfo = _$CalendarStateBaseActionController.startAction(
        name: 'CalendarStateBase.onSelected');
    try {
      return super.onSelected(date);
    } finally {
      _$CalendarStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDates() {
    final _$actionInfo = _$CalendarStateBaseActionController.startAction(
        name: 'CalendarStateBase.clearDates');
    try {
      return super.clearDates();
    } finally {
      _$CalendarStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedDate: ${selectedDate},
selectedDates: ${selectedDates}
    ''';
  }
}
