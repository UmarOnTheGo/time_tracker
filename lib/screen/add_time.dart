import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/model/time_entry.dart';
import 'package:time_tracker/provider/project_provider.dart';
import 'package:time_tracker/provider/task_provider.dart';
import 'package:time_tracker/provider/time_provider.dart';
import 'package:time_tracker/widget/custom_text_widget.dart';

class AddTime extends StatefulWidget {
  const AddTime({super.key, this.timeEntry});
  static final String routeName = '/Add Time';
  final TimeEntry? timeEntry;
  @override
  State<AddTime> createState() => _AddTimeState();
}

String? validate(dynamic value) {
  if (value == null) {
    return 'Please select an option';
  } else {
    return null;
  }
}

class _AddTimeState extends State<AddTime> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  Task? _selectedTask;
  Project? _selectedProject;
  DateTime currentDate = DateTime.now();
  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(currentDate);
      });
    }
  }

  saveTimeEntry() {
    if (_noteController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _selectedTask != null &&
        _selectedProject != null) {
      final TimeEntry time = TimeEntry(
        projectName: _selectedProject!.name,
        taskName: _selectedTask!.name,
        totalTime: double.parse(_timeController.text),
        date: currentDate,
        note: _noteController.text.trim(),
      );
      final provider = Provider.of<TimeEntriesProvider>(context, listen: false);
      if (widget.timeEntry == null) {
        provider.addTimeEntry(time);
      } else {
        provider.updateTimeEntry(time);
      }
      Navigator.pop(context);
    } else {
      (
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'There is some missing fields',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green.shade700,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final TimeEntry? time = widget.timeEntry;
    if (time != null) {
      _noteController.text = time.note;
      _dateController.text = DateFormat('yyyy-MM-dd').format(time.date);
      _timeController.text = time.totalTime.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
    _timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Time Entry')),
      body: Consumer2<TaskProvider, ProjectProvider>(
        builder: (context, taskProvider, projectProvider, child) {
          final List<Task> tasks = taskProvider.task;
          final List<Project> projects = projectProvider.projects;
          return Padding(
            padding: EdgeInsetsGeometry.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<Task>(
                    iconDisabledColor: Colors.green,
                    iconEnabledColor: Colors.amber,
                    disabledHint: tasks.isEmpty
                        ? Text('Please Add task first.')
                        : null,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      label: Text('Tasks'),
                      focusColor: Colors.green.shade700,
                    ),
                    items: tasks
                        .map(
                          (task) => DropdownMenuItem<Task>(
                            value: task,
                            child: Text(task.name),
                          ),
                        )
                        .toList(),
                    onChanged: (Task? value) {
                      _selectedTask = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an option';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<Project>(
                    iconDisabledColor: Colors.green,
                    iconEnabledColor: Colors.amber,
                    disabledHint: projects.isEmpty
                        ? Text('Please Add project first.')
                        : null,
                    borderRadius: BorderRadius.circular(8.0),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                      label: Text('Projects'),
                      focusColor: Colors.green.shade700,
                    ),
                    items: projects
                        .map(
                          (project) => DropdownMenuItem<Project>(
                            value: project,
                            child: Text(project.name),
                          ),
                        )
                        .toList(),
                    onChanged: (Project? value) {
                      _selectedProject = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an option';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                CustomTextWidget(
                  controller: _timeController,
                  text: 'Time in Hours',
                  textInputType: TextInputType.number,
                ),
                CustomTextWidget(controller: _noteController, text: 'Note'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.edit_calendar_outlined,
                        color: Colors.green.shade700,
                      ),
                      labelText: 'Date',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.green.shade700),
                      ),

                      focusColor: Colors.green.shade700,
                    ),
                    readOnly: true,
                    controller: _dateController,
                    onTap: () {
                      selectDate();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: MaterialButton(
                    color: Colors.amber,
                    onPressed: saveTimeEntry,
                    child: Text(
                      widget.timeEntry == null ? 'Confirm' : 'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
