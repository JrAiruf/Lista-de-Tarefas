import 'package:daily_list/controllers/home_controller.dart';
import 'package:flutter/material.dart';
// ignore_for_file: use_key_in_widget_constructors

class HomeDrawer extends StatelessWidget {
  const HomeDrawer(
      {required this.listColors,
      required this.userColor,
      required this.homeController,
      required this.context});

  final Color userColor;
  final HomeController homeController;
  final BuildContext context;
  final List<Color> listColors;

  @override
  Widget build(BuildContext context) {
    final primaryColor = userColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(33),
        topRight: Radius.circular(33),
      ),
      child: Drawer(
        width: width * 0.8,
        backgroundColor: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: Center(
                          child: SizedBox(
                            height: height * 0.85,
                            width: width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: listColors.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: (() {
                                        homeController.setTheme(listColors[i]);
                                        Navigator.of(context).pop();
                                      }),
                                      child: CircleAvatar(
                                        backgroundColor: listColors[i],
                                        radius: 33,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.color_lens,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Escolha o tema',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 60,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
