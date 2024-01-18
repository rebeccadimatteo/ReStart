import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../model/entity/utente_DTO.dart';
import '../../utils/jwt_utils.dart';
import '../screens/login_signup/start.dart';
import '../screens/routes/routes.dart';

import 'package:http/http.dart' as http;

/// Classe che builda il widget per mostrare una [AppBar].
class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  /// Costruttore per [GenericAppBar].
  GenericAppBar({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF80DEEA),
      automaticallyImplyLeading: showBackButton,
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.homeUtente,
          );
        },
        child: Image.asset(
          "images/restart.png",
          width: 150,
        ),
      ),
      titleSpacing: 10,
      elevation: 10,
      shadowColor: Colors.grey,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFFCE93D8),
              Color(0xFF80DEEA),
            ],
          ),
        ),
      ),
    );
  }

  /// Costruisce un [Drawer] che contiene varie opzioni di navigazione.
  static Widget buildDrawer(BuildContext context, {Key? key}) {
    return Drawer(
      key: const Key('drawer'),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFFCE93D8),
              Color(0xFF80DEEA),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'SCEGLI IL SERVIZIO CHE FA PER TE',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2.0,
                      color: Color(0xFFB4B1B1),
                    ),
                  ],
                  fontFamily: 'PoppinsMedium',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      'Community Events',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.eventi,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Annunci di lavoro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.annunci,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Alloggi temporanei',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.alloggi,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Supporto medico',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.supporti,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Corsi di formazione',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.corsi,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Trova il lavoro adatto a te',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.visualizzaLavoroAdatto,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Two additional ListTiles at the bottom
            ListTile(
              title: const Text(
                'ACCOUNT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  AppRoutes.profilo,
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: const Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PoppinsMedium',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ///metodo onTap gestisce il logout dall'applicazione.
                onTap: () {
                  SessionManager().remove("token");
                  SessionManager().destroy();
                  print("logout riuscito");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Logout effettuato',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor: Colors.lightBlue,
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
