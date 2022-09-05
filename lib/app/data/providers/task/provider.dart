import 'dart:convert';
import 'package:get/get.dart';
import 'package:to_do_app/app/core/utils/key.dart';
import 'package:to_do_app/app/data/services/storage/services.dart';
import '../../models/task.dart';

class TaskProvider{
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks(){
    var tasks = <Task>[]; // we create an empty list
    jsonDecode(_storage.read(taskKey).toString()).forEach((e){ //read from our storage with the saved key, we return our saved object which we will use the
      //toString method on and decode it after which for each element we get, we add it to the created list after converting it to a Task model
      return tasks.add(Task.fromJson(e));
    });
    return tasks; //we return our filled list
  }

  void writeTask(List<Task> tasks){ // our actual writeTask method will take a list of Task and encode it in json together with a taskKey and save it
    _storage.write(taskKey, jsonEncode(tasks));
  }
}

///I define the functions my provider will perform here
///TaskProvider will be able to read from storage and write to storage
///provider references the available function the storage provide and build  on it

