import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:journals_app/models/event_model.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

int getHashCode(DateTime key) {
  return key.day + key.month + key.year;
}

Future<List<Event>> getEventsForDay(DateTime day) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('journal')
        .where('date', isEqualTo: DateFormat("yyyy-MM-dd").format(day))
        .get();

    // Initialize an empty list to store events for the day
    List<Event> events = [];

    // Iterate over the documents returned by the query
    for (var doc in querySnapshot.docs) {
      // Create an Event object using extracted data from each document
      Event event = Event(
        doc['title'],
        doc['description'],
        doc['image'],
        doc.id,
        doc['date'],
      );

      // Add the event to the list of events for the day
      events.add(event);
    }

    // Return the list of events for the day
    return events;
  } catch (e) {
    // Handle any errors
    if (kDebugMode) {
      print('Error fetching events for day: $e');
    }
    throw e;
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllEvents() async {
  try {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('journal').get();

    // Return the list of all events
    return querySnapshot.docs;
  } catch (e) {
    // Handle any errors
    if (kDebugMode) {
      print('Error fetching events for day: $e');
    }
    throw e;
  }
}
