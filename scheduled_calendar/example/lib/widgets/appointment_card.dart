import 'package:example/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentCardStyle style;
  final Service service;
  const AppointmentCard({
    Key? key,
    this.style = const AppointmentCardStyle(),
    required this.service,
  }) : super(key: key);

  String convertDurationToString(Duration duration) {
    String result = '';
    if (duration.inHours > 0) {
      result += "${duration.inHours} часов";
    }
    if (duration.inMinutes > 0) {
      result += "${duration.inMinutes} минут";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: style.cardDecoration,
      padding: style.padding,
      height: style.height,
      width: style.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            service.title,
            style: style.titleTextStyle,
          ),
          Text(
            service.description,
            style: style.descriptionTextStyle,
          ),
          Row(
            children: [
              if (service.duration != null) ...[
                Container(
                  decoration: style.timeDecoration,
                  height: style.timeCardHeight,
                  width: style.timeCardWidth,
                  alignment: Alignment.center,
                  child: Text(
                    convertDurationToString(service.duration!),
                    style: style.timeStyle,
                  ),
                ),
              ],
              const SizedBox(width: 6),
              if (service.price != null)
                Text(
                  '${service.price} ₽',
                  style: style.priceTextStyle,
                ),
            ],
          )
        ],
      ),
    );
  }
}

class CalendarAppointmentView extends StatelessWidget {
  final CalendarAppointment calendarAppointment;
  final AppointmentCardStyle style;

  const CalendarAppointmentView({
    super.key,
    required this.calendarAppointment,
    this.style = const AppointmentCardStyle(),
  });
  String convertDateTimeToString(DateTime dateTime) =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              convertDateTimeToString(calendarAppointment.startTime),
              style: style.dateTimeStyle,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF484747),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AppointmentCard(
            service: calendarAppointment.service,
            style: style,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              convertDateTimeToString(calendarAppointment.endTime),
              style: style.dateTimeStyle,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFF484747),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CalendarAppointment {
  final DateTime startTime;
  final DateTime endTime;
  final Service service;

  CalendarAppointment(
      {required this.startTime, required this.endTime, required this.service});
}

class Service {
  final String? id;
  final String title;
  final String description;
  final int? price;
  final Duration? duration;
  final DateTime? dateTime;
  //final ServiceCategory? area;
  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.dateTime,
    //required this.area,
  });
}
