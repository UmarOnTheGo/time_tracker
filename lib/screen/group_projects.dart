import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/project.dart';
import 'package:time_tracker/model/time_entry.dart';
import 'package:time_tracker/provider/project_provider.dart';
import 'package:time_tracker/provider/time_provider.dart';

class GroupByProjects extends StatelessWidget {
  const GroupByProjects({super.key});
  static final routeName = '/Project';

  @override
  Widget build(BuildContext context) {
    double calculateTotalTime(String projectName) {
      final List<TimeEntry> entries = Provider.of<TimeEntriesProvider>(
        context,
        listen: false,
      ).entry;
      // Sum the duration of all entries for the given project
      double totalSeconds = entries
          .where((e) => e.projectName == projectName)
          .fold(0, (sum, e) => sum + e.totalTime);
      return totalSeconds;
    }

    Column fliterWithProjects(String projectName) {
      final List<TimeEntry> entries = Provider.of<TimeEntriesProvider>(
        context,
      ).entry;
      List<String> taskName = entries
          .where((e) => e.projectName == projectName)
          .map((e) => e.taskName)
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: taskName
            .map(
              (name) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(name, style: TextStyle(fontSize: 16)),
              ),
            )
            .toList(),
      );
    }

    return Scaffold(
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          final provider = Provider.of<ProjectProvider>(context);
          final List<Project> projects = provider.projects;
          if (projects.isEmpty) {
            return Center(
              child: Text('Add Time Entry by tapping on + icon below'),
            );
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final Project project = projects[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      '${project.name}\nTotal Time: ${calculateTotalTime(project.name)} Hours',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: fliterWithProjects(project.name),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
