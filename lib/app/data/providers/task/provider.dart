import 'dart:convert';
import 'package:get/get.dart';
import 'package:to_do_app/app/core/utils/key.dart';
import 'package:to_do_app/app/data/services/storage/services.dart';
import '../../models/task.dart';

class TaskProvider{
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks(){
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString()).forEach((e){
      return tasks.add(Task.fromJson(e));
    });
    return tasks;
  }

  void writeTask(List<Task> tasks){
    _storage.write(taskKey, jsonEncode(tasks));
  }
}

///I define the functions my provider will perform here
///TaskProvider will be able to read from storage and write to storage
///provider references the available function the storage provide and build  on it

