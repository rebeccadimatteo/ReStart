import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../components/app_bar_ca.dart';
import '../routes/routes.dart';
import "package:http/http.dart" as http;

/// Rappresenta la schermata principale per i CA.
/// Mostra le opzioni disponibili per la gestione di eventi e offerte di lavoro.
class HomeCa extends StatefulWidget {
  @override
  State<HomeCa> createState() => _HomeCaState();
}

/// _HomeCaState è lo stato associato a HomeCa.
/// Qui vengono gestiti i comportamenti e l'interfaccia utente della schermata principale per i CA.
class _HomeCaState extends State<HomeCa> {
  /// Inizializzazione dello stato.
  /// Effettua un controllo di autenticazione e ruolo utente all'apertura della schermata.
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Verifica se l'utente attuale ha il ruolo di "CA" (Community Administrator).
  /// In caso negativo, l'utente viene reindirizzato alla schermata principale.
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserCA'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Costruisce l'interfaccia utente della schermata.
  /// Utilizza CustomScrollView per visualizzare vari elementi interattivi.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: false,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: CustomScrollView(
        key: const Key('homeCa'),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildFullWidthItem(context, 'OFFERTE DI LAVORO\nPUBBLICATE',
                    AppRoutes.annuncipubblicati),
                const SizedBox(height: 5),
                _buildFullWidthItem(context, 'COMMUNITY EVENTS\nPUBBLICATI',
                    AppRoutes.eventipubblicati),
                const SizedBox(height: 5),
                Container(
                  key: const Key('addEventoContainer'),
                  child: _buildFullWidthItem(
                      context, 'AGGIUNGI EVENTO', AppRoutes.addevento),
                ),
                const SizedBox(height: 5),
                Container(
                  key: const Key('addAnnuncioContainer'),
                  child: _buildFullWidthItem(context,
                      'AGGIUNGI OFFERTA\nDI LAVORO', AppRoutes.addannuncio),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Costruisce un widget interattivo a larghezza piena per la schermata principale.
  /// Utilizzato per visualizzare le varie opzioni disponibili per i CA.
  Widget _buildFullWidthItem(BuildContext context, String title, String route) {
    // Widget per i blocchi rettangolari con testo centrato
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
                    offset: const Offset(0, 2),
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
