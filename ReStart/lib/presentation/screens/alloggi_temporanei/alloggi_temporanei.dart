import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:restart_all_in_one/model/entity/alloggio_temporaneo_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

class AlloggiTemporanei extends StatefulWidget {
  @override
  _AlloggiTemporaneiState createState() => _AlloggiTemporaneiState();
}

class _AlloggiTemporaneiState extends State<AlloggiTemporanei> {
  List<AlloggioTemporaneoDTO> alloggi = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserUtente();
    if (!isUserValid) {
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

  /// Costruisce la schermata che visualizza la lista degli alloggi disponibili.
  /// La lista viene costruita dinamicamente utilizzando i dati presenti nella
  /// lista 'alloggi'. Ogni elemento della lista visualizza il nome, la
  /// descrizione e un'immagine di anteprima dell'alloggio.
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
                      AppRoutes.dettaglialloggio,
                      arguments: alloggio,
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                    child: ListTile(
                      visualDensity:
                          const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.grey,
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(alloggio.immagine),
                      ),
                      title: Text(
                        alloggio.nome,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        alloggio.descrizione,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                      ),
                    )
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
class DetailsAlloggio extends StatefulWidget {
  @override
  State<DetailsAlloggio> createState() => _DetailsAlloggioState();
}

class _DetailsAlloggioState extends State<DetailsAlloggio> {

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserUtente();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AlloggioTemporaneoDTO alloggio =
        ModalRoute.of(context)?.settings.arguments as AlloggioTemporaneoDTO;
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
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
                  image: AssetImage(alloggio.immagine),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            alloggio.nome,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(alloggio.descrizione),
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
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(alloggio.email),
                Text(alloggio.sito),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
void main() {
  runApp(AlloggiTemporanei());
}