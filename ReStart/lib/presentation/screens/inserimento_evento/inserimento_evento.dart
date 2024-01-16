import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [Evento]
class InserisciEvento extends StatefulWidget {
  @override
  _InserisciEventoState createState() => _InserisciEventoState();
}

/// Classe associata a [InserisciEvento] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo evento.
class _InserisciEventoState extends State<InserisciEvento> {
  late int idCa;
  var token;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    token = SessionManager().get("token");
  }

  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserCA'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode != 200){
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  TextEditingController nomeController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sitoController = TextEditingController();
  TextEditingController cittaController = TextEditingController();
  TextEditingController viaController = TextEditingController();
  TextEditingController provinciaController = TextEditingController();

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

      EventoDTO evento = EventoDTO(
        nomeEvento: nome,
        descrizione: descrizione,
        approvato: false,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        sito: sito,
        immagine: imagePath,
        id_ca: JWTUtils.getIdFromToken(accessToken: await token),
        date: DateTime.now(),
      );

      /// Invia i dati al server con il percorso dell'immagine
      sendDataToServer(evento);
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
      print(response);
      final imageUrl =
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      imageRequest.fields['nome'] = evento.nomeEvento;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        print("Immagine caricata con successo.");
        Navigator.pushNamed(context, AppRoutes.eventipubblicati);
      } else {
        print(
            "Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un evento.
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
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              'Inserisci evento',
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                        labelText: 'Nome evento',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {}
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        nomeController.text = value;
                        },
                      );
                    },
                  ),
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
                          return 'Inserisci la descrizione dell\'evento';
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
                      decoration: const InputDecoration(
                          labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la mail dell\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: sitoController,
                      decoration: const InputDecoration(
                          labelText: 'Sito web',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il sito web dell\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: cittaController,
                      decoration: const InputDecoration(
                          labelText: 'Città',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la città dov\è situato l\'evento';
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
                          return 'Inserisci la via dov\è situato l\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: provinciaController,
                      decoration: const InputDecoration(
                          labelText: 'Provincia',
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
void main(){
  runApp(InserisciEvento());
}