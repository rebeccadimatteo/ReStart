import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/app_bar_ads.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

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

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserADS();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

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

  Future<void> deleteCorso(CorsoDiFormazioneDTO corso) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/deleteLavoro'),
        body: jsonEncode(corso));
    if (response.statusCode == 200) {
      setState(() {
        corsi.remove(corso);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
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
                  fontSize: 20,
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
                          backgroundImage: AssetImage(corso.immagine)),
                      title: Text(corso.nomeCorso,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(corso.descrizione),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 30),
                        onPressed: () {
                          deleteCorso(corso);
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

/// Build del widget che viene visualizzato quando viene selezionato un determinato corso dalla sezione [CorsoDiFormazione]
/// Permette di visualizzare i dettagli del corso selezionato
class DetailsCorsoAds extends StatelessWidget {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(corso.immagine)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            corso.nomeCorso,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(corso.descrizione, textAlign: TextAlign.center),
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
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(corso.urlCorso),
                      ],
                    ),
                  ))),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shadowColor: Colors.grey,
                elevation: 10,
              ),
              onPressed: () {
                // deleteCorso(corso);
              },
              child: const Text('ELIMINA',
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
