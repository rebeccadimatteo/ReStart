import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:restart/presentation/components/app_bar_ads.dart';
import '../../../model/entity/utente_DTO.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

/// Classe ListaUtenti che estende StatefulWidget.
/// Questa classe gestisce la visualizzazione di una lista di utenti.
class ListaUtenti extends StatefulWidget {
  ListaUtenti({super.key});

  @override
  State<ListaUtenti> createState() => _ListaUtentiState();
}

/// Stato associato a ListaUtenti.
/// Gestisce il ciclo di vita dello stato e la logica di visualizzazione dell'elenco degli utenti.
class _ListaUtentiState extends State<ListaUtenti> {
  List<UtenteDTO> utenti = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
    _checkUserAndNavigate();
  }
  /// Controlla se l'utente è autorizzato e, in caso negativo, lo reindirizza alla home.
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
  /// Recupera i dati degli utenti dal server.
  Future<void> fetchDataFromServer() async {
    final response = await http
        .post(Uri.parse('http://10.0.2.2:8080/autenticazione/listaUtenti'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('utenti')) {
        final List<UtenteDTO> data =
            List<Map<String, dynamic>>.from(responseBody['utenti'])
                .map((json) => UtenteDTO.fromJson(json))
                .toList();
        setState(() {
          utenti = data;
        });
      } else {
        print('Chiave "utenti" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }
  /// Elimina un utente dalla lista.
  ///
  /// [UtenteDTO] L'oggetto UtenteDTO che rappresenta l'utente da eliminare.
  Future<void> deleteUtente(UtenteDTO utente) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/deleteUtente'),
        body: jsonEncode(utente));
    if (response.statusCode == 200) {
      setState(() {
        utenti.remove(utente);
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
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: const Text(
                  'Lista utenti',
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
                  return Padding(
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
                            offset: const Offset(0, 2),
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
                          backgroundImage: Image.asset(utente.immagine).image,
                        ),
                        title: Text(
                          utente.username,
                          style: const TextStyle(
                            fontFamily: 'Genos',
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.black, size: 30),
                          onPressed: () {
                            deleteUtente(utente);
                            Navigator.pushNamed(context, AppRoutes.homeADS);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Utente Eliminato!',
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