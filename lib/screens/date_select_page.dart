import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journals_app/constants.dart';
import 'package:journals_app/models/event_model.dart';
import 'package:journals_app/screens/components/add_journal.dart';
import 'package:journals_app/screens/components/back_arrow_app_bar.dart';
import 'package:journals_app/screens/journal_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  ValueNotifier<List<Event>>? _selectedEvents;
  late List<dynamic> eventsLoaders;
  late List<bool> isLoadingDeleteList;
  LinkedHashMap<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>?
      mappedEventsOnCalender;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = false;
  final Map<DateTime, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      kEventSource = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _initializeSelectedEvents();
    getAllEventss();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _selectedEvents!.dispose();
    super.dispose();
  }

  //get all events and store them in a map of date as the key and events as list as the value
  // eg: {"2024-03-26":[event1,event2,event3]}

  Future getAllEventss() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allEvents =
        await getAllEvents();

    for (var events in allEvents) {
      kEventSource[DateTime(
        DateTime.parse(events['date']).year,
        DateTime.parse(events['date']).month,
        DateTime.parse(events['date']).day,
      )] = kEventSource[DateTime(
                DateTime.parse(events['date']).year,
                DateTime.parse(events['date']).month,
                DateTime.parse(events['date']).day,
              )] !=
              null
          ? [
              ...?kEventSource[DateTime(
                DateTime.parse(events['date']).year,
                DateTime.parse(events['date']).month,
                DateTime.parse(events['date']).day,
              )],
              events
            ]
          : [events];
    }

    final kEvents = LinkedHashMap<DateTime,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    setState(() {
      mappedEventsOnCalender = kEvents;
    });
  }

// on page start, initialize by getting events for the current date. This function is called in initState
  Future _initializeSelectedEvents() async {
    List<Event> events = await getEventsForDay(_selectedDay!);

    setState(() {
      eventsLoaders = events;
      // isLoadingDeleteList = List.filled(events.length, false);

      _selectedEvents = ValueNotifier(events);
    });
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _getMappedEventsForDay(
      DateTime day) {
    return mappedEventsOnCalender![day] ?? [];
  }

  // logic to get Events for the selected Day
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      final eventsForSelectedDay = await getEventsForDay(selectedDay);

      _selectedEvents!.value = eventsForSelectedDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJournal(
                pickedDate: DateFormat("yyyy-MM-dd").format(_selectedDay!),
                selectedEvents: _selectedEvents!,
                nonFormattedSelectedDate: _selectedDay!,
                getAllEvents: getAllEventss,
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: mappedEventsOnCalender != null
          ? Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
                  lastDay: DateTime.utc(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: _getMappedEventsForDay,
                  headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    selectedDecoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const SizedBox(height: 8.0),
                _selectedEvents == null
                    ? const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: kPrimaryColor,
                        ),
                      )
                    : Expanded(
                        child: ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents!,
                          builder: (context, value, _) {
                            return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                            eventDetails: value[index],
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      value[index].title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () async {
                                        //delete that specific event,
                                        setState(() {
                                          isLoading = true;
                                        });

                                        try {
                                          await FirebaseFirestore.instance
                                              .collection("journal")
                                              .doc(value[index].documentId)
                                              .delete();
                                          final eventsForSelectedDay =
                                              await getEventsForDay(
                                                  _selectedDay!);

                                          _selectedEvents!.value =
                                              eventsForSelectedDay;
                                          // getAllEventss();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              "Deleted Event Successfully",
                                              style: TextStyle(
                                                fontFamily: 'Axiforma',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                          ));
                                          setState(() {
                                            isLoading = false;
                                          });
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print(
                                                'Error Deleting events for day: $e');
                                          }

                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              "An Error Occured During Deletion",
                                              style: TextStyle(
                                                fontFamily: 'Axiforma',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            duration: Duration(seconds: 3),
                                          ));
                                        }
                                      },
                                      child: isLoading
                                          ? const CircularProgressIndicator
                                              .adaptive(
                                              backgroundColor: kPrimaryColor,
                                            )
                                          : const Icon(
                                              Icons.delete,
                                              color: kPrimaryColor,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
              ],
            )
          : const Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: kPrimaryColor,
                ),
              ),
            ),
    );
  }
}
