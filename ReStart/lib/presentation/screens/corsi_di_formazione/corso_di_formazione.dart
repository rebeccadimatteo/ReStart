import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

class CorsoDiFormazione extends StatefulWidget {
  @override
  _CorsoDiFormazioneState createState() => _CorsoDiFormazioneState();
}

class _CorsoDiFormazioneState extends State<CorsoDiFormazione> {
  List<CorsoDiFormazioneDTO> corsi = [];

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
                      AppRoutes.dettaglicorso,
                      arguments: corso,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.grey,
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(corso.immagine),
                      ),
                      title: Text(corso.nomeCorso,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(corso.descrizione),
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
class DetailsCorso extends StatelessWidget {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(corso.immagine),
                ),
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
                  )))
        ],
      ),
    );
  }
}
