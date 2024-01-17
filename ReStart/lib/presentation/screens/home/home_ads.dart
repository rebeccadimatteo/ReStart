import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import "package:http/http.dart" as http;
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';
class HomeAds extends StatefulWidget {
  @override
  State<HomeAds> createState() => _HomeAdsState();
}

class _HomeAdsState extends State<HomeAds> {

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserADS'),
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
      appBar: AdsAppBar(
        showBackButton: false,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
          body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomScrollView(
          slivers: [
          SliverPadding(
          padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _buildGridItem(context, 'OFFERTE DI LAVORO', AppRoutes.annunciAds),
                _buildGridItem(context, 'ALLOGGI TEMPORANEI', AppRoutes.alloggiAds),
                _buildGridItem(context, 'CORSI DI FORMAZIONE', AppRoutes.corsiAds),
                _buildGridItem(context, 'SUPPORTO MEDICO', AppRoutes.supportiAds),
              ]),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _buildFullWidthItem(context, 'COMMUNITY EVENTS', AppRoutes.eventiAds),
                _buildFullWidthItem(context, 'RICHIESTE DA APPROVARE', AppRoutes.richiesteAds),
              ],
            ),
          ),
        ],
      ),
          ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String route) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            splashColor: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFullWidthItem(BuildContext context, String title, String route) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            splashColor: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


void main() {
  runApp(MaterialApp(
    title: 'ReStart',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomeAds(),
  ));
}
