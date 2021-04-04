import 'package:flutter/material.dart';
import 'package:github_mobile_app/widgets/mydrower.widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Home"),
      )
    );
  }
}
