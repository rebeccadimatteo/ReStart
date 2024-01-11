import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../utils/utils.dart';
import '../../components/generic_app_bar.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

///Classe che rappresenta la schermata per inserire un [AlloggioTemporaneo]
class InserisciAlloggio extends StatefulWidget {
  @override
  _InserisciAlloggioState createState() => _InserisciAlloggioState();
}

/// Classe associata a [InserisciAlloggio] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo alloggio temporaneo.
class _InserisciAlloggioState extends State<InserisciAlloggio> {
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
                                    ? MemoryImage(File(_image!.path).readAsBytesSync())
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
                            controller: nomeAlloggioController,
                            decoration: const InputDecoration(
                                labelText: 'Nome alloggio'),
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
                                const InputDecoration(labelText: 'Descrizione'),
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
                                const InputDecoration(labelText: 'Tipo'),
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
                                return 'Inserisci la mail dell\'alloggio';
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
                                return 'Inserisci il sito web dell\'alloggio';
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
                                return 'Inserisci la città dov\è situato l\'alloggio';
                              }
                              return null;
                            }),
                        TextFormField(
                            controller: viaController,
                            decoration: const InputDecoration(labelText: 'Via'),
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
                                const InputDecoration(labelText: 'Provincia'),
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
