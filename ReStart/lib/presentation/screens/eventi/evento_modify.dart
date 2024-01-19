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

  final bool _isNomeValid = true;
  final bool _isDescrizioneValid = true;
  final bool _isEmailValid = true;
  final bool _isViaValid = true;
  final bool _isCittaValid = true;
  final bool _isProvinciaValid = true;

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
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
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
      String imagePath = 'images/image_$nome.jpg';

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

  bool validateNome(String nome) {
    RegExp regex = RegExp(r"^[A-Za-zÀ-ú‘’',\(\)\s]{2,50}$");
    return regex.hasMatch(nome);
  }

  bool validateDescrizione(String descrizione) {
    RegExp regex = RegExp(
        r"^[A-Za-zÀ-ú0-9‘’',\.\(\)\s\/|\\{}\[\],\-!$%&?<>=^+°#*:']{2,255}$");
    return regex.hasMatch(descrizione);
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(r'^[A-Za-z0-9_.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    if(email.length < 6 || email.length > 40) {
      return false;
    }
    return regex.hasMatch(email);
  }

  bool validateVia(String via) {
    RegExp regex = RegExp(r'^[a-zA-Z .]+(,\s?[a-zA-Z0-9 ]*)?$');
    return regex.hasMatch(via);
  }

  bool validateCitta(String citta) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
    return regex.hasMatch(citta);
  }

  bool validateProvincia(String provincia) {
    RegExp regex = RegExp(r'^[A-Z]{2}');
    if (provincia.length > 2) return false;
    return regex.hasMatch(provincia);
  }

  bool validateTelefono(String telefono) {
    RegExp regex = RegExp(r'^\+\d{12}$');
    return regex.hasMatch(telefono);
  }

  bool validateImmagine(String immagine) {
    RegExp regex = RegExp(r'^.+\.jpe?g$');
    return regex.hasMatch(immagine);
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
              'Modifica Evento',
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
                      SizedBox(
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
                          icon: const Icon(Icons.add_a_photo_sharp),
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      errorText: _isNomeValid
                          ? null
                          : 'Formato nome non corretto (ex. Evento Comunitario \n    [max. 50 caratteri])',
                      errorStyle: const TextStyle(color: Colors.red),
                      labelText: 'Nome evento',
                      labelStyle: const TextStyle(
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
                      decoration: InputDecoration(
                        errorText: _isDescrizioneValid
                            ? null
                            : 'Lunghezza descrizione non corretta (max. 255 caratteri)',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelText: 'Descrizione',
                        labelStyle: const TextStyle(
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
                      decoration: InputDecoration(
                        errorText: _isEmailValid
                            ? null
                            : 'Formato email non corretta (ex: esempio@esempio.com)',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelText: 'Email',
                        labelStyle: const TextStyle(
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
                      decoration: InputDecoration(
                        errorText: _isCittaValid
                            ? null
                            : 'Formato città non corretto (ex: Napoli)',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelText: 'Città',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la città dovè situato l\'evento';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: viaController,
                      decoration: InputDecoration(
                        errorText: _isViaValid
                            ? null
                            : 'Formato via non corretto (ex: Via Fratelli Napoli, 1)',
                        labelText: 'Via',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la via dov\'è situato l\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: provinciaController,
                      decoration: InputDecoration(
                        errorText: _isProvinciaValid
                            ? null
                            : 'Formato provincia non corretta (ex: AV)',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelText: 'Provincia',
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la provincia dov\'è situato l\'evento';
                        }
                        return null;
                      }),
                  SizedBox(height: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      submitForm(evento);
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
