import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [CorsoDiFormazione]
class InserisciCorso extends StatefulWidget {
  @override
  _InserisciCorsoState createState() => _InserisciCorsoState();
}

/// Classe associata a [InserisciCorso] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo corso di formazione.
class _InserisciCorsoState extends State<InserisciCorso> {
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
  XFile? _image;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeCorsoController = TextEditingController();
  final TextEditingController nomeResponsabileController =
  TextEditingController();
  final TextEditingController cognomeResponsabileController =
  TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
  final TextEditingController urlCorsoController = TextEditingController();

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nomeCorso = nomeCorsoController.text;
      String nomeResponsabile = nomeResponsabileController.text;
      String cognomeResponsabile = cognomeResponsabileController.text;
      String descrizione = descrizioneController.text;
      String urlCorso = urlCorsoController.text;
      String imagePath = 'images/image_${nomeCorso}.jpg';

      /// Crea il DTO con il percorso dell'immagine
      CorsoDiFormazioneDTO corso = CorsoDiFormazioneDTO(
        nomeCorso: nomeCorso,
        nomeResponsabile: nomeResponsabile,
        cognomeResponsabile: cognomeResponsabile,
        descrizione: descrizione,
        urlCorso: urlCorso,
        immagine: imagePath,
      );

      /// Invia i dati al server con il percorso dell'immagine
      await sendDataToServer(corso);
    } else {
      print("Errore creazione ogetto corso");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(CorsoDiFormazioneDTO corso) async {
    // Prima invia i dati del corso
    final url = Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addCorso');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(corso),
    );


    if (response.statusCode == 200 && _image != null) {
      final imageUrl = Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);


      imageRequest.files.add(await http.MultipartFile.fromPath('immagine', _image!.path));


      imageRequest.fields['nome'] = corso.nomeCorso;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {

        print("Immagine caricata con successo.");

      } else {
        print("Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un corso di formazione.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.3;

    return Scaffold(
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
                                    ?  MemoryImage(File(_image!.path).readAsBytesSync())
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
                            controller: nomeCorsoController,
                            decoration:
                            const InputDecoration(
                              labelText: 'Nome corso',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                labelText: 'Nome responsabile',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                labelText: 'Cognome responsabile',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            const InputDecoration(
                                labelText: 'Descrizione',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                labelText: 'Numero di telefono',
                              labelStyle: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                            ),
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
                            const InputDecoration(
                                labelText: 'Sito',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (urlCorso) {
                              if (urlCorso == null || urlCorso.isEmpty) {
                                return 'Inserisci il sito web del corso';
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
    );
  }
}
