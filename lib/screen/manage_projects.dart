import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/provider/project_provider.dart';
import 'package:time_tracker/widget/custom_text_widget.dart';

class ManageProject extends StatefulWidget {
  const ManageProject({super.key});
  static final String routeName = '/Manage Project';

  @override
  State<ManageProject> createState() => _ManageProjectState();
}

class _ManageProjectState extends State<ManageProject> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    saveProject() {
      if (controller.text.isNotEmpty) {
        Project project = Project(name: controller.text.trim());
        Provider.of<ProjectProvider>(
          context,
          listen: false,
        ).addProject(project);
        controller.clear();
        Navigator.of(context).pop();
      }
    }

    deleteProject(String name) {
      Provider.of<ProjectProvider>(
        context,
        listen: false,
      ).removeProjectbyName(name);
    }

    Future<void> showDialogue() async {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CustomTextWidget(controller: controller),

            title: Text('Add New Project'),
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
      appBar: AppBar(title: Text('Manage Project')),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final List<Project> projects = projectProvider.projects;
          if (projects.isEmpty) {
            return Center(
              child: Text('Add Projects by tapping on + icon below'),
            );
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final Project project = projects[index];
              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(project.name),
                  trailing: GestureDetector(
                    onTap: () => deleteProject(project.name),
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
