import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/single_to_do.dart';
import '../providers/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListPage extends ConsumerWidget {
  final User? user;

  const ListPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do list:'),
      ),
      body: todoList.isEmpty
          ? const Center(child: Text('No tasks added.'))
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return ToDoElement(todo: todo, index: index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, ref);
        },
        child: const Icon(Icons.add_circle),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new task'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final String text = _controller.text;
              if (text.isNotEmpty) {
                final newTask = SingleToDo(
                  id: DateTime.now().toString(),
                  text: text,
                  done: false,
                );
                ref.read(todoListProvider.notifier).addTask(newTask);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class ToDoElement extends ConsumerWidget {
  const ToDoElement({super.key, required this.todo, required this.index});

  final SingleToDo todo;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(todo.text),
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          ref.read(todoListProvider.notifier).updateTask(todo.id, value!);
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          ref.read(todoListProvider.notifier).deleteTask(todo.id);
        },
      ),
    );
  }
}
