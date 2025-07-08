import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/model/time_entry.dart';

class TimeEntriesProvider extends ChangeNotifier {
  List<TimeEntry> _entries = [];
  final LocalStorage storage;
  get entry => _entries;
  TimeEntriesProvider(this.storage) {
    _loadTimeEntires();
  }
  _loadTimeEntires() {
    var storageItem = storage.getItem('Time');
    if (storageItem != null) {
      final decode = jsonDecode(storageItem);
      _entries = (decode as List<dynamic>)
          .map((item) => TimeEntry.fromJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  savetoStorage() {
    var time = jsonEncode(_entries.map((e) => e.toJson()).toList());
    storage.setItem('Time', time);
  }

  addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    savetoStorage();
    notifyListeners();
  }

  removeTimeEntry(TimeEntry entry) {
    _entries.removeWhere((e) => e.id == entry.id);
    savetoStorage();
    notifyListeners();
  }

  updateTimeEntry(TimeEntry entry) {
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != 1) {
      _entries[index] = entry;
      notifyListeners();
    }
  }
}
