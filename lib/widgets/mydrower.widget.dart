import 'package:flutter/material.dart';
import 'package:github_mobile_app/globale/globale.parameters.dart';

import 'drawer.header.widget.dart';
import 'drawer.item.widget.dart';
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeaderWidget(),
          ...(GlobaleParameter.menus).map((item) =>
              DrawerItemWidget(item['title'], item['route'], item['icon'])
          )
        ],
      ),
    ) ;
  }
}
