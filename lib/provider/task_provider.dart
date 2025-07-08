import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/model/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _task = [];
  List<Task> get task => _task; // Strongly typed getter
  final LocalStorage _storage;

  TaskProvider(this._storage) {
    _loadTaskfromStorage();
  }

  void _loadTaskfromStorage() {
    var storageItem = _storage.getItem('Task');
    if (storageItem != null) {
      final decode = jsonDecode(storageItem);
      _task = (decode as List<dynamic>)
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  void savetoStorage() {
    var task = jsonEncode(_task.map((e) => e.toJson()).toList());
    _storage.setItem('Task', task); // ✅ Fixed key
  }

  void addTask(Task entry) {
    _task.add(entry);
    savetoStorage();
    notifyListeners();
  }

  void removeTaskbyName(String name) {
    _task.removeWhere((e) => e.name == name);
    savetoStorage();
    notifyListeners();
  }
}
