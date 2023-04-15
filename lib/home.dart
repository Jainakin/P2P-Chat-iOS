// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<MenuData> menu = [
    MenuData(
      icon: Icons.connect_without_contact,
      title: "BROWSER",
    ),
    MenuData(
      icon: Icons.wifi_tethering_rounded,
      title: "ADVERTISER",
    )
  ];

  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0021F3),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Offline Chat",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: menu.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.25,
              crossAxisCount: 1,
              crossAxisSpacing: 0.5,
              mainAxisSpacing: 1.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, menu[index].title.toLowerCase()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        menu[index].icon,
                        size: 60,
                        color: const Color(0xFF0021F3),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        menu[index].title == "BROWSER"
                            ? "BROWSER"
                            : "ADVERTISER",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MenuData {
  late IconData icon;
  late String title;
  MenuData({
    required this.icon,
    required this.title,
  });
}
