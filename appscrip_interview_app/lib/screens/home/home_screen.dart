import 'package:appscrip_interview_app/models/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_providers.dart';
import '../../providers/task_provider.dart';
import '../tasks/taskform_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
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
    final isLoggedIn = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: taskState.tasks.isEmpty && taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskState.tasks.isEmpty
              ? const Center(child: Text('No tasks found'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: taskState.tasks.length + 1,
                  itemBuilder: (context, index) {
                    if (index < taskState.tasks.length) {
                      final Todo task = taskState.tasks[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFormScreen(task: task),
                            ),
                          );
                        },
                        child: Container(
                          height: 100, // Reduced height for a modern look
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task.completed ?? false,
                                onChanged: (value) async {
                                  final updatedTask =
                                      task.copyWith(completed: value);
                                  await ref
                                      .read(taskProvider.notifier)
                                      .updateTask(updatedTask);
                                },
                                activeColor: Colors.blue,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title ?? "",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        decoration: task.completed ?? false
                                            ? TextDecoration
                                                .lineThrough // Strike-through if completed
                                            : TextDecoration.none,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        decoration: task.completed ?? false
                                            ? TextDecoration
                                                .lineThrough // Strike-through if completed
                                            : TextDecoration.none,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await ref
                                      .read(taskProvider.notifier)
                                      .deleteTask(task.id ?? 1);
                                },
                              ),
                            ],
                          ),
                        ),
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
