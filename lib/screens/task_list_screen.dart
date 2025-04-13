import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks when app starts
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskData = prefs.getString('tasks');

    if (taskData != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(taskData));
      });
    }
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(tasks));
  }

  // Remove a task and update SharedPreferences
  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Navigate to AddTaskScreen and save new task
  void _navigateToAddTaskScreen() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        tasks.sort((a, b) => a['priority'].compareTo(b['priority'])); // Sort by priority
      });
      _saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Task Manager")), backgroundColor: Colors.redAccent),
      body: tasks.isEmpty
          ? Center(child: Text("No tasks added yet"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // Assign colors based on priority
                Color priorityColor = task['priority'] == 1 ? Colors.red : (task['priority'] == 2 ? Colors.orange : Colors.green);

                return Dismissible(
                  key: Key(task['name'] + task['date'] + task['time']), // Unique key for each task
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  direction: DismissDirection.endToStart, // Swipe from right to left
                  onDismissed: (direction) {
                    _removeTask(index);
                  },
                  child: Card(
                    color: Colors.red[100],
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Date: ${task['date']} | Time: ${task['time']}", style: TextStyle(fontSize: 14)),
                          SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Priority: ${task['priority']}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
