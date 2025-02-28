import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/task_provider.dart';
import 'taskform_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(taskProvider.notifier).loadTasks(); // Load initial tasks
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(taskProvider.notifier).loadTasks(); // Load more tasks
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: taskState.tasks.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index < taskState.tasks.length) {
            final task = taskState.tasks[index];
            return ListTile(
              title: Text(task.title ?? ''),
              // subtitle: Text(task.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await ref
                      .read(taskProvider.notifier)
                      .deleteTask(task.id ?? 1);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(task: task),
                  ),
                );
              },
            );
          } else if (taskState.hasMore) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox(); // No more tasks to load
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
