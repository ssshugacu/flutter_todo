import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class Event {
  final String title;
  Event(this.title);
}

class _CalendarAppState extends State<CalendarApp> {
  DateTime today = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  String _userEvent = '';

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void saveEvent(Map<DateTime, List<Event>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedEvents = events.entries
        .map((entry) =>
    '${entry.key.toIso8601String()}|${entry.value.map((e) => e.title).join(',')}')
        .toList();
    prefs.setStringList('events', encodedEvents);
  }

  Map<DateTime, List<Event>> loadEvents() {
    Map<DateTime, List<Event>> loadedEvents = {};
    SharedPreferences.getInstance().then((prefs) {
      final List<String>? encodedEvents = prefs.getStringList('events');

      if (encodedEvents != null) {
        loadedEvents = encodedEvents.fold({}, (acc, String encodedEvent) {
          final parts = encodedEvent.split('|');
          final DateTime dateTime = DateTime.parse(parts[0]);
          final List<String> titles = parts[1].split(',');
          final List<Event> events = titles.map((title) => Event(title)).toList();
          acc[dateTime] = events;
          return acc;
        });
      }
    });

    return loadedEvents;
  }

  @override
  void initState() {
    super.initState();
    events = loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваше расписание'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Добавить задачу'),
                content: TextField(
                  onChanged: (String value) {
                    _userEvent = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (_userEvent.isNotEmpty) {
                        setState(() {
                          List<Event> dayEvents = events[today] ?? [];
                          dayEvents.add(Event(_userEvent));
                          events[today] = dayEvents;
                          saveEvent(events);
                        });
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Название мероприятия не может быть пустым',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );

                      }
                    },
                    child: Text('Добавить', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, size: 30.0, color: Colors.white),
      ),
      body: Column(
        children: [
          Text('Выбранный день:  ' + today.toString().split(' ')[0]),
          Expanded(
            child: calendar(),
          ),
        ],
      ),
    );
  }

  Widget calendar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            child: TableCalendar(
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 30),
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              rowHeight: 75.0,
              focusedDay: today,
              firstDay: DateTime.utc(2023, 01, 01),
              lastDay: DateTime.utc(2030, 01, 01),
              onDaySelected: _onDaySelected,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Мероприятия в этот день',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: eventsListView(),
          ),
        ],
      ),
    );
  }

  Widget eventsListView() {
    List<Event> dayEvents = events[today] ?? [];
    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('${index + 1}. ${dayEvents[index].title}'),
        );
      },
    );
  }
}
