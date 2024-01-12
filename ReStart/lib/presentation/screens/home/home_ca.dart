import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import '../routes/routes.dart';

class HomeCa extends StatefulWidget {
  const HomeCa({super.key});

  @override
  State<HomeCa> createState() => _HomeCaState();
}

class _HomeCaState extends State<HomeCa> {
  Future<void> checkUser(BuildContext context) async {
    var token = await SessionManager().get("token");
    if (token != null) {
      if (!JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForCA)) {
        Navigator.pushNamed(context, AppRoutes.home);
      }
    } else {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUser(context);
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
