import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:to_do_app/app/core/utils/extension.dart';
import 'package:to_do_app/app/widget/icons.dart';
import '../../../core/values/colors.dart';
import '../../../data/models/task.dart';
import '../controller.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>(); //we use this to find the controller
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = getIcons(); //this is a list of Icons
    var squareWidth = Get.width - 12.0.wp;
    return Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(3.0.wp),
        child: InkWell(
            onTap: () async {
              //this is the default Dialog that comes with GetX
              await Get.defaultDialog(
                titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
                title: 'Task Type',
                radius: 5,
                content: Form(
                  key: homeCtrl.formKey,//this allow us keep trade of our form state like validation
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                        child: TextFormField(
                          controller: homeCtrl.editController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                          ),
                          validator: (value) {// we validate the input 
                            if (value == null || value.trim().isEmpty) { //if we don't meet this validation criteria then we pop the error message below
                              return 'Please enter your task title';
                            }
                            return null;
                          },
                        ),
                      ),
                      //this the wrap of icons on the open on a dialog to add new card
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                        child: Wrap(
                          spacing: 2.0.wp,
                          children: icons
                              .map(
                                (e) => Obx(
                                  () {
                                    final index = icons.indexOf(e);
                                    return ChoiceChip(
                                      selectedColor: Colors.grey[200],
                                      pressElevation: 0,
                                      backgroundColor: Colors.white,
                                      label: e, //our label here is an icon
                                      selected:
                                          homeCtrl.chipIndex.value == index, //returns true if the selected index is same as the chipIndex valu from our controller
                                      onSelected: (bool selected) {
                                        homeCtrl.chipIndex.value =
                                            selected ? index : 0; //on selected being true the index of the selected will be highlighted
                                      },
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(150, 40)),
                          onPressed: () {
                            if (homeCtrl.formKey.currentState!.validate()) {
                              int icon = icons[homeCtrl.chipIndex.value]
                                  .icon!
                                  .codePoint;
                              String color = icons[homeCtrl.chipIndex.value]
                                  .color!
                                  .toHex();
                              var task = Task(
                                  title: homeCtrl.editController.text,
                                  icon: icon,
                                  color: color);
                              Get.back();
                              homeCtrl.addTask(task)
                                  ? EasyLoading.showSuccess('Create Success')
                                  : EasyLoading.showError('Duplicated Task');
                            }
                          },
                          child: const Text('Confirm'))
                    ],
                  ),
                ),
              );
              homeCtrl.editController.clear();
              homeCtrl.changeChipIndex(0); // we use this to reset our Choice chip index
            },
            child: DottedBorder( //this is a package for creating dotted border
              color: Colors.grey[400]!,
              dashPattern: const [8, 4],
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 10.0.wp,
                  color: Colors.grey,
                ),
              ),
            )));
  }
}
