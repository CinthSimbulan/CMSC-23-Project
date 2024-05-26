import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final ValueChanged<DateTime> callback;
  DateTime? selectedDateTime;

  DateTimePicker({required this.callback, this.selectedDateTime});

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  // DateTime? _selectedDateTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(widget.selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          widget.selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        widget.callback(widget.selectedDateTime!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(widget.selectedDateTime == null
              ? 'Select Date and Time'
              : 'Selected: ${widget.selectedDateTime!.toLocal()}'),
        ),
      ],
    );
  }
}
