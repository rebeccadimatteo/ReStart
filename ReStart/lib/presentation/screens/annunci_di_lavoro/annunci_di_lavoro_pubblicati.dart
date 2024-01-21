import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [AnnunciDiLavoroPubblicati].
/// Si tratta di un widget di stato che gestisce la visualizzazione degli annunci
/// di lavoro pubblicati.
class AnnunciDiLavoroPubblicati extends StatefulWidget {
  @override
  _AnnunciDiLavoroState createState() => _AnnunciDiLavoroState();
}

/// Stato per [AnnunciDiLavoroPubblicati]. Gestisce la lista degli annunci
/// di lavoro pubblicati e interagisce con il server per recuperare e
/// manipolare questi dati.
class _AnnunciDiLavoroState extends State<AnnunciDiLavoroPubblicati> {
  List<AnnuncioDiLavoroDTO> annunci = [];
  var token = SessionManager().get("token");

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  /// Verifica l'autenticazione dell'utente e lo reindirizza alla pagina home
  /// se non autenticato.
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

  /// Richiede al server la lista degli annunci di lavoro pubblicati.
  /// Aggiorna lo stato con i dati ottenuti in caso di successo.
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

  /// Invia una richiesta al server per eliminare un annuncio di lavoro.
  /// Aggiorna lo stato in caso di successo.
  ///
  /// [annuncio] L'annuncio di lavoro da eliminare.
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

  /// Invia una richiesta al server per modificare un annuncio di lavoro.
  /// Aggiorna lo stato in caso di successo.
  ///
  /// [annuncio] L'annuncio di lavoro da modificare.
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

  /// Costruisce l'interfaccia utente per mostrare la lista degli annunci
  /// di lavoro pubblicati. Utilizza [ListView.builder] per creare un elenco
  /// scrollabile di annunci.
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
                        backgroundImage: Image.asset(annuncio.immagine).image,
                      ),
                      title: Text(
                        annuncio.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Genos',
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        annuncio.descrizione.length > 20
                            ? '${annuncio.descrizione.substring(0, 20)}...'
                            : annuncio.descrizione,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
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
                                  color: Colors.black, size: 30),
                              onPressed: () {
                                deleteLavoro(annuncio);
                                Navigator.pushNamed(context, AppRoutes.homeADS);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Annuncio eliminato',
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

/// Classe che gestisce i dettagli di un annuncio di lavoro pubblicato.
/// Mostra maggiori informazioni su un annuncio selezionato.
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

  /// Verifica l'autenticazione dell'utente e lo reindirizza alla pagina home
  /// se non autenticato.
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

  /// Invia una richiesta al server per eliminare un annuncio di lavoro.
  /// Aggiorna lo stato in caso di successo.
  ///
  /// [annuncio] L'annuncio di lavoro da eliminare.
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

  /// Costruisce l'interfaccia utente per mostrare i dettagli di un annuncio
  /// di lavoro. Visualizza immagini, descrizioni, dettagli del contatto e
  /// opzioni per la gestione dell'annuncio.
  @override
  Widget build(BuildContext context) {
    final AnnuncioDiLavoroDTO annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
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
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      annuncio.email,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      annuncio.numTelefono,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${annuncio.via}, ${annuncio.citta}, ${annuncio.provincia}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
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
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.black, size: 40),
                          onPressed: () {
                            deleteLavoro(annuncio);
                            Navigator.pushNamed(context, AppRoutes.homeADS);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Annuncio eliminato',
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.listaCandidati,
                            arguments: annuncio);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 10,
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.1,
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
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.1,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              'LISTA UTENTI CANDIDATI',
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
