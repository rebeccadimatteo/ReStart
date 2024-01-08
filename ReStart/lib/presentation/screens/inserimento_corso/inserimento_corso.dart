import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../utils/utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

///Classe che rappresenta la schermata per inserire un CorsoDiFormazione
class InserisciCorso extends StatefulWidget {
  @override
  _InserisciCorsoState createState() => _InserisciCorsoState();
}

/// Classe associata a [InserisciCorso] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo supporto medico.
class _InserisciCorsoState extends State<InserisciCorso> {
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeCorsoController = TextEditingController();
  final TextEditingController nomeResponsabileController = TextEditingController();
  final TextEditingController cognomeResponsabileController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
  final TextEditingController urlCorsoController = TextEditingController();

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;

    // Salva l'immagine nella cartella 'images'
    await saveImageToFolder(_image!);
  }

  /// Metodo per salvare un'immagine nella cartella 'images'.
  Future<String> saveImageToFolder(Uint8List image) async {
    try {
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final destination = path.join(appDocumentsDirectory.path, 'images');

      // Crea la cartella 'images' se non esiste
      await Directory(destination).create(recursive: true);

      // Genera un nome univoco per l'immagine
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';

      final imagePath = path.join(destination, fileName);

      // Crea e salva l'immagine nella nuova destinazione
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      print('Immagine salvata in: $imagePath');

      return imagePath; // Restituisci il percorso dell'immagine
    } catch (e) {
      print('Errore durante il salvataggio dell\'immagine: $e');
      return ''; // Restituisci una stringa vuota in caso di errore
    }
  }

  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nomeCorso = nomeCorsoController.text;
      String nomeResponsabile = nomeResponsabileController.text;
      String cognomeResponsabile = cognomeResponsabileController.text;
      String descrizione = descrizioneController.text;
      String urlCorso = urlCorsoController.text;

      if (_image != null) {
        final imagePath = await saveImageToFolder(_image!);

        // Crea il DTO con il percorso dell'immagine
        CorsoDiFormazioneDTO corso = CorsoDiFormazioneDTO(
          nomeCorso: nomeCorso,
          nomeResponsabile: nomeResponsabile,
          cognomeResponsabile: cognomeResponsabile,
          descrizione: descrizione,
          urlCorso: urlCorso,
          immagine: imagePath,
        );

        print(corso);

        // Invia i dati al server con il percorso dell'immagine
        await sendDataToServer(corso);

        print("Corso inserito");
      } else {
        print("Devi selezionare un'immagine");
      }
    } else {
      print("Corso non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(CorsoDiFormazioneDTO corso) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addCorso'),
      body: jsonEncode(corso),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        print("Funziona");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un corso di formazione.
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
                    'Inserisci Corso di Formazione',
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
                            SizedBox(
                              width: avatarSize,
                              height: avatarSize,
                              child: CircleAvatar(
                                backgroundImage: _image != null
                                    ? MemoryImage(_image!)
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
                            controller: nomeCorsoController,
                            decoration:
                            const InputDecoration(labelText: 'Nome corso'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il nome del corso';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: nomeResponsabileController,
                            decoration: const InputDecoration(
                                labelText: 'Nome responsabile'),
                            validator: (nomeResponsabile) {
                              if (nomeResponsabile == null ||
                                  nomeResponsabile.isEmpty) {
                                return 'Inserisci il nome del responsabile';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: cognomeResponsabileController,
                            decoration: const InputDecoration(
                                labelText: 'Cognome responsabile'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il cognome del responsabile';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: descrizioneController,
                            decoration:
                            const InputDecoration(labelText: 'Descrizione'),
                            validator: (descrizione) {
                              if (descrizione == null || descrizione.isEmpty) {
                                return 'Inserisci la descrizione del corso';
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
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Inserisci la email';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: numTelefonoController,
                            decoration: const InputDecoration(
                                labelText: 'Numero di telefono'),
                            validator: (numTelefono) {
                              if (numTelefono == null || numTelefono.isEmpty) {
                                return 'Inserisci il numero di telefono';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: urlCorsoController,
                            decoration:
                            const InputDecoration(labelText: 'Sito'),
                            validator: (urlCorso) {
                              if (urlCorso == null || urlCorso.isEmpty) {
                                return 'Inserisci il sito web del corso';
                              }
                              return null;
                            }),
                        SizedBox(height: screenWidth * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            submitForm();
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

void main() {
  runApp(InserisciCorso());
}