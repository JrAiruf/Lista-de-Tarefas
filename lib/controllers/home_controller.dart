import 'dart:convert';
import 'dart:io';
import 'package:daily_list/theme/app_theme.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import '../models/todo_model.dart';

class HomeController extends GetxController {
  final taskController = TextEditingController();
  final taskList = Rx(<TodoModel>[]);
  var theme = Rx(AppTheme.black);

  void addtask({required TodoModel task}) async {
    task.done = false;
    taskController.clear();
    taskList.value.add(task);
    update();
    await saveFile();
  }

  Future<File> getFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/task.json");
  }

  Future<File> saveFile() async {
    final data =
        jsonEncode(taskList.value.map((item) => item.toMap()).toList());
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String?> readData() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<List<TodoModel>> refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    taskList.value.sort((a, b) {
      if (a.done! && !b.done!) {
        return 1;
      } else if (!a.done! && b.done!) {
        return -1;
      } else {
        return 0;
      }
    });
    saveFile();
    update();
    return taskList.value;
  }

  Future<Color> setTheme(Color themeColor) async {
    theme.value = themeColor;
    update();
    return theme.value;
  }
}
