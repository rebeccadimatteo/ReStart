import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../screens/routes/routes.dart';

/// Classe che builda il widget per mostrare una [AppBar].
class AdsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  /// Costruttore per [AdsAppBar].
  AdsAppBar({super.key, required this.showBackButton});

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
  static Widget buildDrawer(BuildContext context) {
     return Drawer(
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
                  fontFamily: 'Poppins',
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
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.homeADS,
                    );
                  },
                ),
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
                      AppRoutes.eventiAds,
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
                      AppRoutes.annunciAds,
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
                      AppRoutes.alloggiAds,
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
                      AppRoutes.supportiAds,
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
                      AppRoutes.corsiAds,
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    'Gestione Richieste',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.richiesteAds,
                    );
                  },
                ),
              ],
            ),
          ),
          // Two additional ListTiles at the bottom
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
                Navigator.pushNamed(
                  context,
                  AppRoutes.home,
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
