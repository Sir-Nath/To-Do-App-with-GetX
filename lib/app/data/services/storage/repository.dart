import 'package:to_do_app/app/data/providers/task/provider.dart';
import '../../models/task.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({
    required this.taskProvider
});
  List<Task> readTasks(){ //this is us repeating the code from the provider but in a much simpler way
    return taskProvider.readTasks();
  }

  void writeTasks(List<Task> task){
    return taskProvider.writeTask(task);
  }

}

//my repo takes my provider and make available the function the provider provides