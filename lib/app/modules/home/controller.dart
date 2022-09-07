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
  final tasks = <Task>[].obs; //personal //work
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks()); //.assignAll assign all the items from taskRepository.readTask into tasks
    ever(tasks, (_){
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
    task.value = select; //this is where we switch our task
  }

  void changeTodos(List<dynamic> select) { //these is the function where we split out todo into done and doing
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

  updateTask(Task? task, String text) {
    var todos = task!.todos ?? <Map<String, dynamic>>[];
    if (containTodo(todos, text)) { //if we have a todo of the same title then we return false
      return false;
    }
    var todo = {'title': text, 'done': false}; //else we create a new todo and assign the text gotten into it
    todos.add(todo); // we then add it to our list of todos
    var newTask = task.copyWith(todos: todos); //we then update out Task(personal, work) which is of type Task
    int oldIndex = tasks.indexOf(task); //we then look for the position of the given task in the list of Tasks
    tasks[oldIndex] = newTask; // we replace the postion with the updated task
    tasks.refresh(); // we then refresh 
    return true;// and send true
  }

  bool containTodo(List todos, String title) { // check a list of todos in a task and compare with a given title/text 
  //and return true if it contains it
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(String title) { //this is the function that add to-do by checking if there exist no such first before adding a new note
    var todo = {'title': title, 'done': false};
    //this statement check if we already have an existing todo as inputted in the list of doingTodos
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    //this statement check if we already have an existing todo as inputted in the list of doneTodos and for both case return false
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos.any((element) => mapEquals(doneTodo, element))) {
      return false;
    }
    
    //if there exist no such note then we add the map of todo into our doingTodos
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[]; // a to do is a map of string and dynamic
    newTodos.addAll([...doingTodos, ...doneTodos]); //we add all the doing and done todos into our new Todos
    var newTask = task.value!.copyWith(todos: newTodos); //we update our task with the new list of todos
    int oldIndex = tasks.indexOf(task.value); // we look for the very task
    tasks[oldIndex] = newTask; //replace
    tasks.refresh(); // and refresh
  }

  void doneTodo(String title) { //this function add todos into done
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere( //we locate the index of our undone todo in the list of doing Todo
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index); //and remove it from todo
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo); // and add it afresh into done todo
    doingTodos.refresh(); //we then refreesh both doingtodos
    doneTodos.refresh(); // and done
  }

  void deleteDoneTodo(dynamic doneTodo) { //this funtion delete a done todo
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element)); //we locate the done todo index
    doneTodos.removeAt(index); // and use the index to remove from our list of done todo
    doneTodos.refresh(); // and we refresh
  }

  bool isTodoEmpty(Task task) { // this check if our todo is empty or null
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) { // this funtion get the number of done todo
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) { // we iterate through the todo
      if (task.todos![i]['done'] == true) {//and for every todo that is done
        res += 1; //we increase the variable by one
      }
    }
    return res;
  }

//this is the function responsible for changing the Indexstacked index
  void changeTabIndex(int index){
    tabIndex.value = index; //we assign the value we receive from the funtion to the tabIndex
  }

  int getTotalTask(){ //this get the number of task available
    var res = 0;
    for(int i =0; i < tasks.length; i++){
      if(tasks[i].todos != null){ //if the todo of the task checked is not null
        res += tasks[i].todos!.length; // we increase the res with the number of todos in it
      }
    }
    return res; //and return it
  }

int getTotalDonetask(){ //theis function get the number of done task/todo all over the tasks
  var res = 0;
  for(int i =0; i < tasks.length; i++){
      if(tasks[i].todos != null){//we check through the whole task if they are not null
        for(int j = 0; j < tasks[i].todos!.length; j++){ //then we go through the todos in the non null task
          if(tasks[i].todos![j]['done'] == true){ // we then fetch out the done todos
            res += 1; // and increase our res by
          }
        }
      }
    }
    return res;
}

}
