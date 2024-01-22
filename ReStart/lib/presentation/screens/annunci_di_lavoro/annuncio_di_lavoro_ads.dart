import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../components/app_bar_ads.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [AnnunciDiLavoroAds].
/// Questa classe gestisce la visualizzazione degli annunci di lavoro
/// destinati agli amministratori del sistema.
class AnnunciDiLavoroAds extends StatefulWidget {
  @override
  _AnnunciDiLavoroState createState() => _AnnunciDiLavoroState();
}

/// Stato per [AnnunciDiLavoroAds]. Gestisce la lista degli annunci di lavoro
/// e interagisce con il server per recuperare questi dati.
class _AnnunciDiLavoroState extends State<AnnunciDiLavoroAds> {
  List<AnnuncioDiLavoroDTO> annunci = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }

  /// Verifica lo stato di autenticazione dell'utente e reindirizza alla pagina
  /// home se non autenticato.
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

  /// Richiede al server la lista degli annunci di lavoro.
  /// Aggiorna lo stato con i dati ottenuti in caso di successo.
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
          List<AnnuncioDiLavoroDTO> newData = [];
          for (AnnuncioDiLavoroDTO a in data) {
            if (a.approvato) {
              newData.add(a);
            }
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

  /// Costruisce l'interfaccia utente per mostrare la lista degli annunci
  /// di lavoro disponibili. Utilizza [ListView.builder] per creare un elenco
  /// scrollabile di annunci.
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
                      AppRoutes.dettagliannuncioAds,
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
                      trailing: IconButton(
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

/// Classe che gestisce i dettagli di un annuncio di lavoro.
/// Mostra maggiori informazioni su un annuncio selezionato.
class DetailsLavoroAds extends StatefulWidget {
  @override
  State<DetailsLavoroAds> createState() => _DetailsLavoroAdsState();
}

class _DetailsLavoroAdsState extends State<DetailsLavoroAds> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Verifica lo stato di autenticazione dell'utente e reindirizza alla pagina
  /// home se non autenticato.
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

  /// Invia una richiesta al server per eliminare un annuncio di lavoro.
  /// Gestisce la risposta del server e fornisce feedback all'utente.
  ///
  /// [annuncio] L'annuncio di lavoro da eliminare.
  Future<void> deleteLavoro(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/deleteLavoro'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      print("Annuncio eliminato correttamente");
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Costruisce l'interfaccia utente per mostrare i dettagli di un annuncio
  /// di lavoro. Visualizza immagini, descrizioni, dettagli di contatto e
  /// un pulsante per eliminare l'annuncio.
  @override
  Widget build(BuildContext context) {
    final AnnuncioDiLavoroDTO annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
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
                fontSize: 30, fontFamily: 'Genos', fontWeight: FontWeight.bold),
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
                          annuncio.email,
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
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
                        const SizedBox(height: 15),
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
                            fontSize: 15,
                            fontFamily: 'Poppins',
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
