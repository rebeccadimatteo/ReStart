import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart/presentation/components/app_bar_ads.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../routes/routes.dart';

/// InserisciCorso è una classe di tipo StatefulWidget.
/// Rappresenta la schermata per l'inserimento di un nuovo corso di formazione.
class InserisciCorso extends StatefulWidget {
  @override
  _InserisciCorsoState createState() => _InserisciCorsoState();
}

/// _InserisciCorsoState è lo stato associato a InserisciCorso.
/// Gestisce la logica e l'interazione dell'interfaccia utente per l'inserimento di un nuovo corso di formazione.
class _InserisciCorsoState extends State<InserisciCorso> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Verifica se l'utente attuale è autenticato e ha il permesso di inserire corsi di formazione.
  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserADS'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
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

  bool _isNomeCorsoValid = true;
  bool _isNomeRespValid = true;
  bool _isCognomeRespValid = true;
  bool _isDescrizioneValid = true;
  bool _isEmailValid = true;
  bool _isTelefonoValid = true;
  bool _isSitoValid = true;

  /// Espressioni regolari
  bool validateNomeCorso(String nome) {
    RegExp regex = RegExp(
        r"^[A-Za-zÀ-ú0-9‘’',\.\(\)\s\/|\\{}\[\],\-!$%&?<>=^+°#*:']{2,50}$");
    return regex.hasMatch(nome);
  }

  bool validateNomeResp(String nome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
    return regex.hasMatch(nome);
  }

  bool validateCognomeResp(String cognome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
    return regex.hasMatch(cognome);
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

  bool validateSito(String sito) {
    RegExp regex = RegExp(
      r'^(http:\/\/|https:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    return regex.hasMatch(sito);
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

  /// Metodo per inviare il form al metodo [sendDataToServer].
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String nomeCorso = nomeCorsoController.text;
      String nomeResponsabile = nomeResponsabileController.text;
      String cognomeResponsabile = cognomeResponsabileController.text;
      String descrizione = descrizioneController.text;
      String urlCorso = urlCorsoController.text;
      String imagePath = 'images/corsodiformazione11.jpg';

      CorsoDiFormazioneDTO corso = CorsoDiFormazioneDTO(
        nomeCorso: nomeCorso,
        nomeResponsabile: nomeResponsabile,
        cognomeResponsabile: cognomeResponsabile,
        descrizione: descrizione,
        urlCorso: urlCorso,
        immagine: imagePath,
      );
      await sendDataToServer(corso);
    } else {
      print("Errore creazione oggetto corso");
    }
  }

  /// Metodo per inviare i dati al server.
  /// Gestisce l'invio del corso di formazione e dell'immagine associata.
  Future<void> sendDataToServer(CorsoDiFormazioneDTO corso) async {
    // Prima invia i dati del corso
    final url =
        Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addCorso');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(corso),
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      imageRequest.fields['nome'] = corso.nomeCorso;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Corso inserito con successo',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Impossibile inserire il corso. Riprovare',
              textAlign: TextAlign.center,
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
    } else if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppRoutes.homeADS);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Corso inserito con successo',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossibile inserire il corso. Riprovare',
            textAlign: TextAlign.center,
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

  /// Costruisce l'interfaccia utente per la schermata di inserimento di un corso di formazione.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.3;

    return Scaffold(
      appBar: AdsAppBar(
        showBackButton: true,
      ),
      endDrawer: AdsAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        key: const Key('inserisciCorso'),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                        bottom: _isNomeCorsoValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('nome'),
                      controller: nomeCorsoController,
                      onChanged: (value) {
                        setState(() {
                          _isNomeCorsoValid = validateNomeCorso(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un nome';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nome Corso',
                        hintText: 'Inserisci il nome...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isNomeCorsoValid
                            ? null
                            : 'Formato nome non corretto (ex. Corso di Python \n    [max. 50 caratteri])',
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
                        bottom: _isNomeRespValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('nomeResponsabile'),
                      controller: nomeResponsabileController,
                      onChanged: (value) {
                        setState(() {
                          _isNomeRespValid = validateNomeResp(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il nome del responsabile';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nome Responsabile',
                        hintText: 'Inserisci il nome del responsabile...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isNomeRespValid
                            ? null
                            : 'Formato nome non corretto (ex. Aldo \n    [max. 20 caratteri])',
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isCognomeRespValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('cognomeResponsabile'),
                      controller: cognomeResponsabileController,
                      onChanged: (value) {
                        setState(() {
                          _isCognomeRespValid = validateCognomeResp(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il cognome del responsabile';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Cognome Responsabile',
                        hintText: 'Inserisci il cognome del responsabile...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isCognomeRespValid
                            ? null
                            : 'Formato cognome non corretto (ex. Bianchi \n    [max. 20 caratteri])',
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
                  const SizedBox(height: 20),
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
                        hintText: 'Inserisci la descrizione...',
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
                    'Contatti',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isTelefonoValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('numero'),
                      controller: numTelefonoController,
                      onChanged: (value) {
                        setState(() {
                          _isTelefonoValid = validateTelefono(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un numero di telefono';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Numero di telefono',
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Inserisci numero di telefono...',
                        errorText: _isTelefonoValid
                            ? null
                            : 'Formato numero di telefono non corretto (ex: +393330000000)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isSitoValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('url'),
                      controller: urlCorsoController,
                      onChanged: (value) {
                        setState(() {
                          _isSitoValid = validateSito(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un sito';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'URL Sito',
                        hintText: 'Inserisci URL del sito...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isSitoValid
                            ? null
                            : 'Formato URL non corretto (ex. https://www.example.it)',
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
                  SizedBox(height: screenWidth * 0.1),
                  ElevatedButton(
                    key: const Key('inserisciButton'),
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
