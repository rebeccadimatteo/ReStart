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

class InserisciAlloggio extends StatefulWidget {
  @override
  _InserisciAlloggioState createState() => _InserisciAlloggioState();
}

class _InserisciAlloggioState extends State<InserisciAlloggio> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;

  final TextEditingController nomeAlloggioController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sitoController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;

    // Salva l'immagine nella cartella 'images'
    await saveImageToFolder(_image!);
  }

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

      if (_image != null) {
        final imagePath = await saveImageToFolder(_image!);

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

        print(alloggio);

        // Invia i dati al server con il percorso dell'immagine
        await sendDataToServer(alloggio);

        print("Alloggio inserito");
      } else {
        print("Devi selezionare un'immagine");
      }
    } else {
      print("Alloggio non inserito");
    }
  }

  Future<void> sendDataToServer(AlloggioTemporaneoDTO corso) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addAlloggio'),
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
                          controller: nomeAlloggioController,
                          decoration:
                              const InputDecoration(labelText: 'Nome alloggio'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci il nome dell\'alloggio';
                            }
                            return null;
                          }
                        ),
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
                            }
                        ),
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
                            }
                        ),
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
                            }
                        ),
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
                            }
                        ),
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
                            }
                        ),
                        TextFormField(
                            controller: viaController,
                            decoration:
                            const InputDecoration(labelText: 'Via'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la via dov\è situato l\'alloggio';
                              }
                              return null;
                            }
                        ),
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
                            }
                        ),
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