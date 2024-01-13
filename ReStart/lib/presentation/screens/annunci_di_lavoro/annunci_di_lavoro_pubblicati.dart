import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

class AnnunciDiLavoroPubblicati extends StatefulWidget {
  @override
  _AnnunciDiLavoroState createState() => _AnnunciDiLavoroState();
}

class _AnnunciDiLavoroState extends State<AnnunciDiLavoroPubblicati> {
  List<AnnuncioDiLavoroDTO> annunci = [];
  var token = SessionManager().get("token");

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserCA'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode != 200){
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
    String user = JWTUtils.getUserFromToken(accessToken: await token);
    Map<String, dynamic> username = {"username": user};
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/annunciPubblicati'),
        body: json.encode(username));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('annunci')) {
        final List<AnnuncioDiLavoroDTO> data =
            List<Map<String, dynamic>>.from(responseBody['annunci'])
                .map((json) => AnnuncioDiLavoroDTO.fromJson(json))
                .toList();
        setState(() {
          List<AnnuncioDiLavoroDTO> newData = [];
          for (AnnuncioDiLavoroDTO a in data) {
            //if (a.approvato && a.id_ca == idCa) {
            newData.add(a);
            //}
          }
          annunci = newData;
        });
      } else {
        print('Chiave "annunci" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> deleteLavoro(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/deleteLavoro'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      setState(() {
        annunci.remove(annuncio);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  Future<void> modifyLavoro(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/modifyLavoro'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      setState(() {
        for (AnnuncioDiLavoroDTO a in annunci) {
          if (a.id == annuncio.id) {
            annunci.remove(a);
            break;
          }
        }
        annunci.add(annuncio);
      });
    } else {
      print("Modifica non andata a buon fine");
    }
  }

  /// Costruisce la schermata che visualizza la lista degli annunci di lavoro disponibili.
  /// La lista viene costruita dinamicamente utilizzando i dati presenti nella
  /// lista 'annunci'.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
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
                'GESTISCI LE TUE OFFERTE DI LAVORO',
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
                      AppRoutes.dettagliannunciopub,
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
                          backgroundImage: AssetImage(annuncio.immagine)),
                      title: Text(annuncio.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(annuncio.descrizione),
                      trailing: SizedBox(
                        width: 100, // o un'altra dimensione adeguata
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black, size: 30),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.modificalavoro,
                                    arguments: annuncio);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 30),
                              onPressed: () {
                                deleteLavoro(annuncio);
                              },
                            ),
                          ],
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

/// Visualizza i dettagli di [AnnunciDiLavoro]
class DetailsLavoroPub extends StatefulWidget {
  @override
  _DetailsLavoroPub createState() => _DetailsLavoroPub();
}

class _DetailsLavoroPub extends State<DetailsLavoroPub> {
  List<AnnuncioDiLavoroDTO> annunci = [];
  var token = SessionManager().get("token");

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserCA'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  Future<void> deleteLavoro(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/deleteLavoro'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      setState(() {
        annunci.remove(annuncio);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  Future<void> modifyLavoro(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/modifyLavoro'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      setState(() {
        for (AnnuncioDiLavoroDTO a in annunci) {
          if (a.id == annuncio.id) {
            annunci.remove(a);
            break;
          }
        }
        annunci.add(annuncio);
      });
    } else {
      print("Modifica non andata a buon fine");
    }
  }

  @override
  Widget build(BuildContext context) {
    final AnnuncioDiLavoroDTO annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
    return Scaffold(
      appBar: CaAppBar(
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
                    fit: BoxFit.cover, image: AssetImage(annuncio.immagine)),
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
                        // Aggiunta dei pulsanti sotto la sezione "Contatti"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black, size: 40),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.modificalavoro,
                                    arguments: annuncio);
                              },
                            ),
                            const SizedBox(width: 20),
                            // Aggiungi uno spazio tra i pulsanti
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 40),
                              onPressed: () {
                                deleteLavoro(annuncio);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnnunciDiLavoroPubblicati(),
  ));
}
