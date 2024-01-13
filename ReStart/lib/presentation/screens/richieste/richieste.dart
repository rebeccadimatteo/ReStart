import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';

class Richieste extends StatefulWidget {
  @override
  State<Richieste> createState() => _RichiesteState();
}

class _RichiesteState extends State<Richieste> {
  List<EventoDTO> eventi = [];
  List<AnnuncioDiLavoroDTO> annunci = [];

  @override
  void initState() {
    super.initState();
    fetchEventiFromServer();
    fetchAnnunciFromServer();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserADS();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  Future<void> fetchEventiFromServer() async {
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
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> fetchAnnunciFromServer() async {
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
      print('Errore');
    }
  }

  Future<void> approvaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/approveEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/rejectEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> approvaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/approveLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/rejectLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

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
        // Aggiungi 2 per le scritte 'Eventi' e 'Annunci di lavoro'
        itemBuilder: (context, index) {
          if (index == 0) {
            // Prima della lista degli eventi
            return buildSectionHeader('Eventi');
          } else if (index <= eventi.length) {
            // Elementi degli eventi
            final evento = eventi[index - 1];
            return buildEventItem(context, evento);
          } else if (index == eventi.length + 1) {
            // Prima della lista degli annunci di lavoro
            return buildSectionHeader('Annunci di lavoro');
          } else {
            // Elementi degli annunci di lavoro
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
          style: TextStyle(
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
            builder: (context) => DetailsEventoR(
                evento), // Passa il tuo annuncio come argomento qui
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 80,
          tileColor: Colors.grey,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(evento.immagine),
          ),
          title: Text(
            evento.nomeEvento,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(evento.descrizione),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  approvaEvento(evento);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaEvento(evento);
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
            builder: (context) => DetailsLavoroR(
                annuncio), // Passa il tuo annuncio come argomento qui
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 80,
          tileColor: Colors.grey,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(annuncio.immagine),
          ),
          title: Text(
            annuncio.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(annuncio.descrizione),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  approvaAnnuncio(annuncio);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaAnnuncio(annuncio);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Visualizza i dettagli di [AnnunciDiLavoro]

class DetailsLavoroR extends StatefulWidget {
  DetailsLavoroR(this.annuncio);

  final AnnuncioDiLavoroDTO annuncio;

  @override
  State<DetailsLavoroR> createState() =>
      _DetailsLavoroAdsState(annuncio: annuncio);
}

class _DetailsLavoroAdsState extends State<DetailsLavoroR> {
  final AnnuncioDiLavoroDTO annuncio;

  _DetailsLavoroAdsState({required this.annuncio});

  Future<void> approvaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/approveLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/rejectLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    fit: BoxFit.cover, image: AssetImage(annuncio.immagine)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            annuncio.nome,
            style: const TextStyle(
              fontFamily: 'Poppins',
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
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
                            fontFamily: 'Poppins',
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
                elevation: 10,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.width * 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                // Per occupare tutta la larghezza disponibile
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
                    const SizedBox(width: 10), // Spazio tra i pulsanti
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[50]!, Colors.green[100]!],
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
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'APPROVE',
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
  DetailsEventoR(this.evento);

  final EventoDTO evento;

  @override
  State<DetailsEventoR> createState() => _DetailsEventoAdsState(evento: evento);
}

class _DetailsEventoAdsState extends State<DetailsEventoR> {
  final EventoDTO evento;

  _DetailsEventoAdsState({required this.evento});

  Future<void> approvaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/approveEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/rejectEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String data = evento.date.toIso8601String();
    final String dataBuona = data.substring(0, 10);
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
                    fit: BoxFit.cover, image: AssetImage(evento.immagine)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            evento.nomeEvento,
            style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(evento.descrizione),
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
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(evento.email),
                        Text(evento.sito),
                        const SizedBox(height: 20),
                        const Text(
                          'Informazioni',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(dataBuona),
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
                elevation: 10,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.width * 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                // Per occupare tutta la larghezza disponibile
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
                    const SizedBox(width: 10), // Spazio tra i pulsanti
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[50]!, Colors.green[100]!],
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
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'APPROVE',
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
