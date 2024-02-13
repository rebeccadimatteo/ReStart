import 'dart:convert';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/app_bar_ca.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe InserisciEvento è un StatefulWidget che rappresenta la schermata di inserimento di un nuovo evento.
class InserisciEvento extends StatefulWidget {
  @override
  _InserisciEventoState createState() => _InserisciEventoState();
}

/// Classe _InserisciEventoState gestisce lo stato del widget InserisciEvento.
/// Contiene la logica e l'interfaccia utente per l'inserimento di un evento.
class _InserisciEventoState extends State<InserisciEvento> {
  late int idCa;
  var token;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    token = SessionManager().get("token");
  }

  /// Verifica se l'utente attuale è autenticato e ha il permesso di inserire eventi.
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
  DateTime? selectedDate;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  bool _isNomeValid = true;
  bool _isDescrizioneValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  final bool _isDataValid = true;

  /// Espressioni regolari
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
    if (email.length < 6 || email.length > 40) {
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

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per selezionare una data tramite un DatePicker.
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDate = now;
    DateTime lastDate = DateTime(2099, 12, 31, 23, 59);
    DateTime firstAllowedDate =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime day) {
        return day.isBefore(firstAllowedDate);
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dataController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  /// Metodo per inviare il form al metodo [sendDataToServer].
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String descrizione = descrizioneController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String email = emailController.text;
      String imagePath = 'images/corsodiformazione11.jpg';

      EventoDTO evento = EventoDTO(
          nomeEvento: nome,
          descrizione: descrizione,
          approvato: false,
          citta: citta,
          via: via,
          provincia: provincia,
          email: email,
          immagine: imagePath,
          id_ca: JWTUtils.getIdFromToken(accessToken: await token),
          date: selectedDate!);
      sendDataToServer(evento);
    }
  }

  /// Metodo per inviare i dati al server.
  /// Gestisce l'invio dell'evento e dell'immagine associata.
  Future<void> sendDataToServer(EventoDTO evento) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/addEvento'),
      body: jsonEncode(evento),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      imageRequest.fields['nome'] = evento.nomeEvento;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.homeCA);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Richiesta inviata con successo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.lightBlue,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        Navigator.pushNamed(context, AppRoutes.homeCA);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Impossibile inviare la richiesta. Riprovare',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

        print(
            "Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    } else if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppRoutes.homeCA);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Richiesta inviata con successo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.lightBlue,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.pushNamed(context, AppRoutes.homeCA);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossibile inviare la richiesta. Riprovare',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Costruisce l'interfaccia utente per la schermata di inserimento di un evento.
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
        key: const Key('inserisciEvento'),
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isNomeValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('nomeEvento'),
                      controller: nomeController,
                      onChanged: (value) {
                        setState(() {
                          _isNomeValid = validateNome(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un nome';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: 'Inserisci il nome dell\'evento...',
                        errorText: _isNomeValid
                            ? null
                            : 'Formato nome non corretto (ex. Evento Comunitario \n    [max. 50 caratteri])',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isDescrizioneValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('descrizione'),
                      controller: descrizioneController,
                      onChanged: (value) {
                        setState(() {
                          _isDescrizioneValid = validateDescrizione(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci una descrizione';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Descrizione',
                        hintText: 'Inserisci la descrizione dell\'evento...',
                        // Cambia il colore del testo in rosso se la descrizione non è valida
                        errorText: _isDescrizioneValid
                            ? null
                            : 'Lunghezza descrizione non corretta (max. 255 caratteri)',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Luogo e Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isCittaValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('citta'),
                      controller: cittaController,
                      onChanged: (value) {
                        setState(() {
                          _isCittaValid = validateCitta(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci una città';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Citta',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Inserisci la città dell\'evento...',
                        errorText: _isCittaValid
                            ? null
                            : 'Formato città non corretto (ex: Napoli)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isViaValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('via'),
                      controller: viaController,
                      onChanged: (value) {
                        setState(() {
                          _isViaValid = validateVia(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci una via';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Via',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Inserisci la via dell\'evento...',
                        errorText: _isViaValid
                            ? null
                            : 'Formato via non corretto (ex: Via Fratelli Napoli, 1)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isProvinciaValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('provincia'),
                      controller: provinciaController,
                      onChanged: (value) {
                        setState(() {
                          _isProvinciaValid = validateProvincia(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci una provincia';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Provincia',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Inserisci la provincia dell\'evento...',
                        errorText: _isProvinciaValid
                            ? null
                            : 'Formato provincia non corretta (ex: AV)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isDataValid ? 15 : 20),
                    child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: DateTimeFormField(
                          key: const Key('data'),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Data e ora',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          firstDate: DateTime.now(),
                          validator: (e) =>
                              (e?.day ?? 0) == 1 ? 'Non il primo giorno' : null,
                          onChanged: (DateTime? value) {
                            selectedDate = value;
                          },
                        )),
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isEmailValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('email'),
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          _isEmailValid = validateEmail(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci una email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Inserisci l\'email...',
                        errorText: _isEmailValid
                            ? null
                            : 'Formato email non corretta (ex: esempio@esempio.com)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      submitForm();
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
                        key: const Key('inserisciEventoButton'),
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
