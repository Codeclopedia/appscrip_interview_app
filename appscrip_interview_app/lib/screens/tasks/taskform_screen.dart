import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/todomodel.dart';
import '../../providers/task_provider.dart';
import '../../providers/user_providers.dart';
// Assuming you have this provider

class TaskFormScreen extends ConsumerStatefulWidget {
  final Todo? task;

  const TaskFormScreen({super.key, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String? _priority;
  String? _status;
  int? _assignedUserId;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task?.title ?? '';
      // _descriptionController.text = widget.task?.description ?? '';
      // _dueDate = widget.task?.dueDate;
      // _priority = widget.task?.priority;
      // _status = widget.task?.status;
      // _assignedUserId = widget.task?.assignedUserId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(usersProvider); // Fetch user data

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              ListTile(
                title: Text(_dueDate == null
                    ? 'Select Due Date'
                    : DateFormat.yMMMd().format(_dueDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => _dueDate = pickedDate);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['Low', 'Medium', 'High']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To-Do', 'In Progress', 'Completed']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              userList.when(
                data: (users) {
                  return DropdownButtonFormField<int>(
                    value: _assignedUserId,
                    items: users
                        .map((user) => DropdownMenuItem(
                              value: user.id,
                              child: Text(
                                  "${user.firstName ?? ""} ${user.lastName ?? ""}"),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _assignedUserId = value),
                    decoration:
                        const InputDecoration(labelText: 'Assigned User'),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error loading users: $err'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final task = Todo(
                      id: widget.task?.id ?? 0,
                      title: _titleController.text,
                      // description: _descriptionController.text,
                      // dueDate: _dueDate ?? DateTime.now(),
                      // priority: _priority ?? 'Medium',
                      // status: _status ?? 'To-Do',
                      // assignedUserId: _assignedUserId ?? 1,
                    );

                    try {
                      if (widget.task == null) {
                        await ref.read(taskProvider.notifier).createTask(task);
                      } else {
                        await ref.read(taskProvider.notifier).updateTask(task);
                      }
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Failed to save task: ${e.toString()}"),
                              backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
                child:
                    Text(widget.task == null ? 'Create Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
