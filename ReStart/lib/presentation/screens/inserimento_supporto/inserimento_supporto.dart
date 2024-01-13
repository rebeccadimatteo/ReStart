import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/supporto_medico_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un SupportoMedico
class InserisciSupporto extends StatefulWidget {
  _InserisciSupportoState createState() => _InserisciSupportoState();
}

/// Classe associata a [InserisciSupporto] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo supporto medico.
class _InserisciSupportoState extends State<InserisciSupporto> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }
  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserADS();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }
  XFile? _image;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeMedicoController = TextEditingController();
  final TextEditingController cognomeMedicoController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
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
      String nomeMedico = nomeMedicoController.text;
      String cognomeMedico = cognomeMedicoController.text;
      String descrizione = descrizioneController.text;
      String tipo = tipoController.text;
      String email = emailController.text;
      String numTelefono = numTelefonoController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String imagePath = 'images/image_${nomeMedico}.jpg';

      /// Crea il DTO con il percorso dell'immagine
      SupportoMedicoDTO supporto = SupportoMedicoDTO(
          immagine: imagePath,
          nomeMedico: nomeMedico,
          cognomeMedico: cognomeMedico,
          descrizione: descrizione,
          tipo: tipo,
          email: email,
          numTelefono: numTelefono,
          citta: citta,
          via: via,
          provincia: provincia);

      /// Invia i dati al server con il percorso dell'immagine
      await sendDataToServer(supporto);
    } else {
      print("Errore creazione ogetto corso");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(SupportoMedicoDTO supporto) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addSupporto'),
      body: jsonEncode(supporto),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200  && _image != null) {
      final imageUrl = Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files.add(await http.MultipartFile.fromPath('immagine', _image!.path));

      // Aggiungi ID del corso e nome del corso come campi di testo
      imageRequest.fields['nome'] = supporto.nomeMedico; // Assumi che 'nomeCorso' sia una proprietà di CorsoDiFormazioneDTO

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        // L'immagine è stata caricata con successo
        print("Immagine caricata con successo.");
        // Aggiorna l'UI o esegui altre operazioni
      } else {
        // Si è verificato un errore nell'upload dell'immagine
        print("Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
        // Mostra un messaggio di errore o esegui altre operazioni di gestione dell'errore
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
                      fontSize: 23,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
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
                        const SizedBox(height: 15),
                        TextFormField(
                            controller: nomeMedicoController,
                            decoration:
                                const InputDecoration(
                                    labelText: 'Nome medico',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il nome del medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: cognomeMedicoController,
                            decoration: const InputDecoration(
                                labelText: 'Cognome medico',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il cognome del medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: descrizioneController,
                            decoration:
                                const InputDecoration(
                                    labelText: 'Descrizione',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la descrizione del supporto medico offerto';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: tipoController,
                            decoration:
                                const InputDecoration(
                                    labelText: 'Tipo',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il tipo del supporto medico offerto';
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
                                return 'Inserisci la email del medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: numTelefonoController,
                            decoration: const InputDecoration(
                                labelText: 'Numero di telefono',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                return 'Inserisci la città dove si trova il medico';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
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
                                return 'Inserisci la via dove si trova il medico';
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
