import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final String title;

  NavBar({
    Key key,
    @required this.title
  }) : super(key: key);

  @override 
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title)
    );
  }
}
