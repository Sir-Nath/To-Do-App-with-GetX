import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/app/data/services/storage/repository.dart';
import '../../data/models/task.dart';

class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({
    required this.taskRepository
});
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks =<Task>[].obs;
  final task = Rx<Task?>(null);

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
   editController.dispose();
    super.onClose();
  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }

  bool addTask(Task task){
    if(tasks.contains(task)){
      return false;
    }
    tasks.add(task);
    return true;
  }

  void changeDeleting(bool value){
    deleting.value = value;
  }

  void deleteTask(Task task){
    tasks.remove(task);
  }

  void changeTask(Task? select){
    task.value = select;
  }
  
}