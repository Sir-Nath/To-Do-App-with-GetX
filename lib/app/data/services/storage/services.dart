import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/app/core/utils/key.dart';

class StorageService extends GetxService{
  late GetStorage _box;

  Future<StorageService> init() async {
    _box = GetStorage();
    await _box.writeIfNull(taskKey, []);
    return this;
  }

  T read<T>(String key){
    return _box.read(key);
  }

  void write(String key, dynamic value) async{
    await _box.write(key, value);
  }
}

///this is the backend storage
/// I initialize the GetStorage storage and create a new list that will take in tasks if it is empty
/// a key will be needed to fetch data from the storage and a key + data will be needed to write into it