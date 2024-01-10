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
      backgroundColor: Colors.blue[200],
      automaticallyImplyLeading: showBackButton,
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.home,
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
    );
  }

  /// Costruisce un [Drawer] che contiene varie opzioni di navigazione.
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(
                  height: 150, // Imposta l'altezza desiderata
                  child: DrawerHeader(
                    curve: Curves.easeOutCirc,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.purple,
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Scegli il servizio che fa per te',
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 128, 0, 128),
                            ),
                          ],
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
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
                  fontFamily: 'Poppins',
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
                  AppRoutes.homeADS,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
