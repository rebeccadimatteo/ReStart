import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:restart_all_in_one/presentation/components/app_bar_ca.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

class ListaUtentiCandidati extends StatefulWidget {
  ListaUtentiCandidati({super.key});

  @override
  State<ListaUtentiCandidati> createState() => _ListaUtentiState();
}

class _ListaUtentiState extends State<ListaUtentiCandidati> {
  List<UtenteDTO> utenti = [];
  late AnnuncioDiLavoroDTO annuncio;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
    fetchDataFromServer();
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

  Future<void> fetchDataFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/candidaturaLavoro/listaCandidati'),
        body: jsonEncode(annuncio));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('candidati')) {
        final List<UtenteDTO> data =
            List<Map<String, dynamic>>.from(responseBody['candidati'])
                .map((json) => UtenteDTO.fromJson(json))
                .toList();
        setState(() {
          utenti = data;
        });
      } else {
        print('Chiave "candidati" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

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
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: const Text(
                'Lista utenti candidati',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
                itemCount: utenti.length,
                itemBuilder: (context, index) {
                  final utente = utenti[index];
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.profiloCandidato,
                          arguments: utente.username,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: ListTile(
                            visualDensity:
                                const VisualDensity(vertical: 4, horizontal: 4),
                            minVerticalPadding: 50,
                            minLeadingWidth: 80,
                            tileColor: Colors.transparent,
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  Image.asset(utente.immagine).image,
                            ),
                            title: Text(
                              utente.nome,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              utente.email,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ));
                }),
          ),
        ],
      ),
    );
  }
}

class ProfiloCandidato extends StatefulWidget {
  @override
  State<ProfiloCandidato> createState() => _ProfiloState();
}

class _ProfiloState extends State<ProfiloCandidato> {
  late UtenteDTO? utente;
  late String userId;
  late DateTime? selectedDate;
  var token = SessionManager().get('token');
  TextEditingController dataNascitaController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    utente = UtenteDTO(
        nome: 'nome',
        cognome: 'cognome',
        cod_fiscale: 'cod_fiscale',
        data_nascita: DateTime.now(),
        luogo_nascita: 'luogo_nascita',
        genere: 'genere',
        username: 'username',
        password: 'password',
        email: 'email',
        num_telefono: 'num_telefono',
        immagine: 'images/avatar.png',
        via: 'via',
        citta: 'citta',
        provincia: 'provincia',
        lavoro_adatto: 'lavoro_adatto');
    // _checkUserAndNavigate();
    // fetchProfiloFromServer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now you can safely access inherited widgets like ModalRoute
    userId = ModalRoute.of(context)!.settings.arguments as String;
    _checkUserAndNavigate();
    fetchProfiloFromServer();
  }

  Future<void> fetchProfiloFromServer() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/visualizzaUtente'),
      body: jsonEncode({'user': userId}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        final UtenteDTO data = UtenteDTO.fromJson(responseBody['result']);
        setState(() {
          utente = data;
        });
      } else {
        print('Chiave "utente" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Widget buildProfileField(String label, String value, TextStyle labelStyle,
      TextStyle valueStyle, double screenWidth) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: labelStyle,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final String data = utente!.data_nascita.toIso8601String();
    final String dataBuona = data.substring(0, 10);
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.1, horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (utente != null)
                ListTile(
                  leading: CircleAvatar(
                    radius: screenWidth * 0.10,
                    backgroundImage: AssetImage(utente!.immagine),
                  ),
                  title: Text(
                    utente!.username,
                    style: const TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: screenWidth * 0.1),
              Column(
                children: [
                  buildProfileField(
                      'Email',
                      utente!.email,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Nome',
                      utente!.nome,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Cognome',
                      utente!.cognome,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Codice fiscale',
                      utente!.cod_fiscale,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Data di nascita',
                      dataBuona,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Luogo di nascita',
                      utente!.luogo_nascita as String,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Genere',
                      utente!.genere,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Città',
                      utente!.citta,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Via',
                      utente!.via,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Provicia',
                      utente!.provincia,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                ],
              ),
              SizedBox(height: screenWidth * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
