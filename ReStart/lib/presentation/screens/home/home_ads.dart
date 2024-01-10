import 'package:flutter/material.dart';
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';
class HomeAds extends StatefulWidget {
  @override
  State<HomeAds> createState() => _HomeAdsState();
}

class _HomeAdsState extends State<HomeAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: false,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10),
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
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String route) {
    // Widget con testo centrato
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        color: Colors.blue[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
    home: HomeAds(),
  ));
}
