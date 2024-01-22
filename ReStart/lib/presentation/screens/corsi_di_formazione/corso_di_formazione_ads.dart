import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../components/app_bar_ads.dart';
import '../routes/routes.dart';

/// Classe che implementa la sezione [CorsoDiFormazioneAds].
/// Gestisce la visualizzazione dei corsi di formazione per gli amministratori.
class CorsoDiFormazioneAds extends StatefulWidget {
  @override
  _CorsoDiFormazioneState createState() => _CorsoDiFormazioneState();
}

class _CorsoDiFormazioneState extends State<CorsoDiFormazioneAds> {
  List<CorsoDiFormazioneDTO> corsi = [];

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

  /// Richiede al server la lista dei corsi di formazione.
  /// Aggiorna lo stato con i dati ottenuti in caso di successo.
  Future<void> fetchDataFromServer() async {
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:8080/gestioneReintegrazione/visualizzaCorsi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('corsi')) {
        final List<CorsoDiFormazioneDTO> data =
            List<Map<String, dynamic>>.from(responseBody['corsi'])
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

  /// Invia una richiesta al server per eliminare un corso di formazione.
  /// Aggiorna lo stato in caso di successo.
  ///
  /// [corso] Il corso di formazione da eliminare.
  Future<void> deleteCorso(CorsoDiFormazioneDTO corso) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/deleteCorso'),
        body: jsonEncode(corso));
    if (response.statusCode == 200) {
      setState(() {
        corsi.remove(corso);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce l'interfaccia utente per mostrare la lista dei corsi di
  /// formazione disponibili agli amministratori.
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
                'Corsi di Formazione',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
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
                      AppRoutes.dettaglicorsoAds,
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
                        backgroundImage: Image.asset(corso.immagine).image,
                      ),
                      title: Text(
                        corso.nomeCorso,
                        style: const TextStyle(
                          fontFamily: 'Genos',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        corso.descrizione.length > 20
                            ? '${corso.descrizione.substring(0, 20)}...'
                            : corso.descrizione,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.black, size: 25),
                        onPressed: () {
                          deleteCorso(corso);
                          Navigator.pushNamed(context, AppRoutes.homeADS);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Corso di Formazione Eliminato!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Colors.red,
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

/// Classe per visualizzare i dettagli di un specifico [CorsoDiFormazione]
/// nella sezione amministratore.
class DetailsCorsoAds extends StatefulWidget {
  @override
  State<DetailsCorsoAds> createState() => _DetailsCorsoAdsState();
}

class _DetailsCorsoAdsState extends State<DetailsCorsoAds> {
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

  /// Invia una richiesta al server per eliminare un corso di formazione.
  /// Gestisce la risposta del server e fornisce feedback all'utente.
  ///
  /// [corso] Il corso di formazione da eliminare.
  Future<void> deleteCorso(CorsoDiFormazioneDTO corso) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/deleteCorso'),
        body: jsonEncode(corso));
    if (response.statusCode == 200) {
      print("Eliminazione andata a buon fine");
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce l'interfaccia utente per mostrare i dettagli di un corso di
  /// formazione selezionato dagli amministratori.
  @override
  Widget build(BuildContext context) {
    final CorsoDiFormazioneDTO corso =
        ModalRoute.of(context)?.settings.arguments as CorsoDiFormazioneDTO;
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
                    image: Image.asset(corso.immagine).image),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            corso.nomeCorso,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Genos',
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              corso.descrizione,
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
                          'Link al Corso',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          corso.urlCorso,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {
                deleteCorso(corso);
                Navigator.pushNamed(context, AppRoutes.homeADS);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Corso eliminato',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.red,
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
