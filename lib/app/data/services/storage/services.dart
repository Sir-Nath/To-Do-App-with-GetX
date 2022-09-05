import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/app/core/utils/key.dart';

class StorageService extends GetxService{
  late GetStorage _box; //this is an instance of GetStorage made private


  Future<StorageService> init() async {
    _box = GetStorage();
    await _box.writeIfNull(taskKey, []); //this will create a list in our create database
    return this; //we are returning our storage with a created list
  }

  T read<T>(String key){ // our read method takes a string key, read it and return the object saved in that key name
    return _box.read(key);
  }

  void write(String key, dynamic value) async{ // our write method takes an object and an associated key and saves it in the storage
    await _box.write(key, value);
  }
}

///this is the backend storage
/// I initialize the GetStorage storage and create a new list that will take in tasks if it is empty
/// a key will be needed to fetch data from the storage and a key + data will be needed to write into it