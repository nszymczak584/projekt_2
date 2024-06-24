import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/single_to_do.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<SingleToDo>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<SingleToDo>> {
  TodoListNotifier() : super([]) {
    _fetchTasks();
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('todoTasks');

  Future<void> _fetchTasks() async {
    try {
      final querySnapshot = await collection.get();
      state = querySnapshot.docs
          .map((doc) => SingleToDo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

 Future<void> addTask(SingleToDo task) async {
  try {
    // Stworzenie mapy bez pola 'id'
    final dataToAdd = {
      'text': task.text,
      'done': task.done,
    };
    
    // Dodanie mapy do kolekcji
    final docRef = await collection.add(dataToAdd);

    // Aktualizacja lokalnego stanu z nowym `id`
    final newTask = task.copyWith(id: docRef.id);
    state = [...state, newTask]; 
  } catch (e) {
    print('Error adding task: $e');
  }
}

  Future<void> updateTask(String id, bool done) async {
    try {
      await collection.doc(id).update({'done': done});
      state = [
        for (final task in state)
          if (task.id == id) task.copyWith(done: done, id: id) else task
      ];
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await collection.doc(id).delete();
      state = state.where((task) => task.id != id).toList();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
