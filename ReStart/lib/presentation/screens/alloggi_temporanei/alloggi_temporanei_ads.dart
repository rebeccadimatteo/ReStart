import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../components/app_bar_ads.dart';
import "package:http/http.dart" as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [AlloggiTemporaneiAds]
class AlloggiTemporaneiAds extends StatefulWidget {
  @override
  _AlloggiTemporaneiState createState() => _AlloggiTemporaneiState();
}

/// Creazione dello stato di [AlloggiTemporaneiAds], costituito
/// dalla lista degli alloggi
class _AlloggiTemporaneiState extends State<AlloggiTemporaneiAds> {
  List<AlloggioTemporaneoDTO> alloggi = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

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

  /// Effettua una richiesta asincrona al server per ottenere dati sugli alloggi.
  /// Questa funzione esegue una richiesta POST al server specificato,
  /// interpreta la risposta e aggiorna lo stato dell'oggetto corrente con
  /// i dati ricevuti, se la risposta è valida (status code 200).
  ///
  /// In caso di successo, la lista di [AlloggioTemporaneoDTO] risultante
  /// viene assegnata alla variabile di stato 'alloggi'. In caso di errori
  /// nella risposta, vengono stampati messaggi di errore sulla console.
  Future<void> fetchDataFromServer() async {
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:8080/gestioneReintegrazione/visualizzaAlloggi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('alloggi')) {
        final List<AlloggioTemporaneoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['alloggi'])
                .map((json) => AlloggioTemporaneoDTO.fromJson(json))
                .toList();
        setState(() {
          alloggi = data;
        });
      } else {
        print('Chiave "alloggi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> deleteAlloggio(AlloggioTemporaneoDTO alloggio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/deleteAlloggio'),
        body: jsonEncode(alloggio));
    if (response.statusCode == 200) {
      setState(() {
        alloggi.remove(alloggio);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce la schermata che visualizza la lista degli alloggi disponibili.
  /// La lista viene costruita dinamicamente utilizzando i dati presenti nella
  /// lista 'alloggi'. Ogni elemento della lista visualizza il nome, la
  /// descrizione e un'immagine di anteprima dell'alloggio.
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
                'Alloggi Disponibili',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: alloggi.length,
              itemBuilder: (context, index) {
                final alloggio = alloggi[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettaglialloggioAds,
                      arguments: alloggio,
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
                        backgroundImage:
                        Image.asset(alloggio.immagine).image,
                      ),
                      title: Text(
                        alloggio.nome,
                        style: const TextStyle(
                          fontFamily: 'Genos',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        alloggio.descrizione,
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
                          deleteAlloggio(alloggio);
                          Navigator.pushNamed(context, AppRoutes.homeADS);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Alloggio Temporaneo Eliminato!',
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

/// visualizza i dettagli di un alloggio
class DetailsAlloggioAds extends StatefulWidget {
  @override
  State<DetailsAlloggioAds> createState() => _DetailsAlloggioAdsState();
}

class _DetailsAlloggioAdsState extends State<DetailsAlloggioAds> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

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

  Future<void> deleteAlloggio(AlloggioTemporaneoDTO alloggio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/deleteAlloggio'),
        body: jsonEncode(alloggio));
    if (response.statusCode == 200) {
      setState(() {
        print("Eliminaziona andata a buon fine");
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AlloggioTemporaneoDTO alloggio =
        ModalRoute.of(context)?.settings.arguments as AlloggioTemporaneoDTO;
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
                    fit: BoxFit.cover, image: Image.asset(alloggio.immagine).image),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            alloggio.nome,
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
                alloggio.descrizione,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Flexible(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Contatti',
                  style: TextStyle(
                    fontFamily: 'PoppinsMedium',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                    alloggio.email,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(alloggio.sito,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {
                deleteAlloggio(alloggio);
                Navigator.pushNamed(context, AppRoutes.homeADS);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Alloggio eliminato',
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
