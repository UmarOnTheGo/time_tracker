import 'package:flutter/material.dart';
import 'package:time_tracker/screen/add_time.dart';
import 'package:time_tracker/screen/manage_projects.dart';
import 'package:time_tracker/screen/group_projects.dart';
import 'package:time_tracker/screen/manage_tasks.dart';
import 'all_entires.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static final String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.green.shade700,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green.shade700),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Manage Projects',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.folder, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, ManageProject.routeName);
                },
              ),
              ListTile(
                title: Text(
                  'Manage Tasks',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.folder, color: Colors.white),
                onTap: () {
                  Navigator.pushNamed(context, ManageTasks.routeName);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Time Tracking',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(8.0),
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            tabs: [Text('All Entries'), Text('By Projects')],
          ),
        ),
        body: TabBarView(children: [AllEntires(), GroupByProjects()]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.pushNamed(context, AddTime.routeName);
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
