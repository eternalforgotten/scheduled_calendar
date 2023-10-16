import 'package:example/styles.dart';
import 'package:flutter/widgets.dart';

class NoAppointmentsCard extends StatelessWidget {
  final NoAppointmentsCardStyle style;
  const NoAppointmentsCard({
    Key? key,
    this.style = const NoAppointmentsCardStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        style.icon,
        const SizedBox(height: 10),
        Text(style.title,
            style: style.titleTextStyle, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Text(
          style.description,
          style: style.descriptionTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
