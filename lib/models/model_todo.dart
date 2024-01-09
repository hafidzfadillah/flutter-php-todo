import 'dart:convert';

class ModelTodo {
    String todoId;
    String todoTitle;
    String todoDesc;
    String todoStatus;
    DateTime todoDeadline;
    String userId;
    DateTime timestamp;

    ModelTodo({
        required this.todoId,
        required this.todoTitle,
        required this.todoDesc,
        required this.todoStatus,
        required this.todoDeadline,
        required this.userId,
        required this.timestamp,
    });

    factory ModelTodo.fromRawJson(String str) => ModelTodo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ModelTodo.fromJson(Map<String, dynamic> json) => ModelTodo(
        todoId: json["todo_id"],
        todoTitle: json["todo_title"],
        todoDesc: json["todo_desc"],
        todoStatus: json["todo_status"],
        todoDeadline: DateTime.parse(json["todo_deadline"]),
        userId: json["user_uid"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "todo_id": todoId,
        "todo_title": todoTitle,
        "todo_desc": todoDesc,
        "todo_status": todoStatus,
        "todo_deadline": todoDeadline.toIso8601String(),
        "user_id": userId,
        "timestamp": timestamp.toIso8601String(),
    };
}
