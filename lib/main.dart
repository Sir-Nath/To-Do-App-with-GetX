import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/app/data/services/storage/services.dart';
import 'package:to_do_app/app/modules/home/binding.dart';

import 'app/modules/home/view.dart';

void main() async{
  await GetStorage.init(); //this will initiate the GetStorage for data storage
  await Get.putAsync(() => StorageService().init()); //this asynchronous method in the StorageService needs to be called before other things start
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      debugShowCheckedModeBanner: false,
      title: 'Todo List With GetX',
      home: const HomePage(),
      initialBinding: HomeBinding(), //this will be our initial binding
      builder: EasyLoading.init(), //this will initiate our easy loading package
    );
  }
}