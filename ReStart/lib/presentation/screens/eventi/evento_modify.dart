import 'dart:convert';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

///Classe che rappresenta la schermata per modificare un [Evento]
class ModifyEvento extends StatefulWidget {
  @override
  _ModifyEventoState createState() => _ModifyEventoState();
}

/// Classe associata a [ModifyEvento] e gestisce la logica e l'interazione
/// dell'interfaccia utente per modificare un nuovo evento.
class _ModifyEventoState extends State<ModifyEvento> {
  late int idCa;
  var token;
  late EventoDTO evento;

  late TextEditingController? nomeController;
  late TextEditingController? descrizioneController;
  late TextEditingController? dataController;
  late TextEditingController? emailController;
  late TextEditingController? cittaController;
  late TextEditingController? viaController;
  late TextEditingController? provinciaController;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    nomeController = null;
    descrizioneController = null;
    emailController = null;
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
    cittaController?.dispose();
    viaController?.dispose();
    provinciaController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    evento = ModalRoute.of(context)?.settings.arguments as EventoDTO;
    if (nomeController == null) {
      nomeController = TextEditingController(text: evento.nomeEvento);
      descrizioneController = TextEditingController(text: evento.descrizione);
      cittaController = TextEditingController(text: evento.citta);
      viaController = TextEditingController(text: evento.via);
      provinciaController = TextEditingController(text: evento.provincia);
      emailController = TextEditingController(text: evento.email);
    }
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

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm(EventoDTO event) async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeController!.text;
      String descrizione = descrizioneController!.text;
      String citta = cittaController!.text;
      String via = viaController!.text;
      String provincia = provinciaController!.text;
      String email = emailController!.text;
      // DateTime data = dataController!.text;
      String imagePath = 'images/image_${nome}.jpg';

      EventoDTO evento = EventoDTO(
        id: event.id,
        nomeEvento: nome,
        descrizione: descrizione,
        approvato: true,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        immagine: imagePath,
        id_ca: JWTUtils.getIdFromToken(accessToken: await token),
        date: selectedDate as DateTime,
      );

      sendDataToServer(evento);
    } else {
      print("Evento non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(EventoDTO evento) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/modifyEvento'),
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

  /// Costruisce la UI per la schermata per la modifica di un evento.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.3;

    return Scaffold(
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
              'Modifica evento',
              style: TextStyle(
                fontSize: 22,
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
                    decoration: const InputDecoration(
                        labelText: 'Nome evento',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {}
                      return null;
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
                  const SizedBox(height: 20),
                  DateTimeFormField(
                    initialValue: evento.date,
                    decoration: const InputDecoration(
                      labelText: 'Data dell\'evento',
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    lastDate: DateTime.now().add(const Duration(days: 40)),
                    initialPickerDateTime:
                        DateTime.now().add(const Duration(days: 20)),
                    onChanged: (DateTime? value) {
                      selectedDate = value;
                    },
                  ),
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
                            'APPLICA MODIFICHE',
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
