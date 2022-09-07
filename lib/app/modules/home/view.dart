import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/core/utils/extension.dart';
import 'package:to_do_app/app/modules/home/controller.dart';
import 'package:to_do_app/app/modules/home/widgets/add_card.dart';
import 'package:to_do_app/app/modules/home/widgets/add_dialog.dart';
import 'package:to_do_app/app/modules/home/widgets/task_card.dart';
import 'package:to_do_app/app/modules/report/view.dart';
import '../../data/models/task.dart';

class HomePage extends GetView<HomeController> {
  //using GetView makes our specified controller available to the widget tree and we access it by using the keyword controller
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        (() =>  IndexedStack(//indexedStack is best used for routing pages using bottom navigation bar
          index: controller.tabIndex.value,
          children: [
            //the safeArea is of index 0 in thr the indexed Stack
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0.wp),
                    child: Text(
                      'My List',
                      style: TextStyle(
                          fontSize: 24.0.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true, //shrinkWrap lets the GirdView take the space required of it child as it by default wants to take all 
                      //the size it parent provides
                      physics: const ClampingScrollPhysics(), //this is the default scrolling physics of android
                      children: [
                        ...controller.tasks
                            .map((element) => LongPressDraggable( //when we map tasks from controller we get an iterable of our tasks
                                data: element, //data takes the widget that will be used in Drag Target widget
                                onDragStarted: () =>
                                    controller.changeDeleting(true), //this will turn the floating action  button red and display bin
                                onDraggableCanceled: (_, __) =>
                                    controller.changeDeleting(false),
                                onDragEnd: (_) =>
                                    controller.changeDeleting(false),
                                    //feedback is what the user sees immediately he long press the widget to drag it
                                feedback: Opacity(
                                  opacity: 0.8,
                                  child: TaskCard(task: element),
                                ),
                                child: TaskCard(task: element),),)
                            .toList(),
                        // ignore: todo
                        //TODO later
                        AddCard(), 
                      ],
                    ),
                  )
                ],
              ),
            ),
            //ReportPage is of Index1 in the indexed stack
            ReportPage(), //check out page later
          ],
        )
      ),
      
    ),
floatingActionButton: DragTarget(
        builder: (_, __, ___) {
          return Obx(() {
            return FloatingActionButton(
              backgroundColor:
              //this is there the observable deleting variable becomes useful
                  controller.deleting.value ? Colors.red : Colors.blue,
              onPressed: () {
                //this will only work if there was already a task to which to add new task content

                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                  //if we can't go into the AddDialog because of empty task list then we pop this up
                } else {
                  EasyLoading.showInfo('Please create your task type');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
              ),
            );
          });
        },
        //on accept takes the data variable from the long draggable widget which is of Type task
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete Success');
        },
      ),
      //this is for setting the floating action button direction
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
        ),

        child: Obx(
          () =>  BottomNavigationBar(
            onTap: (index) => controller.changeTabIndex(index), //the bottom Nav bar item has it index and is ordered to fit the order
            //of the IndexStacked items
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Padding(
                  padding: EdgeInsets.only(right: 15.0.wp),
                  child: const Icon(Icons.apps),
                ),
              ),
              BottomNavigationBarItem(
                  label: 'Report',
                  icon: Padding(
                      padding: EdgeInsets.only(left: 15.0.wp),
                      child: const Icon(Icons.data_usage),),)
            ],
          ),
        ),
      ),
    );
  }
}
