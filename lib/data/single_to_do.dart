class SingleToDo {
  final String id;
  final String text;
  final bool done;

  SingleToDo({required this.id, required this.text, this.done = false});

  SingleToDo copyWith({String? id, String? text, bool? done}) {
    return SingleToDo(
      id: id ?? this.id,
      text: text ?? this.text,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'done': done,
    };
  }
  
static SingleToDo fromMap(Map<String, dynamic> map, String id) {
  return SingleToDo(
    id: id,
    text: map['text'],
    done: map['done'] ?? false,
  );
}
}
