import 'package:flutter/material.dart';
import '../../components/app_bar_ca.dart';
import '../routes/routes.dart';
class HomeCa extends StatefulWidget {
  @override
  State<HomeCa> createState() => _HomeCaState();
}

class _HomeCaState extends State<HomeCa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: false,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _buildFullWidthItem(context, 'OFFERTE DI LAVORO\n    PUBBLICATE', AppRoutes.annunci),// va modificata
                _buildFullWidthItem(context, 'COMMUNITY EVENTS\n    PUBBLICATI', AppRoutes.eventi),// va modificata
                _buildFullWidthItem(context, 'AGGIUNGI EVENTO', AppRoutes.eventi), // va modificata
                _buildFullWidthItem(context, 'AGGIUNGI OFFERTA\nDI LAVORO', AppRoutes.annunci),// va modificata
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFullWidthItem(BuildContext context, String title, String route) {
    // Widget per i blocchi rettangolari con testo centrato
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Card(
          color: Colors.blue[200],
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'ReStart',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomeCa(),
  ));
}
