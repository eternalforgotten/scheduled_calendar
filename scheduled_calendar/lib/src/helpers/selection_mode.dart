
///Config for selection mode of the calendar
///[onSelectionEnd] is called with the list of selected days
///on the end of the mode
class SelectionModeConfig {
  final void Function(List<DateTime>)? onSelectionEnd;

  const SelectionModeConfig({this.onSelectionEnd});
}
