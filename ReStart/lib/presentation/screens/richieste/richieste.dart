import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';

/// Rappresenta la schermata per la gestione delle richieste di eventi e annunci di lavoro da parte degli amministratori ADS.
class Richieste extends StatefulWidget {
  @override
  State<Richieste> createState() => _RichiesteState();
}

/// Gestisce la logica e l'interazione dell'interfaccia utente per la visualizzazione e gestione delle richieste.
class _RichiesteState extends State<Richieste> {
  List<EventoDTO> eventi = [];
  List<AnnuncioDiLavoroDTO> annunci = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  /// Metodo per verificare la validità dell'utente e reindirizzare se non autorizzato.
  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserADS();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Metodo per recuperare dati di eventi e annunci dal server.
  Future<void> fetchDataFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/visualizzaEventi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('eventi')) {
        final List<EventoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['eventi'])
                .map((json) => EventoDTO.fromJson(json))
                .toList();
        setState(() {
          eventi = data.where((e) => !e.approvato).toList();
        });
        final response = await http.post(
            Uri.parse('http://10.0.2.2:8080/gestioneLavoro/visualizzaLavori'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          if (responseBody.containsKey('annunci')) {
            final List<AnnuncioDiLavoroDTO> data =
                List<Map<String, dynamic>>.from(responseBody['annunci'])
                    .map((json) => AnnuncioDiLavoroDTO.fromJson(json))
                    .toList();
            setState(() {
              annunci = data.where((a) => !a.approvato).toList();
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

  /// Metodo per approvare un evento
  Future<void> approvaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/approveEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
        setState(() {
          eventi.remove(e);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
      }
    }
  }

  /// Metodo per rifiutare un evento
  Future<void> rifiutaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/rejectEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
        setState(() {
          eventi.remove(e);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
      }
    }
  }

  /// Metodo per approvare un annuncio
  Future<void> approvaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/approveLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
        setState(() {
          annunci.remove(a);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.homeADS);
              },
            ),
          ),
        );
      }
    }
  }

  /// Metodo per rifiutare un annuncio
  Future<void> rifiutaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/rejectLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          annunci.remove(a);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  /// Costruzione dell'interfaccia utente per la visualizzazione delle richieste
  @override
  Widget build(BuildContext context) {
    if (eventi.isEmpty && annunci.isEmpty) {
      // Nessuna richiesta
      return Scaffold(
        appBar: AdsAppBar(
          showBackButton: true,
        ),
        endDrawer: AdsAppBar.buildDrawer(context),
        body: const Center(
          child: Text(
            'Nessuna richiesta',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'PoppinsMedium',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: ListView.builder(
        itemCount: eventi.length + annunci.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildSectionHeader('Eventi');
          } else if (index <= eventi.length) {
            final evento = eventi[index - 1];
            return buildEventItem(context, evento);
          } else if (index == eventi.length + 1) {
            return buildSectionHeader('Annunci di lavoro');
          } else {
            final annuncio = annunci[index - eventi.length - 2];
            return buildAnnouncementItem(context, annuncio);
          }
        },
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildEventItem(BuildContext context, EventoDTO evento) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsEventoR(evento),
          ),
        );
      },
      child: Container(
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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 70,
          tileColor: Colors.transparent,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: Image.asset(evento.immagine).image,
          ),
          title: Text(
            evento.nomeEvento,
            style: const TextStyle(
              fontFamily: 'Genos',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            evento.descrizione.length > 20
                ? '${evento.descrizione.substring(0, 20)}...'
                : evento.descrizione,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  approvaEvento(evento);
                  Navigator.pushNamed(context, AppRoutes.homeADS);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaEvento(evento);
                  Navigator.pushNamed(context, AppRoutes.homeADS);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnnouncementItem(
      BuildContext context, AnnuncioDiLavoroDTO annuncio) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsLavoroR(annuncio),
          ),
        );
      },
      child: Container(
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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 70,
          tileColor: Colors.transparent,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: Image.asset(annuncio.immagine).image,
          ),
          title: Text(
            annuncio.nome,
            style: const TextStyle(
              fontFamily: 'Genos',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            annuncio.descrizione.length > 20
                ? '${annuncio.descrizione.substring(0, 20)}...'
                : annuncio.descrizione,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  approvaAnnuncio(annuncio);
                  Navigator.pushNamed(context, AppRoutes.homeADS);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaAnnuncio(annuncio);
                  Navigator.pushNamed(context, AppRoutes.homeADS);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Classe DetailsLavoroR rappresenta la schermata di dettaglio per un [AnnuncioDiLavoroDTO] nella sezione Richieste.
class DetailsLavoroR extends StatefulWidget {
  const DetailsLavoroR(this.annuncio);

  final AnnuncioDiLavoroDTO annuncio;

  @override
  State<DetailsLavoroR> createState() =>
      _DetailsLavoroAdsState(annuncio: annuncio);
}

class _DetailsLavoroAdsState extends State<DetailsLavoroR> {
  final AnnuncioDiLavoroDTO annuncio;

  _DetailsLavoroAdsState({required this.annuncio});

  /// Metodo per approvare un annuncio
  Future<void> approvaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/approveLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    }
  }

  /// Metodo per rifiutare un annuncio
  Future<void> rifiutaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/rejectLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    }
  }

  /// Costruzione dell'interfaccia utente per i dettagli dell'annuncio
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(annuncio.immagine).image,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            annuncio.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Genos',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              annuncio.descrizione,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Contatti',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PoppinsMedium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          annuncio.email,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          annuncio.numTelefono,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${annuncio.via}, ${annuncio.citta}, ${annuncio.provincia}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            rifiutaAnnuncio(annuncio);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'RIFIUTA',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            approvaAnnuncio(annuncio);
                          },
                          child: Container(
                            width: screenWidth * 0.60,
                            height: screenWidth * 0.1,
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'APPROVA',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ],
      ),
    );
  }
}

/// Build del widget che viene visualizzato quando viene selezionato un determinato evento dalla sezione [CommunityEvents]
/// Permette di visualizzare i dettagli dell'evento selezionato
class DetailsEventoR extends StatefulWidget {
  const DetailsEventoR(this.evento);

  final EventoDTO evento;

  @override
  State<DetailsEventoR> createState() => _DetailsEventoAdsState(evento: evento);
}

class _DetailsEventoAdsState extends State<DetailsEventoR> {
  final EventoDTO evento;

  _DetailsEventoAdsState({required this.evento});

  /// Metodo per approvare un evento
  Future<void> approvaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/approveEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    }
  }

  /// Metodo per rifiutare un evento
  Future<void> rifiutaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/rejectEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar
              },
            ),
          ),
        );
      }
    }
  }

  /// Costruzione dell'interfaccia utente per i dettagli dell'evento
  @override
  Widget build(BuildContext context) {
    final String isoString = evento.date.toIso8601String();

    DateFormat isoFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateTime parsedDate = isoFormat.parse(isoString);

    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm");
    final String formattedDate = outputFormat.format(parsedDate);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(evento.immagine).image,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            evento.nomeEvento,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Genos',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              evento.descrizione,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Contatti',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PoppinsMedium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      evento.email,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Informazioni',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PoppinsMedium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            rifiutaEvento(evento);
                          },
                          child: Container(
                            width: screenWidth * 0.60,
                            height: screenWidth * 0.1,
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'RIFIUTA',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            approvaEvento(evento);
                          },
                          child: Container(
                            width: screenWidth * 0.60,
                            height: screenWidth * 0.1,
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'APPROVA',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ],
      ),
    );
  }
}
