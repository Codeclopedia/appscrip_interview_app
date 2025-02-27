import 'package:appscrip_interview_app/models/taskmodel.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Todo task;

  const TaskDetailScreen({required this.task});

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
            Text('Description: ${task.description}'),
            const SizedBox(height: 10),
            Text('Due Date: ${task.dueDate.toString()}'),
            const SizedBox(height: 10),
            Text('Priority: ${task.priority}'),
            const SizedBox(height: 10),
            Text('Status: ${task.status}'),
            const SizedBox(height: 10),
            Text('Assigned User ID: ${task.assignedUserId}'),
          ],
        ),
      ),
    );
  }
}
