import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../components/app_bar_ca.dart';
import '../routes/routes.dart';
import "package:http/http.dart" as http;

class HomeCa extends StatefulWidget {
  const HomeCa({super.key});

  @override
  State<HomeCa> createState() => _HomeCaState();
}

class _HomeCaState extends State<HomeCa> {

  void initState(){
    super.initState();
    _checkUserAndNavigate();
  }
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserCA'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode != 200){
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

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
                _buildFullWidthItem(
                    context,
                    'OFFERTE DI LAVORO\n    PUBBLICATE',
                    AppRoutes.annuncipubblicati),
                _buildFullWidthItem(context, 'COMMUNITY EVENTS\n    PUBBLICATI',
                    AppRoutes.eventipubblicati),
                _buildFullWidthItem(
                    context, 'AGGIUNGI EVENTO', AppRoutes.addevento),
                _buildFullWidthItem(context, 'AGGIUNGI OFFERTA\nDI LAVORO',
                    AppRoutes.addannuncio),
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
              style: const TextStyle(
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
    home: const HomeCa(),
  ));
}
