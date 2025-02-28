import 'package:flutter/material.dart';

import '../../models/todomodel.dart';

class TaskDetailScreen extends StatelessWidget {
  final Todo task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task.title}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            // Text('Description: ${task.description}'),
            // const SizedBox(height: 10),
            // Text('Due Date: ${task.dueDate.toString()}'),
            // const SizedBox(height: 10),
            // Text('Priority: ${task.priority}'),
            // const SizedBox(height: 10),
            // Text('Status: ${task.status}'),
            // const SizedBox(height: 10),
            // Text('Assigned User ID: ${task.assignedUserId}'),
          ],
        ),
      ),
    );
  }
}
