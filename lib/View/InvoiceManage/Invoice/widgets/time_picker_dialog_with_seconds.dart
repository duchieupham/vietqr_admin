import 'package:flutter/material.dart';

class TimePickerDialogWithSeconds extends StatefulWidget {
  final ExtendedTimeOfDay initialTime;

  const TimePickerDialogWithSeconds({Key? key, required this.initialTime})
      : super(key: key);

  @override
  _TimePickerDialogWithSecondsState createState() =>
      _TimePickerDialogWithSecondsState();
}

class _TimePickerDialogWithSecondsState
    extends State<TimePickerDialogWithSeconds> {
  late int _hour;
  late int _minute;
  late int _second;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _second = widget.initialTime.second;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chọn thời gian'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DropdownButton<int>(
                value: _hour,
                onChanged: (newValue) {
                  setState(() {
                    _hour = newValue!;
                  });
                },
                items: List.generate(24, (index) => index)
                    .map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
              ),
              DropdownButton<int>(
                value: _minute,
                onChanged: (newValue) {
                  setState(() {
                    _minute = newValue!;
                  });
                },
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
              ),
              DropdownButton<int>(
                value: _second,
                onChanged: (newValue) {
                  setState(() {
                    _second = newValue!;
                  });
                },
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
                context,
                ExtendedTimeOfDay(
                    hour: _hour, minute: _minute, second: _second));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class ExtendedTimeOfDay {
  final int hour;
  final int minute;
  final int second;

  const ExtendedTimeOfDay(
      {required this.hour, required this.minute, required this.second});

  factory ExtendedTimeOfDay.now() {
    final now = DateTime.now();
    return ExtendedTimeOfDay(
        hour: now.hour, minute: now.minute, second: now.second);
  }

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  ExtendedTimeOfDay copyWith({int? hour, int? minute, int? second}) {
    return ExtendedTimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }
}