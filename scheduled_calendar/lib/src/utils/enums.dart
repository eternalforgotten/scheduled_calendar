/// enum for month name displaying
enum MonthNameDisplay {
  full,
  short,
}

/// enum indicating the pagination enpoint direction
enum PaginationDirection {
  up,
  down,
}

/// enum for defining calendar interaction
enum CalendarInteraction {
  ///Interaction type when pressing on a day will open
  ///a card below the week of the pressed day
  dateCard,

  ///Interaction type when pressing on a day will execute
  ///an action
  action,

  ///Interaction type when pressing on a day will add date to selected dates list
  ///or remove date from it
  selection,

  ///Type when any calendar interaction is disabled. Set by default
  disabled,
}