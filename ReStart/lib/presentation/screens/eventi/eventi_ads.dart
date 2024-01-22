import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';

/// Classe che implementa la sezione [CommunityEventsAds].
/// Gestisce la visualizzazione degli eventi della comunità destinati agli amministratori.
class CommunityEventsAds extends StatefulWidget {
  @override
  _CommunityEventsState createState() => _CommunityEventsState();
}

/// Stato per [CommunityEventsAds]. Gestisce la lista degli eventi
/// e interagisce con il server per recuperare questi dati.
class _CommunityEventsState extends State<CommunityEventsAds> {
  List<EventoDTO> eventi = [];

  /// Inizializzazione dello stato, con chiamata alla funzione [fetchDataFromServer]
  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  /// Verifica lo stato di autenticazione dell'utente amministratore e lo
  /// reindirizza alla homepage se non autenticato.
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserADS'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Richiede al server la lista degli eventi.
  /// Aggiorna lo stato con i dati ottenuti in caso di successo.
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
          List<EventoDTO> newData = [];
          for (EventoDTO e in data) {
            if (e.approvato) {
              newData.add(e);
            }
          }
          eventi = newData;
        });
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  /// Invia una richiesta al server per eliminare un evento.
  /// Aggiorna lo stato in caso di successo.
  ///
  /// [evento] L'evento da eliminare.
  Future<void> deleteEvento(EventoDTO evento) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/deleteEvento'),
        body: jsonEncode(evento));
    if (response.statusCode == 200) {
      setState(() {
        eventi.remove(evento);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce l'interfaccia utente per mostrare la lista degli eventi della comunità.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: Stack(
        children: [
          const SizedBox(height: 20),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: const Text(
                'Community Events',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: eventi.length,
              itemBuilder: (context, index) {
                final evento = eventi[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettaglieventoAds,
                      arguments: evento,
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ListTile(
                      visualDensity:
                          const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          deleteEvento(evento);
                          Navigator.pushNamed(context, AppRoutes.homeADS);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Evento eliminato',
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Classe per visualizzare i dettagli di un specifico [EventoDTO]
/// selezionato nella sezione [CommunityEventsAds].
class DetailsEventoAds extends StatefulWidget {
  @override
  State<DetailsEventoAds> createState() => _DetailsEventoAdsState();
}

class _DetailsEventoAdsState extends State<DetailsEventoAds> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Verifica lo stato di autenticazione dell'utente amministratore e lo
  /// reindirizza alla homepage se non autenticato.
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserADS'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Invia una richiesta al server per eliminare un evento.
  /// Gestisce la risposta del server e fornisce feedback all'utente.
  ///
  /// [evento] L'evento da eliminare.
  Future<void> deleteEvento(EventoDTO evento) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/deleteEvento'),
        body: jsonEncode(evento));
    if (response.statusCode == 200) {
      setState(() {
        print("Evento eliminato con successo");
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce l'interfaccia utente per mostrare i dettagli di un evento selezionato.
  @override
  Widget build(BuildContext context) {
    final EventoDTO evento =
        ModalRoute.of(context)?.settings.arguments as EventoDTO;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String data = formatter.format(evento.date);
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
                fontSize: 30, fontFamily: 'Genos', fontWeight: FontWeight.bold),
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
                color: Colors.black,
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
                              fontWeight: FontWeight.bold),
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
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',),
                        ),
                      ],
                    ),
                  ))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {
                deleteEvento(evento);
                Navigator.pushNamed(context, AppRoutes.homeADS);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Evento eliminato',
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
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.1,
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      'ELIMINA',
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
    );
  }
}
