// events.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  Event(this.title);

  @override
  String toString() => title;

  Map<String, dynamic> toJson() => {'title': title};

  static Event fromJson(Map<String, dynamic> json) => Event(json['title']);
}

/// Example events.
final Map<DateTime, List<Event>> kEvents = {};

Future<void> fetchEventsFromFirestore() async {
  final snapshot = await FirebaseFirestore.instance.collection('events').get();
  for (var doc in snapshot.docs) {
    final data = doc.data();
    final date = DateTime.parse(data['date']);
    final event = Event.fromJson(data);
    if (kEvents[date] == null) {
      kEvents[date] = [event];
    } else {
      kEvents[date]!.add(event);
    }
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
