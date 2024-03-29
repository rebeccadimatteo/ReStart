import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';
import "package:http/http.dart" as http;

/// Rappresenta la schermata principale per gli utenti registrati.
/// Mostra le opzioni disponibili come eventi della community e annunci di lavoro.
class HomeUtente extends StatefulWidget {
  @override
  State<HomeUtente> createState() => _HomeUtenteState();
}

/// _HomeUtenteState è lo stato associato a HomeUtente.
/// Gestisce l'interfaccia utente e il caricamento dei dati dalla rete.
class _HomeUtenteState extends State<HomeUtente> {
  List<EventoDTO> eventi = [];
  List<AnnuncioDiLavoroDTO> annunci = [];

  /// Inizializzazione dello stato.
  /// Effettua un controllo di autenticazione e carica i dati degli eventi e degli annunci.
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    fetchDataFromServer();
  }

  /// Verifica se l'utente attuale è autenticato.
  /// In caso negativo, l'utente viene reindirizzato alla schermata di login.
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserUtente'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Carica dati degli eventi e degli annunci di lavoro dal server.
  Future<void> fetchDataFromServer() async {
    final response = await http
        .post(Uri.parse('http://10.0.2.2:8080/gestioneEvento/eventiApprovati'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('eventi')) {
        final List<EventoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['eventi'])
                .map((json) => EventoDTO.fromJson(json))
                .toList();
        setState(() {
          eventi = data;
        });

        final response = await http.post(
            Uri.parse('http://10.0.2.2:8080/gestioneLavoro/annunciApprovati'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          if (responseBody.containsKey('annunci')) {
            final List<AnnuncioDiLavoroDTO> data =
                List<Map<String, dynamic>>.from(responseBody['annunci'])
                    .map((json) => AnnuncioDiLavoroDTO.fromJson(json))
                    .toList();
            setState(() {
              annunci = data;
            });
          } else {
            print('Chiave "annunci" non trovata nella risposta.');
          }
        } else {
          print('Errore nel caricamento degli annunci');
        }
      } else {
        print('Chiave "eventi" non trovata nella risposta');
      }
    } else {
      print('Errore nel caricamento degli eventi');
    }
  }

  /// Costruisce l'interfaccia utente della schermata principale.
  /// Utilizza un CustomScrollView per visualizzare vari elementi interattivi.
  @override
  Widget build(BuildContext context) {
    /// Restituisce uno scaffold, dove appbar e drawer presi dal file generic_app_bar.dart.
    /// Il tutto è ancora statico, manca la connessione al backend.
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: false,
      ),
      endDrawer: GenericAppBar.buildDrawer(context, key: const Key('drawer')),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                'QUESTA SETTIMANA...',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: eventi.length,
                itemBuilder: (context, index) {
                  EventoDTO evento = eventi[index];
                  return GestureDetector(
                    key: const Key('eventoItem'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dettaglievento,
                        arguments: evento,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.asset(evento.immagine),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                'COSA ASPETTI?',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: annunci.length,
                itemBuilder: (context, index) {
                  AnnuncioDiLavoroDTO annuncio = annunci[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.dettagliannuncio,
                        arguments: annuncio,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.asset(annuncio.immagine),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildListDelegate(
              [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.visualizzaLavoroAdatto,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Stack(
                          children: [
                            Image.asset(
                              'images/work.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[50]!,
                                      Colors.blue[100]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Center(
                                    child: Text(
                                      'SCOPRI IL LAVORO CHE FA PER TE!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.alloggi,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Stack(
                          children: [
                            Image.asset(
                              'images/casa.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[50]!,
                                      Colors.blue[100]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Center(
                                    child: Text(
                                      'TROVA UN ALLOGGIO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.corsi,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Stack(
                          children: [
                            Image.asset(
                              'images/corso.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[50]!,
                                      Colors.blue[100]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Center(
                                    child: Text(
                                      'IMPARA QUALCOSA DI NUOVO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.supporti,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.blue[50]!, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Stack(
                          children: [
                            Image.asset(
                              'images/supporto.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[50]!,
                                      Colors.blue[100]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Center(
                                    child: Text(
                                      'PRENDITI CURA DI TE STESSO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
