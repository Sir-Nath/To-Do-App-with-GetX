import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/data/services/storage/repository.dart';
import '../../data/models/task.dart';

class HomeController extends GetxController {

  TaskRepository taskRepository; // our controller need to be in contact with our repo
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();

//.obs is added to all the values that needs to be observed
  final tabIndex = 0.obs; //this is the index for the IndexStacked widget
  final chipIndex = 0.obs; //this is the default index for our chips
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks()); //.assignAll assign all the items from taskRepository.readTask into tasks
    log('before entering ever'); 
    ever(tasks, (_){
      log('before writing task in ever');
      taskRepository.writeTasks(tasks);
    });//ever performs a function whenever tasks changes
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void changeChipIndex(int value) {
    chipIndex.value = value; //this method takes a value and assign it to the observable chipIndex
  }

  bool addTask(Task task) { //this is a method that is called before adding a single task into our list of task
    if (tasks.contains(task)) { // we check if our list already have this task and if it does we abort adding with boolean value
      return false;
    }
    tasks.add(task);
    return true;
  }

//the purpose of this function is to update the deleting variable and use that to perform other function
  void changeDeleting(bool value) { // this method takes a value and assign it to the observable deleting value
    deleting.value = value;
  }

  void deleteTask(Task task) { //this takes a task of type Task and remove it from the list of tasks
    tasks.remove(task);
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  updateTask(Task? task, String title) {
    var todos = task!.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIndex = tasks.indexOf(task);
    tasks[oldIndex] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos.any((element) => mapEquals(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([...doingTodos, ...doneTodos]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIndex = tasks.indexOf(task.value);
    tasks[oldIndex] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

//this is the function responsible for changing the Indexstacked index
  void changeTabIndex(int index){
    tabIndex.value = index; //we assign the value we receive from the funtion to the tabIndex
  }

  int getTotalTask(){
    var res = 0;
    for(int i =0; i < tasks.length; i++){
      if(tasks[i].todos != null){
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

int getTotalDonetask(){
  var res = 0;
  for(int i =0; i < tasks.length; i++){
      if(tasks[i].todos != null){
        for(int j = 0; j < tasks[i].todos!.length; j++){
          if(tasks[i].todos![j]['done'] == true){
            res += 1;
          }
        }
      }
    }
    return res;
}

}
