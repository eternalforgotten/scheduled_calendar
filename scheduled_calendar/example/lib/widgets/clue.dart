import 'package:example/styles.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class Clue extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> showCasekey;
  final ClueStyle clueStyle;
  final String title;
  final String description;
  final Widget child;
  final EdgeInsets cluePadding;

  const Clue({
    super.key,
    this.clueStyle = const ClueStyle(),
    required this.child,
    required this.title,
    required this.description,
    required this.showCasekey,
    required this.cluePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      tooltipPosition: clueStyle.toolTipPosition,
      key: showCasekey,
      height: clueStyle.height,
      width: clueStyle.width,
      disableMovingAnimation: true,
      container: Padding(
        padding: cluePadding.copyWith(
          top: clueStyle.toolTipPosition == TooltipPosition.top
              ? cluePadding.top
              : cluePadding.top + 15,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top:
                  clueStyle.toolTipPosition == TooltipPosition.top ? null : -14,
              bottom:
                  clueStyle.toolTipPosition == TooltipPosition.top ? -14 : null,
              left: clueStyle.arrowLeftPadding != null
                  ? clueStyle.arrowLeftPadding! - 8
                  : null,
              child: CustomPaint(
                painter: _Arrow(
                  strokeColor: clueStyle.backgroundColor,
                  strokeWidth: 10,
                  paintingStyle: PaintingStyle.fill,
                  isUpArrow: clueStyle.toolTipPosition != TooltipPosition.top,
                ),
                child: const SizedBox(
                  height: 15,
                  width: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              height: clueStyle.height,
              width: clueStyle.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: clueStyle.backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: clueStyle.titleTextStyle,
                      ),
                      InkWell(
                        onTap: () => ShowCaseWidget.of(context).dismiss(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x43405359).withOpacity(0.35),
                          ),
                          child: const Icon(
                            Icons.close_outlined,
                            color: Color(0xFFF6F5F8),
                            size: 19,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    description,
                    style: clueStyle.descriptionTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}

class _Arrow extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final bool isUpArrow;
  final Paint _paint;

  _Arrow({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
    this.isUpArrow = true,
  }) : _paint = Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = paintingStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(getTrianglePath(size.width, size.height), _paint);
  }

  Path getTrianglePath(double x, double y) {
    if (isUpArrow) {
      return Path()
        ..moveTo(0, y)
        ..lineTo(x / 2, 0)
        ..lineTo(x, y)
        ..lineTo(0, y);
    }
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x / 2, y)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(covariant _Arrow oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
