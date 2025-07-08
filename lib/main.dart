import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/provider/project_provider.dart';
import 'package:time_tracker/provider/task_provider.dart';
import 'package:time_tracker/provider/time_provider.dart';
import 'package:time_tracker/screen/add_time.dart';
import 'package:time_tracker/screen/home.dart';
import 'package:time_tracker/screen/manage_projects.dart';
import 'package:time_tracker/screen/manage_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TimeEntriesProvider(localStorage),
        ),
        ChangeNotifierProvider(create: (_) => ProjectProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => TaskProvider(localStorage)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          color: Colors.green.shade700,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        buttonTheme: ButtonThemeData(buttonColor: Colors.yellow.shade700),
      ),
      routes: {
        Home.routeName: (context) => Home(),
        ManageProject.routeName: (context) => ManageProject(),
        ManageTasks.routeName: (context) => ManageTasks(),
        AddTime.routeName: (context) => AddTime(),
      },
      home: Home(),
    );
  }
}
