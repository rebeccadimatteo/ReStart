import 'package:flutter/material.dart';
import '../../presentation/screens/utenti/profilo.dart';
import '../screens/alloggi_temporanei/alloggi_temporanei.dart';
import '../screens/annunci_di_lavoro/annuncio_di_lavoro.dart';
import '../screens/corsi_di_formazione/corso_di_formazione.dart';
import '../screens/eventi/eventi.dart';
import '../screens/home/home.dart';
import '../screens/supporto_medico/supporto_medico.dart';

class GenericAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  GenericAppBar({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[200],
      automaticallyImplyLeading: showBackButton,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
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
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //       'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais'),
                      //   fit: BoxFit.fill,
                      // ),
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
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Community Events',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityEvents(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Annunci di lavoro',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnuncioDiLavoro(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Alloggi temporanei',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlloggiTemporanei(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Supporto medico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportoMedico(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Corsi di formazione',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorsoDiFormazione(),
                        ));
                  },
                ),
                ListTile(
                  title: const Text(
                    'Trova il lavoro adatto a te',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityEvents(),
                        ));
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
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profilo(),
                  ));
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              title: const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityEvents(),
                    ));
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
