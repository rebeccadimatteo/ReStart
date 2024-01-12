import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:restart_all_in_one/utils/jwt_utils.dart';
import '../../../utils/auth_service.dart';
import '../../components/app_bar_ca.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [Evento]
class ModifyLavoro extends StatefulWidget {
  @override
  _ModifyLavoroState createState() => _ModifyLavoroState();
}

/// Classe associata a [ModifyLavoro] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo evento temporaneo.
class _ModifyLavoroState extends State<ModifyLavoro> {
  late int idCa;
  var token;
  late AnnuncioDiLavoroDTO annuncio;

  late TextEditingController? nomeController;
  late TextEditingController? descrizioneController;
  late TextEditingController? emailController;
  late TextEditingController? numTelefonoController;
  late TextEditingController? cittaController;
  late TextEditingController? viaController;
  late TextEditingController? provinciaController;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    nomeController = null;
    descrizioneController = null;
    emailController = null;
    numTelefonoController = null;
    cittaController = null;
    viaController = null;
    provinciaController = null;
    token = SessionManager().get("token");
  }

  @override
  void dispose() {
    nomeController?.dispose();
    descrizioneController?.dispose();
    emailController?.dispose();
    numTelefonoController?.dispose();
    cittaController?.dispose();
    viaController?.dispose();
    provinciaController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    annuncio =
        ModalRoute.of(context)?.settings.arguments as AnnuncioDiLavoroDTO;
    if (nomeController == null) {
      nomeController = TextEditingController(text: annuncio.nome);
      descrizioneController = TextEditingController(text: annuncio.descrizione);
      cittaController = TextEditingController(text: annuncio.citta);
      viaController = TextEditingController(text: annuncio.via);
      provinciaController = TextEditingController(text: annuncio.provincia);
      emailController = TextEditingController(text: annuncio.email);
      numTelefonoController = TextEditingController(text: annuncio.numTelefono);
    }
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserCA();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm(AnnuncioDiLavoroDTO lavoro) async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeController!.text;
      String descrizione = descrizioneController!.text;
      String citta = cittaController!.text;
      String via = viaController!.text;
      String provincia = provinciaController!.text;
      String email = emailController!.text;
      String numTelefono = numTelefonoController!.text;
      String imagePath = 'images/image_${nome}.jpg';

      // Crea il DTO con il percorso dell'immagine
      AnnuncioDiLavoroDTO annuncio = AnnuncioDiLavoroDTO(
        id: lavoro.id,
        nomeLavoro: nome,
        descrizione: descrizione,
        approvato: true,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        immagine: imagePath,
        id_ca: JWTUtils.getIdFromToken(accessToken: await token),
        numTelefono: numTelefono,
      );
      // Invia i dati al server con il percorso dell'immagine
      await sendDataToServer(annuncio);
    } else {
      print("Lavoro non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(AnnuncioDiLavoroDTO annuncio) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/modifyLavoro'),
      body: jsonEncode(annuncio),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      // Aggiungi ID del corso e nome del'adl come campi di testo
      imageRequest.fields['nome'] = annuncio.nome;

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
        appBar: CaAppBar(
          showBackButton: true,
        ),
        endDrawer: CaAppBar.buildDrawer(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.08),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Modifica Annuncio di Lavoro',
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
                            //initialValue: evento.nomeEvento,
                            controller: nomeController,
                            decoration: const InputDecoration(
                                labelText: 'Nome Annuncio di Lavoro'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {}
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: descrizioneController,
                            decoration:
                                const InputDecoration(labelText: 'Descrizione'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la descrizione dell\'annuncio di lavoro';
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
                                return 'Inserisci la mail dell\'annuncio di lavoro';
                              }
                              return null;
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: numTelefonoController,
                            decoration: const InputDecoration(
                                labelText: 'Numero di Telefono'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci il numero di telefono dell\'annuncio di lavoro';
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
                                return 'Inserisci la città dov\è situato l\'annuncio di lavoro';
                              }
                              return null;
                            }),
                        TextFormField(
                            controller: viaController,
                            decoration: const InputDecoration(labelText: 'Via'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserisci la via dov\è situato l\'annuncio di lavoro';
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
                                return 'Inserisci la provincia dov\è situato l\'annuncio di lavoro';
                              }
                              return null;
                            }),
                        SizedBox(height: screenWidth * 0.1),
                        ElevatedButton(
                          onPressed: () {
                            submitForm(annuncio);
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
