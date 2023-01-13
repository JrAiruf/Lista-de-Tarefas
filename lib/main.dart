// ignore_for_file: annotate_overrides
import 'package:daily_list/controllers/home_controller.dart';
import 'package:daily_list/home/daily_list_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    DailyListApp(),
  );
}

class DailyListApp extends StatelessWidget {
  DailyListApp({super.key});

  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetBuilder(
          init: controller,
          builder: (_) {
            return DailyListHome(
              theme: controller.theme.value,
            );
          }),
    );
  }
}