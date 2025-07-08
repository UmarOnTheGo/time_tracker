import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/model/project.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  final LocalStorage storage;
  List<Project> get projects => _projects;
  ProjectProvider(this.storage) {
    _loadTimeEntires();
  }
  void _loadTimeEntires() {
    var storageItem = storage.getItem('Projects');
    if (storageItem != null) {
      final decode = jsonDecode(storageItem);
      _projects = (decode as List<dynamic>)
          .map((item) => Project.fromJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  savetoStorage() {
    var project = jsonEncode(_projects.map((e) => e.toJson()).toList());
    storage.setItem('Projects', project);
  }

  addProject(Project entry) {
    _projects.add(entry);
    savetoStorage();
    notifyListeners();
  }

  removeProjectbyName(String name) {
    _projects.removeWhere((e) => e.name == name);
    savetoStorage();
    notifyListeners();
  }
}
