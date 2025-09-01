import 'package:flutter/material.dart';

class DefaultCalendar extends StatefulWidget {
  const DefaultCalendar({super.key});

  @override
  createState() => _DefaultCalendarState();
}

class _DefaultCalendarState extends State<DefaultCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _navigateToPreviousYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month, 1);
    });
  }

  void _navigateToNextYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month, 1);
    });
  }

  List<Widget> _buildCalendarDays() {
    final List<Widget> days = [];

    final DateTime firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final int daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;

    int weekdayOfFirstDay = firstDayOfMonth.weekday;
    if (weekdayOfFirstDay == 7) {
      weekdayOfFirstDay = 0;
    }

    for (int i = 0; i < weekdayOfFirstDay; i++) {
      days.add(Container()); // Add empty containers for preceding days
    }

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(
        InkWell(
          onTap: () {
            // Handle day selection
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      );
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _navigateToPreviousYear,
            ),
            Text(
              _selectedDate.year.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _navigateToNextYear,
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          children: _buildCalendarDays(),
        ),
      ],
    );
  }
}
