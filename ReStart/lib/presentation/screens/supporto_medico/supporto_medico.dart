import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../model/entity/supporto_medico_DTO.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

/// Classe che implementa la sezione [SupportoMedico]
class SupportoMedico extends StatefulWidget {
  @override
  _SupportoMedicoState createState() => _SupportoMedicoState();
}

/// Creazione dello stato di [SupportoMedico], costituito dalla lista dei supporti
class _SupportoMedicoState extends State<SupportoMedico> {
  List<SupportoMedicoDTO> supporti = [];

  /// Inizializzazione dello stato, con chiamata alla funzione [fetchDataFromServer]
  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  /// Metodo che permette di inviare la richiesta al server per ottenere la lista di tutti i [SupportoMedicoDTO] presenti nel database
  Future<void> fetchDataFromServer() async {
    final response = await http.post(Uri.parse(
        'http://10.0.2.2:8080/gestioneReintegrazione/visualizzaSupporti'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('supporti')) {
        final List<SupportoMedicoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['supporti'])
                .map((json) => SupportoMedicoDTO.fromJson(json))
                .toList();
        setState(() {
          supporti = data;
        });
      } else {
        print('Chiave "supporti" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  /// Build del widget principale della sezione [SupportoMedico], contenente tutta l'interfaccia grafica
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
                'Supporto Medico',
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
              itemCount: supporti.length,
              itemBuilder: (context, index) {
                final supporto = supporti[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettaglisupporto,
                      arguments: supporto,
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
                          backgroundImage: AssetImage(supporto.immagine)),
                      title: Text(supporto.nomeMedico,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(supporto.descrizione),
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

class DetailsSupporto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SupportoMedicoDTO supporto =
        ModalRoute.of(context)?.settings.arguments as SupportoMedicoDTO;
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
                  image: AssetImage(supporto.immagine)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            supporto.nomeMedico,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Text(
            supporto.cognomeMedico,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(supporto.descrizione),
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
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(supporto.email),
                        const SizedBox(width: 8),
                        Text(supporto.numTelefono),
                        const SizedBox(width: 8),
                        Text(
                            '${supporto.via}, ${supporto.citta}, ${supporto.provincia}'),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
