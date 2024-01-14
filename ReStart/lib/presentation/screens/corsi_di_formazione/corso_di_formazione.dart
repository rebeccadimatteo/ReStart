import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [CorsoDiFormazione]
class CorsoDiFormazione extends StatefulWidget {
  @override
  _CorsoDiFormazioneState createState() => _CorsoDiFormazioneState();
}

/// Creazione dello stato di [CorsoDiFormazione], costituito dalla lista dei corsi.
class _CorsoDiFormazioneState extends State<CorsoDiFormazione> {
  List<CorsoDiFormazioneDTO> corsi = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

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

  /// Metodo che permette di inviare la richiesta al server per ottenere la lista di tutti i [CorsoDiFormazioneDTO] presenti nel database
  Future<void> fetchDataFromServer() async {
    final response = await http.post(Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/visualizzaCorsi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('corsi')) {
        final List<CorsoDiFormazioneDTO> data = List<Map<String, dynamic>>.from(responseBody['corsi'])
            .map((json) => CorsoDiFormazioneDTO.fromJson(json))
            .toList();
        setState(() {
          corsi = data;
        });
      } else {
        print('Chiave "corsi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }
  /// Build del widget principale della sezione [CorsoDiFormazione], contenente tutta l'interfaccia grafica
  @override
  Widget build(BuildContext context) {
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
                'Corsi di Formazione',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: corsi.length,
              itemBuilder: (context, index) {
                final corso = corsi[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettaglicorso,
                      arguments: corso,
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
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.transparent, // Imposta il colore del ListTile su trasparente
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('images/'+corso.immagine),
                      ),
                      title: Text(
                        corso.nomeCorso,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black, // Cambia il colore del testo se necessario
                        ),
                      ),
                      subtitle: Text(
                        corso.descrizione,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.black, // Cambia il colore del testo se necessario
                        ),
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

/// Build del widget che viene visualizzato quando viene selezionato un determinato corso dalla sezione [CorsoDiFormazione]
/// Permette di visualizzare i dettagli del corso selezionato
class DetailsCorso extends StatefulWidget {
  @override
  State<DetailsCorso> createState() => _DetailsCorsoState();
}

class _DetailsCorsoState extends State<DetailsCorso> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

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

  @override
  Widget build(BuildContext context) {
    final CorsoDiFormazioneDTO corso = ModalRoute.of(context)?.settings.arguments as CorsoDiFormazioneDTO;
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/'+corso.immagine),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            corso.nomeCorso,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(corso.descrizione,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center
            ),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Contatti',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(corso.urlCorso,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
