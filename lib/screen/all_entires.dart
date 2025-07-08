import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/model/time_entry.dart';
import 'package:time_tracker/provider/time_provider.dart';
import 'package:time_tracker/screen/add_time.dart';

class AllEntires extends StatelessWidget {
  const AllEntires({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TimeEntriesProvider>(
        builder: (context, timeProvider, child) {
          final provider = Provider.of<TimeEntriesProvider>(context);
          final List<TimeEntry> entries = provider.entry;
          if (entries.isEmpty) {
            return Center(
              child: Text('Add Time Entry by tapping on + icon below'),
            );
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final TimeEntry entry = entries[index];
              return Slidable(
                key: ValueKey(entry.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => provider.removeTimeEntry(entry),
                      backgroundColor: Colors.red,
                      icon: Icons.delete_forever,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (_) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddTime(timeEntry: entry),
                        ),
                      ),
                      backgroundColor: Colors.amber,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: double.infinity, height: 0.1),
                          Text(
                            '${entry.projectName} - ${entry.taskName}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Time: ${entry.totalTime} hours',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(entry.date)}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Note: ${entry.note}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
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
