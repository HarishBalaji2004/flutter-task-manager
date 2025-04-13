import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _taskNameController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedPriority;

  // Select Date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Select Time
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Save Task
  void _saveTask() {
    if (_taskNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields before saving")),
      );
      return;
    }

    Map<String, dynamic> newTask = {
      'name': _taskNameController.text,
      'date': "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
      'time': _selectedTime!.format(context),
      'priority': _selectedPriority
    };

    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task'), backgroundColor: Colors.redAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 16.0),

            // Date & Time Selection
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () => _selectTime(context),
                      ),
                    ),
                    controller: TextEditingController(
                      text: _selectedTime == null ? '' : _selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Priority Selection
            Text("Priority", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3].map((priority) {
                Color priorityColor = priority == 1 ? Colors.red : (priority == 2 ? Colors.orange : Colors.green);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _selectedPriority == priority ? priorityColor : Colors.white,
                      border: Border.all(color: priorityColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        if (_selectedPriority == priority)
                          BoxShadow(
                            color: priorityColor.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        priority.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _selectedPriority == priority ? Colors.white : priorityColor,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: Text("Save Task", style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
