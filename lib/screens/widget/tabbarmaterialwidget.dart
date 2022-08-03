
import 'package:flutter/material.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int>onChangedTab;

  const TabBarMaterialWidget({Key? key, required this.index, required this.onChangedTab}) : super(key: key);

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 55.0,
        child: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTabItem(index: 0, icon: Icon(Icons.home,size: 35.0,)),
            buildTabItem(index: 1, icon: Icon(Icons.person,size: 35.0,))
          ],
        ),
    ),
      );
  }
 Widget buildTabItem({
   required int index,
   required Icon icon
 }){
    final isSelected=index==widget.index;
    return IconTheme(
      data: IconThemeData(
        color: isSelected? Colors.blueAccent:Colors.black54
      ),
      child: IconButton(onPressed: ()=>widget.onChangedTab(index),
          icon: icon,
      ),
    );
  }
}
