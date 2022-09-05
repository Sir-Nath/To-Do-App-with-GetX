
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/app/core/utils/extension.dart';
import 'package:to_do_app/app/modules/home/controller.dart';
class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          (){
            var createdTasks = homeCtrl.getTotalTask();
            var completedTasks = homeCtrl.getTotalDonetask();
            var liveTasks = createdTasks - completedTasks;
            var percent = (completedTasks/createdTasks * 100).toStringAsFixed(0);
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text('My Report',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.bold,
                   ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.0.wp
                  ),
                  child: Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: Colors.grey
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.0.wp,
                    horizontal: 4.0.wp
                  ),
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.0.wp,
                    horizontal: 5.0.wp
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     _buildStatus(
                      Colors.green, liveTasks, 'Live Tasks'
                     ),
                     _buildStatus(
                      Colors.orange, completedTasks, 'Completed'
                     ),
                     _buildStatus(
                      Colors.blue, createdTasks, 'Created'
                     )
                  ],),
                )
              ],
            );

          }
        )
      )
    );
  }
  
 Row _buildStatus(Color color, int number, String text ) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
      height: 3.0.wp,
      width: 3.0.wp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 0.5.wp,
          color: color
        )
      ),
    ),
    SizedBox(width: 3.0.wp,),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$number ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0.sp
        ),
        ),
        SizedBox(height: 2.0.wp),
        Text(text,
        style: TextStyle(color: Colors.grey, fontSize: 12.0.sp ),
        )
      ],)
  ],);
 }
}