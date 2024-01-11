import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:restart_all_in_one/utils/jwt_utils.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../../utils/jwt_constants.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

class AnnunciDiLavoro extends StatefulWidget {
  @override
  _AnnunciDiLavoroState createState() => _AnnunciDiLavoroState();
}

class _AnnunciDiLavoroState extends State<AnnunciDiLavoro> {
  List<AnnuncioDiLavoroDTO> annunci = [];

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

  /// Effettua una richiesta asincrona al server per ottenere dati sugli alloggi.
  /// Questa funzione esegue una richiesta POST al server specificato,
  /// interpreta la risposta e aggiorna lo stato dell'oggetto corrente con
  /// i dati ricevuti, se la risposta è valida (status code 200).
  ///
  /// In caso di successo, la lista di [AnnuncioDiLavoroDTO] risultante
  /// viene assegnata alla variabile di stato 'alloggi'. In caso di errori
  /// nella risposta, vengono stampati messaggi di errore sulla console.
  Future<void> fetchDataFromServer() async {
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
          annunci = data;
        });
      } else {
        print('Chiave "annunci" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  /// Costruisce la schermata che visualizza la lista degli annunci di lavoro disponibili.
  /// La lista viene costruita dinamicamente utilizzando i dati presenti nella
  /// lista 'annunci'.
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
                'Annunci di lavoro',
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
              itemCount: annunci.length,
              itemBuilder: (context, index) {
                final annuncio = annunci[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettagliannuncio,
                      arguments: annuncio,
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
                        backgroundImage: AssetImage(annuncio.immagine),
                      ),
                      title: Text(annuncio.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(annuncio.descrizione),
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

/// Visualizza i dettagli di [AnnunciDiLavoro]

class DetailsLavoro extends StatelessWidget {
  late String username;

  Future<void> apply(int idL, BuildContext context) async {
    var token = SessionManager().get("token");
    username = JWTUtils.getUserFromToken(accessToken: await token);
    Map<String, String> data = {
      'idLavoro': idL.toString(),
      'username': username,
    };
    String dataToServer = jsonEncode(data);
    sendDataToServer(dataToServer, context);
  }

  Future<void> sendDataToServer(String dataToServer, BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/candidaturaLavoro/apply'),
      body: dataToServer,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        // Mostra una snackbar personalizzata con il risultato
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
        // Mostra una snackbar personalizzata con il risultato
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
    final AnnuncioDiLavoroDTO annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
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
                  image: AssetImage(annuncio.immagine),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            annuncio.nome,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(annuncio.descrizione, textAlign: TextAlign.center),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Aggiungi uno spazio tra il testo e gli altri elementi
                        Text(annuncio.email),
                        const SizedBox(width: 8),
                        Text(annuncio.numTelefono),
                        const SizedBox(width: 8),
                        Text(
                            '${annuncio.via}, ${annuncio.citta}, ${annuncio.provincia}'),
                      ],
                    ),
                  ))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                shadowColor: Colors.grey,
                elevation: 10,
              ),
              onPressed: () {
                apply(annuncio.id!, context);
              },
              child: const Text('CANDIDATI',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
