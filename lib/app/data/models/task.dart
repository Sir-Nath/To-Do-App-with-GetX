import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<Map<String, dynamic>>? todos;

  const Task(
      {required this.color,
      required this.title,
      required this.icon,
      this.todos});

  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<Map<String, dynamic>>? todos,
  }) {
    return Task(
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        todos: todos ?? this.todos);
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        title: json['title'],
        icon: json['icon'],
        color: json['color'],
        todos: json['todos']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'color': color,
      'todos': todos,
    };
  }

  @override
  List<Object?> get props => [title, icon, color];
}

//n

///This is the file for my model i.e how the content of the to-do list will be
///A to-do list is made up of 4 parameters
///I will be saving in my storage as a Json File so i will need  to;
/// convert my to-do to Json to save in storage
/// decode my to-do from json back to my model
/// copyWith allow me change a task