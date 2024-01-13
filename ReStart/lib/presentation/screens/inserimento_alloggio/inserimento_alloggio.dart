import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/generic_app_bar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [AlloggioTemporaneo]
class InserisciAlloggio extends StatefulWidget {
  @override
  _InserisciAlloggioState createState() => _InserisciAlloggioState();
}

/// Classe associata a [InserisciAlloggio] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo alloggio temporaneo.
class _InserisciAlloggioState extends State<InserisciAlloggio> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserADS'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode != 200){
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  final TextEditingController nomeAlloggioController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sitoController = TextEditingController();

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeAlloggioController.text;
      String descrizione = descrizioneController.text;
      String tipo = tipoController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String email = emailController.text;
      String sito = sitoController.text;
      String imagePath = 'images/image_${nome}.jpg';

      // Crea il DTO con il percorso dell'immagine
      AlloggioTemporaneoDTO alloggio = AlloggioTemporaneoDTO(
        nome: nome,
        descrizione: descrizione,
        tipo: tipo,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        sito: sito,
        immagine: imagePath,
      );
      // Invia i dati al server con il percorso dell'immagine
      await sendDataToServer(alloggio);
    } else {
      print("Alloggio non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(AlloggioTemporaneoDTO alloggio) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addAlloggio'),
      body: jsonEncode(alloggio),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl = Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files.add(await http.MultipartFile.fromPath('immagine', _image!.path));

      // Aggiungi ID del corso e nome del corso come campi di testo
      imageRequest.fields['nome'] = alloggio.nome; // Assumi che 'nomeCorso' sia una proprietà di CorsoDiFormazioneDTO

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        // L'immagine è stata caricata con successo
        print("Immagine caricata con successo.");
      } else {
        // Si è verificato un errore nell'upload dell'immagine
        print("Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un alloggio temporaneo.
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
                    'Inserisci Alloggio',
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'Poppins',
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
                                    ? MemoryImage(File(_image!.path).readAsBytesSync())
                                    : Image.asset('images/avatar.png').image,
                              ),
                            ),
                            Positioned(
                              bottom: -1,
                              left: screenWidth * 0.18,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo_sharp),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: nomeAlloggioController,
                            decoration: const InputDecoration(
                              labelText: 'Nome alloggio',
                              labelStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il nome dell\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: descrizioneController,
                            decoration:
                                const InputDecoration(labelText: 'Descrizione',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la descrizione dell\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: tipoController,
                            decoration:
                                const InputDecoration(labelText: 'Tipo',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il tipo dell\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 40),
                        const Text(
                          'Contatti',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: emailController,
                            decoration:
                                const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la mail dell\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: sitoController,
                            decoration:
                                const InputDecoration(
                                  labelText: 'Sito web',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il sito web dell\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: cittaController,
                            decoration:
                                const InputDecoration(
                                    labelText: 'Città',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la città dov\è situato l\'alloggio';
                              }
                              return null;
                            }),
                        TextFormField(
                            controller: viaController,
                            decoration: const InputDecoration(
                              labelText: 'Via',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la via dov\è situato l\'alloggio';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: provinciaController,
                            decoration:
                                const InputDecoration(
                                    labelText: 'Provincia',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la provincia dov\è situato l\'alloggio';
                              }
                              return null;
                            }),
                        SizedBox(height: screenWidth * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            submitForm;
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              elevation: 10,
                              minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
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
                              width: screenWidth * 0.60,
                              height: screenWidth * 0.1,
                              padding: const EdgeInsets.all(10),
                              child: const Center(
                                child: Text(
                                  'INSERISCI',
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
                ]
            ),
          ),
        ),
      ),
    );
  }
}
