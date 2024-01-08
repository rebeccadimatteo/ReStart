import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_all_in_one/model/entity/supporto_medico_DTO.dart';
import '../../../utils/utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

///Classe che rappresenta la schermata per inserire un SupportoMedico
class InserisciSupporto extends StatefulWidget {
  _InserisciSupportoState createState() => _InserisciSupportoState();
}
/// Classe associata a [InserisciSupporto] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo supporto medico.
class _InserisciSupportoState extends State<InserisciSupporto> {
  Uint8List? _image;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeMedicoController = TextEditingController();
  final TextEditingController cognomeMedicoController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;

    /// Salva l'immagine nella cartella 'images'
    await saveImageToFolder(_image!);
  }
  /// Metodo per salvare un'immagine nella cartella 'images'.
  Future<String> saveImageToFolder(Uint8List image) async {
    try {
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final destination = path.join(appDocumentsDirectory.path, 'images');

      /// Crea la cartella 'images' se non esiste
      await Directory(destination).create(recursive: true);

      /// Genera un nome univoco per l'immagine
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.png';

      final imagePath = path.join(destination, fileName);

      /// Crea e salva l'immagine nella nuova destinazione
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      print('Immagine salvata in: $imagePath');

      /// Restituisci il percorso dell'immagine
      return imagePath;
    } catch (e) {
      print('Errore durante il salvataggio dell\'immagine: $e');
      /// Restituisce una stringa vuota in caso di errore
      return '';
    }
  }
  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nomeMedico = nomeMedicoController.text;
      String cognomeMedico = cognomeMedicoController.text;
      String descrizione = descrizioneController.text;
      String email = emailController.text;
      String numTelefono = numTelefonoController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;

      if (_image != null) {
        final imagePath = await saveImageToFolder(_image!);

        /// Crea il DTO con il percorso dell'immagine
        SupportoMedicoDTO supporto = SupportoMedicoDTO(
            immagine: imagePath,
            nomeMedico: nomeMedico,
            cognomeMedico: cognomeMedico,
            descrizione: descrizione,
            email: email,
            numTelefono: numTelefono,
            citta: citta,
            via: via,
            provincia: provincia
        );

        print(supporto);

        /// Invia i dati al server con il percorso dell'immagine
        await sendDataToServer(supporto);

        print("Supporto medico inserito");
      } else {
        print("Devi selezionare un'immagine");
      }
    } else {
      print("Supporto medico non inserito");
    }
  }
  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(SupportoMedicoDTO supporto) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addSupporto'),
      body: jsonEncode(supporto),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        print("Funziona");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento del supporto medico.
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
                    'Inserisci Supporto Medico',
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
                            controller: nomeMedicoController,
                            decoration:
                            const InputDecoration(labelText: 'Nome medico'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il nome del medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: cognomeMedicoController,
                            decoration:
                            const InputDecoration(labelText: 'Cognome medico'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il cognome del medico';
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
                            controller: descrizioneController,
                            decoration:
                            const InputDecoration(labelText: 'Descrizione'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la descrizione del supporto medico offerto';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: emailController,
                            decoration:
                            const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la email del medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: numTelefonoController,
                            decoration:
                            const InputDecoration(labelText: 'Numero di telefono'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la email del medico';
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
                                return 'Inserisci la città dove si trova il medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: viaController,
                            decoration:
                            const InputDecoration(labelText: 'Via'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la via dove si trova il medico';
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
                                return 'Inserisci la provincia dove si trova il medico';
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

void main() {
  runApp(InserisciSupporto());
}
