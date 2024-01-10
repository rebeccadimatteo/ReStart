import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;

class ListaUtenti extends StatefulWidget {
  ListaUtenti({super.key});

  @override
  State<ListaUtenti> createState() => _ListaUtentiState();
}

class _ListaUtentiState extends State<ListaUtenti> {
  List<UtenteDTO> utenti = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

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
    return MaterialApp(
      home: Scaffold(
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
                  'Lista utenti',
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
                itemCount: utenti.length,
                itemBuilder: (context, index) {
                  final utente = utenti[index];
                  return Padding(
                    padding:
                    const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                    child: ListTile(
                      visualDensity:
                      const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.grey,
                      leading: const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais',
                        ),
                      ),
                      title: Text(
                        utente.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(utente.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red, size: 30),
                        onPressed: () {
                          deleteUtente(utente);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(ListaUtenti());
}