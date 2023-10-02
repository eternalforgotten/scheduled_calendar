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
  String toString() {
    return '''
selectedDate: ${selectedDate}
    ''';
  }
}
