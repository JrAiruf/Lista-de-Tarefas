// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:daily_list/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/todo_model.dart';
import 'home_drawer.dart';

class DailyListHome extends StatefulWidget {
  DailyListHome({Key? key, this.theme}) : super(key: key);

  final Color? theme;
  @override
  State<DailyListHome> createState() => _DailyListHomeState();
}

class _DailyListHomeState extends State<DailyListHome> {
  final _controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    _controller.readData().then((value) {
      final list = jsonDecode(value!) as List;
      setState(() {
        _controller.taskList.value =
            list.map((item) => TodoModel.fromMap(item)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = widget.theme!;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: HomeDrawer(
          context: context,
          homeController: _controller,
          listColors: AppTheme.colors,
          userColor: primaryColor),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
              primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller.taskController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () {
                            final task = TodoModel();
                            task.title = _controller.taskController.text;
                            if (_controller.taskController.text.isNotEmpty) {
                              _controller.addtask(task: task);
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    backgroundColor: primaryColor.withOpacity(0.3),
                    color: primaryColor,
                    onRefresh: () => _controller.refreshList(),
                    child: ListView.builder(
                      itemCount: _controller.taskList.value.length,
                      itemBuilder: ((_, i) {
                        if (_controller.taskList.value.isEmpty) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.3),
                            child: Card(
                              elevation: 15,
                              child: SizedBox(
                                height: height * 0.2,
                                width: width * 0.77,
                                child: Center(
                                  child: Text('Sua Lista está vazia',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor)),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: const Align(
                                alignment: Alignment(-0.9, 0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              final lastRemoved = _controller.taskList.value[i];
                              final positionRemoved = i;
                              _controller.taskList.value.removeAt(i);
                              _controller.saveFile();

                              final snackBar = SnackBar(
                                backgroundColor: primaryColor,
                                content: Text(
                                    "Tarefa ${lastRemoved.title ?? ''} excluída"),
                                action: SnackBarAction(
                                  textColor: Colors.white,
                                  label: 'Desfazer',
                                  onPressed: (() {
                                    setState(() {
                                      _controller.taskList.value
                                          .insert(positionRemoved, lastRemoved);
                                      _controller.saveFile();
                                    });
                                  }),
                                ),
                                duration: const Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            direction: DismissDirection.startToEnd,
                            child: CheckboxListTile(
                              activeColor: primaryColor,
                              value: _controller.taskList.value[i].done!,
                              onChanged: ((value) {
                                setState(() {
                                  _controller.taskList.value[i].done = value;
                                  _controller.saveFile();
                                });
                              }),
                              title: Text(
                                  _controller.taskList.value[i].title ?? ''),
                              secondary: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(
                                  _controller.taskList.value[i].done!
                                      ? Icons.done_rounded
                                      : Icons.warning_amber,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
