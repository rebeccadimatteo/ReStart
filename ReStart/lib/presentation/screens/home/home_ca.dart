import 'package:flutter/material.dart';

import '../../components/generic_app_bar.dart';


class HomeCA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: false,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            buildCard('Item 1'),
            buildCard('Item 2'),
            buildCard('Item 3'),
            buildCard('Item 4'),
          ],
        ),
      ),
    );
  }
}

Widget buildCard(String text) {
  return SizedBox(
    height: 180,
    child: Card(
      elevation: 50,
      shadowColor: Colors.grey,
      color: Colors.grey,
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center, // Centra il testo
        ),
      ),
    ),
  );
}


void main() {
  runApp(MaterialApp(home: HomeCA()));
}
