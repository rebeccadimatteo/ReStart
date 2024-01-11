import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [CommunityEvents]
class CommunityEvents extends StatefulWidget {
  @override
  _CommunityEventsState createState() => _CommunityEventsState();
}

/// Creazione dello stato di [CommunityEvents], costituito dalla lista degli eventi
class _CommunityEventsState extends State<CommunityEvents> {
  List<EventoDTO> eventi = [];

  /// Inizializzazione dello stato, con chiamata alla funzione [fetchDataFromServer]
  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> checkUser(BuildContext context) async {
    var token = await SessionManager().get("token");
    if(token != null) {
      if (!JWTUtils.verifyAccessToken(accessToken: await token, secretKey: JWTConstants.accessTokenSecretKeyForUtente)) {
        Navigator.pushNamed(context, AppRoutes.home);
      }
    } else{
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  /// Metodo che permette di inviare la richiesta al server per ottenere la lista di tutti i [SupportoMedicoDTO] presenti nel database
  Future<void> fetchDataFromServer() async {
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:8080/gestioneEvento/visualizzaEventi'));
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
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  /// Build del widget principale della sezione [CommunityEvents], contenente tutta l'interfaccia grafica
  @override
  Widget build(BuildContext context) {
    checkUser(context);
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: Stack(
        children: [
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
                  fontSize: 20,
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
                      AppRoutes.dettaglievento,
                      arguments: evento,
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
                      title: Text(evento.nomeEvento,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(evento.descrizione),
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

/// Build del widget che viene visualizzato quando viene selezionato un determinato evento dalla sezione [CommunityEvents]
/// Permette di visualizzare i dettagli dell'evento selezionato
class DetailsEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventoDTO evento = ModalRoute.of(context)?.settings.arguments as EventoDTO;
    final String data = evento.date.toIso8601String();
    final String dataBuona = data.substring(0,10);
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
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
                  image: AssetImage(evento.immagine)
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            evento.nomeEvento,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
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
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(evento.email),
                        Text(evento.sito),
                        const SizedBox(height: 20),
                        const Text(
                          'Informazioni',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(dataBuona),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
