import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/task.dart';
import 'package:time_tracker/provider/task_provider.dart';
import 'package:time_tracker/widget/custom_text_widget.dart';

class ManageTasks extends StatefulWidget {
  const ManageTasks({super.key});
  static final String routeName = '/Manage Tasks';

  @override
  State<ManageTasks> createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    saveProject() {
      if (controller.text.isNotEmpty) {
        Task task = Task(name: controller.text.trim());
        Provider.of<TaskProvider>(context, listen: false).addTask(task);
        controller.clear();
        Navigator.of(context).pop();
      }
    }

    deleteProject(String name) {
      Provider.of<TaskProvider>(context, listen: false).removeTaskbyName(name);
    }

    Future<void> showDialogue() async {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CustomTextWidget(controller: controller),
            title: Text('Add New Task'),
            actions: [
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  MaterialButton(
                    onPressed: () => saveProject(),
                    child: Text('Confirm'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Manage Tasks')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final List<Task> tasks = taskProvider.task;
          if (tasks.isEmpty) {
            return Center(child: Text('Add Tasks by tapping on + icon below'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final Task task = tasks[index];
              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(task.name),
                  trailing: GestureDetector(
                    onTap: () => deleteProject(task.name),
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogue(),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
