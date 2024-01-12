import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_all_in_one/utils/jwt_utils.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/generic_app_bar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [Evento]
class ModifyEvento extends StatefulWidget {

  @override
  _ModifyEventoState createState() => _ModifyEventoState();
}

/// Classe associata a [ModifyEvento] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo evento temporaneo.
class _ModifyEventoState extends State<ModifyEvento> {
  late int idCa;
  var token;
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    token = SessionManager().get("token");
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserCA();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);

    }
  }
/*
  Future<void> modifyEvento(EventoDTO evento) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/modifyEvento'),
        body: jsonEncode(evento));
    if (response.statusCode == 200) {
      setState(() {
        for (EventoDTO e in eventi) {
          if (e.id == evento.id) {
            eventi.remove(e);
            break;
          }
        }
        eventi.add(evento);
      });
    } else {
      print("Mofifica non andata a buon fine");
    }
  }*/

  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sitoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String descrizione = descrizioneController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String email = emailController.text;
      String sito = sitoController.text;
      String imagePath = 'images/image_${nome}.jpg';

      // Crea il DTO con il percorso dell'immagine
      EventoDTO evento = EventoDTO(
        nomeEvento: nome,
        descrizione: descrizione,
        approvato: true,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        sito: sito,
        immagine: imagePath,
        id_ca: JWTUtils.getIdFromToken(accessToken: await token),
        date: DateTime.now(),
      );
      // Invia i dati al server con il percorso dell'immagine
      await sendDataToServer(evento);
    } else {
      print("Evento non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(EventoDTO evento) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/addEvento'),
      body: jsonEncode(evento),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestionerReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      // Aggiungi ID del corso e nome del'evento come campi di testo
      imageRequest.fields['nome'] = evento.nomeEvento;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        // L'immagine è stata caricata con successo
        print("Immagine caricata con successo.");
      } else {
        // Si è verificato un errore nell'upload dell'immagine
        print(
            "Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un evento temporaneo.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.3;

    return MaterialApp(
      home: Scaffold(
        appBar: GenericAppBar(
          showBackButton: true,
        ),
        endDrawer: GenericAppBar.buildDrawer(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.08),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Inserisci evento',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              child: CircleAvatar(
                                backgroundImage: _image != null
                                    ? MemoryImage(
                                        File(_image!.path).readAsBytesSync())
                                    : Image.asset('images/avatar.png').image,
                              ),
                            ),
                            Positioned(
                              bottom: -1,
                              left: screenWidth * 0.18,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: Icon(Icons.add_a_photo_sharp),
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                            controller: nomeController,
                            decoration:
                                const InputDecoration(labelText: 'Nome evento'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il nome dell\'evento';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: descrizioneController,
                            decoration:
                                const InputDecoration(labelText: 'Descrizione'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la descrizione dell\'evento';
                              }
                              return null;
                            }),
                        const SizedBox(height: 40),
                        const Text(
                          'Contatti',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: emailController,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la mail dell\'evento';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: sitoController,
                            decoration:
                                const InputDecoration(labelText: 'Sito web'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il sito web dell\'evento';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: cittaController,
                            decoration:
                                const InputDecoration(labelText: 'Città'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la città dov\è situato l\'evento';
                              }
                              return null;
                            }),
                        TextFormField(
                            controller: viaController,
                            decoration: const InputDecoration(labelText: 'Via'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la via dov\è situato l\'evento';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: provinciaController,
                            decoration:
                                const InputDecoration(labelText: 'Provincia'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la provincia dov\è situato l\'evento';
                              }
                              return null;
                            }),
                        SizedBox(height: screenWidth * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            submitForm;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            foregroundColor: Colors.black,
                            shadowColor: Colors.grey,
                            elevation: 10,
                            minimumSize:
                                Size(screenWidth * 0.1, screenWidth * 0.1),
                          ),
                          child: const Text(
                            'INSERISCI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
