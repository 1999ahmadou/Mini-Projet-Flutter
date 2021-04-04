import 'package:flutter/material.dart';
class DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.white
                ]
            )
        ),
        child:
            CircleAvatar(
              radius: 700,
              backgroundImage:AssetImage("images/git1.png") ,
            )
    );
  }
}
