import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Menu drawer'),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            size: 40,
          ),
          title: Text('First item'),
          subtitle: Text("This is the 1st item"),
          trailing: Icon(Icons.more_vert),
          onTap: () {},
        ),
        ListTile(
          title: Text('Second item'),
          onTap: () {},
        ),
      ],
    );
  }
}
