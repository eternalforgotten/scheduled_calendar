import 'package:example/styles.dart';
import 'package:flutter/widgets.dart';

class NoEntriesCard extends StatelessWidget {
  final NoEntriesCardStyle style;
  const NoEntriesCard({
    Key? key,
    this.style = const NoEntriesCardStyle(),
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
