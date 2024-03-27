class TaskItem {
  bool completed;
  final int id;
  final String task;

  TaskItem({required this.completed, required this.id, required this.task});

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      completed: json['completed'],
      id: json['id'],
      task: json['task'],
    );
  }
}