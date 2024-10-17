// class ProyekModel {
//   final int id;
//   final String name;
//   final List<dynamic> kanbanTasks;

//   ProyekModel({
//     required this.id,
//     required this.name,
//     required this.kanbanTasks,
//   });

//   factory ProyekModel.fromJson(Map<String, dynamic> json) {
//     return ProyekModel(
//       id: json['id'],
//       name: json['name'],
//       kanbanTasks: json['kanban_tasks'],
//     );
//   }
// }





import 'package:get/get.dart';

class AssignedProject {
  final int employeeId;
  final String employeeName;

  AssignedProject({
    required this.employeeId,
    required this.employeeName,
  });

  factory AssignedProject.fromJson(Map<String, dynamic> json) {
    return AssignedProject(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
    );
  }
}

class ProyekModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final String start_date;
  final DateTime end_date;
  final String status;
  final String completed_at;
  final List<AssignedProject> assignedProjects;
  
  ProyekModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.start_date,
    required this.end_date,
    required this.status,
    required this.completed_at,
    required this.assignedProjects,
  });

  factory ProyekModel.fromJson(Map<String, dynamic> json) {
    return ProyekModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? 'tidak ada deskripsi',
      price: json['price'],
      start_date: json['start_date'],
      end_date: DateTime.parse(json['end_date']),
      status: json['status'],
      completed_at: json['completed_at'] ?? '',
      assignedProjects: (json['assigned_projects'] as List?)?.map((assignedProject) =>
        AssignedProject.fromJson(assignedProject)).toList() ?? [],
    );
  }
}
