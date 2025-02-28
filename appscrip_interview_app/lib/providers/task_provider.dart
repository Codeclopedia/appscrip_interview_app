import 'package:appscrip_interview_app/core/network_client.dart';
import 'package:appscrip_interview_app/models/todomodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
});

class TaskState {
  final List<Todo> tasks;
  final int page;
  final bool isLoading;
  final bool hasMore;

  TaskState({
    required this.tasks,
    required this.page,
    required this.isLoading,
    required this.hasMore,
  });

  TaskState copyWith({
    List<Todo>? tasks,
    int? page,
    // bool? isLoading,
    bool? hasMore,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier()
      : super(TaskState(
          tasks: [],
          page: 1,
          isLoading: false,
          hasMore: true,
        ));

  // Load tasks with pagination
  Future<void> loadTasks() async {
    print("inside load task");
    if (state.isLoading || !state.hasMore) return;
    print("inside load task 2");
    // state = state.copyWith(isLoading: true);
    print("inside load task 3");
    try {
      final newTasks =
          await NetworkClient().getTasks(page: state.page, onError: () {});
      print("inside load task 4");
      state = state.copyWith(
        tasks: [...state.tasks, ...newTasks],
        page: state.page + 1,
        // isLoading: false,
        hasMore: newTasks.isNotEmpty,
      );
    } catch (e) {
      // state = state.copyWith(isLoading: false);
      throw Exception("Failed to load tasks: ${e.toString()}");
    }
  }

  // Create a new task
  Future<void> createTask(Todo task) async {
    try {
      final newTask = await NetworkClient().createTask(task);
      state = state.copyWith(
        tasks: [
          newTask,
          ...state.tasks
        ], // Add the new task to the top of the list
      );
    } catch (e) {
      throw Exception("Failed to create task: ${e.toString()}");
    }
  }

  // Update an existing task
  Future<void> updateTask(Todo task) async {
    try {
      final updatedTask = await NetworkClient().updateTask(task);
      state = state.copyWith(
        tasks: state.tasks
            .map((t) => t.id == updatedTask.id ? updatedTask : t)
            .toList(),
      );
    } catch (e) {
      throw Exception("Failed to update task: ${e.toString()}");
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await NetworkClient().deleteTask(id);
      state = state.copyWith(
        tasks: state.tasks.where((task) => task.id != id).toList(),
      );
    } catch (e) {
      throw Exception("Failed to delete task: ${e.toString()}");
    }
  }
}
