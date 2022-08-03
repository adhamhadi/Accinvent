import 'package:barcode_scanner/screens/widget/profile.dart';
import 'package:barcode_scanner/screens/widget/tabbarmaterialwidget.dart';
import 'package:flutter/material.dart';

import 'main_menu.dart';
class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  int index=0;
  final pages=<Widget>[
    menuPage(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar:
      TabBarMaterialWidget(
        index:index,
        onChangedTab:onChangedTab,
      ),
    );
  }
  void onChangedTab(int index){
    setState(() {
      this.index=index;
    });
  }
}
