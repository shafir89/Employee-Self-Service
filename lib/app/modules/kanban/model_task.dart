class Task {
  int id;
  String title;
  String description;
  String assignedTo;
  DateTime? dueDate;
  String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    this.dueDate,
    required this.status,
  });

  // Membuat dari Map (untuk kemudahan dari JSON)
  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      assignedTo: data['assigned_to'],
      dueDate: data['due_date'] != null ? DateTime.parse(data['due_date']) : null,
      status: data['status'],
    );
  }

  // Mengubah ke Map (untuk JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'due_date': dueDate?.toIso8601String(),
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, assignedTo: $assignedTo, dueDate: $dueDate, status: $status)';
  }
}
