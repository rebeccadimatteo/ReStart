import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [AnnunciDiLavoro].
/// Questa classe gestisce la visualizzazione di annunci di lavoro approvati.
class AnnunciDiLavoro extends StatefulWidget {
  @override
  _AnnunciDiLavoroState createState() => _AnnunciDiLavoroState();
}

/// Stato di [AnnunciDiLavoro]. Gestisce la lista degli annunci di lavoro
/// e interagisce con il server per recuperare questi dati.
class _AnnunciDiLavoroState extends State<AnnunciDiLavoro> {
  List<AnnuncioDiLavoroDTO> annunci = [];

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    fetchDataFromServer();
  }

  /// Controlla lo stato di autenticazione dell'utente e lo reindirizza
  /// alla pagina home in caso di mancata autenticazione.
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

  /// Richiede al server la lista degli annunci di lavoro approvati.
  /// Aggiorna lo stato con i dati ottenuti in caso di successo.
  Future<void> fetchDataFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/annunciApprovati'));
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

  /// Costruisce l'interfaccia utente per mostrare la lista degli annunci
  /// di lavoro disponibili. Utilizza [ListView.builder] per creare un elenco
  /// scrollabile di annunci.
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
                'Annunci di lavoro',
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
                      AppRoutes.dettagliannuncio,
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
                          fontFamily: 'Genos',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        annuncio.descrizione.length > 20
                            ? '${annuncio.descrizione.substring(0, 20)}...'
                            : annuncio.descrizione,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.black,
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

/// Classe che gestisce i dettagli di un annuncio di lavoro.
/// Mostra maggiori informazioni su un annuncio selezionato.
class DetailsLavoro extends StatefulWidget {
  @override
  State<DetailsLavoro> createState() => _DetailsLavoroState();
}

class _DetailsLavoroState extends State<DetailsLavoro> {
  late String username;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Controlla lo stato di autenticazione dell'utente e lo reindirizza
  /// alla pagina home in caso di mancata autenticazione.
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

  /// Invia una richiesta di candidatura per un annuncio di lavoro.
  /// Mostra una notifica dell'esito dell'operazione.
  ///
  /// [idL] ID dell'annuncio di lavoro per cui si vuole candidare.
  /// [context] Contesto dell'interfaccia utente.
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

  /// Invia i dati della candidatura al server.
  /// Gestisce e mostra la risposta del server.
  ///
  /// [dataToServer] Dati della candidatura da inviare al server.
  /// [context] Contesto dell'interfaccia utente.
  Future<void> sendDataToServer(
      String dataToServer, BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/candidaturaLavoro/apply'),
      body: dataToServer,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {},
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
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  /// Costruisce l'interfaccia utente per mostrare i dettagli di un annuncio
  /// di lavoro. Visualizza immagini, descrizioni, dettagli del contatto e
  /// un pulsante per candidarsi all'annuncio.
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
                  image: Image.asset(annuncio.immagine).image,
                ),
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
          Align(
            alignment: Alignment.center,
            child: Padding(
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
          ),
          const SizedBox(width: 30),
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
                            fontFamily: 'PoppinsMedium',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          annuncio.email,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          annuncio.numTelefono,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
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
                          '${annuncio.via}, ${annuncio.citta}, ${annuncio.provincia}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ))),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {
                apply(annuncio.id!, context);
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
                      'CANDIDATI',
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
