import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart/presentation/components/app_bar_ads.dart';
import '../../../model/entity/alloggio_temporaneo_DTO.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [AlloggioTemporaneo]
class InserisciAlloggio extends StatefulWidget {
  @override
  _InserisciAlloggioState createState() => _InserisciAlloggioState();
}

/// Classe associata a [InserisciAlloggio] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo alloggio temporaneo.
class _InserisciAlloggioState extends State<InserisciAlloggio> {
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  /// Verifica se l'utente attuale è autenticato e ha il permesso di inserire alloggi.

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

  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  final TextEditingController nomeAlloggioController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sitoController = TextEditingController();

  bool _isNomeValid = true;
  bool _isDescrizioneValid = true;
  bool _isTipoValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  bool _isSitoValid = true;

  /// Espressioni regolari
  bool validateNome(String nome) {
    RegExp regex = RegExp(
        r"^[A-Za-zÀ-ú0-9‘’',\.\(\)\s\/|\\{}\[\],\-!$%&?<>=^+°#*:']{2,50}$");
    return regex.hasMatch(nome);
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

  bool validateDescrizione(String descrizione) {
    RegExp regex = RegExp(
        r"^[A-Za-zÀ-ú0-9‘’',\.\(\)\s\/|\\{}\[\],\-!$%&?<>=^+°#*:']{2,255}$");
    return regex.hasMatch(descrizione);
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

  bool validateImmagine(String immagine) {
    RegExp regex = RegExp(r'^.+\.jpe?g$');
    return regex.hasMatch(immagine);
  }

  bool validateSito(String sito) {
    RegExp regex = RegExp(
      r'^(http:\/\/|https:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    return regex.hasMatch(sito);
  }

  bool validateTipo(String tipo) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
    return regex.hasMatch(tipo);
  }

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al metodo [sendDataToServer].
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
      String imagePath = 'images/alloggiotemporaneo11.jpg';

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
      await sendDataToServer(alloggio);
    } else {
      print("Alloggio non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  /// Gestisce l'invio dell'alloggio e dell'immagine associata.
  Future<void> sendDataToServer(AlloggioTemporaneoDTO alloggio) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addAlloggio'),
      body: jsonEncode(alloggio),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      imageRequest.fields['nome'] = alloggio.nome;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Alloggio inserito con successo',
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
              'Impossibile inserire l\'alloggio. Riprovare',
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
            'Alloggio inserito con successo',
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
            'Impossibile inserire l\'alloggio. Riprovare',
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

  /// Costruisce l'interfaccia utente per la schermata di inserimento di un alloggio temporaneo.
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
        key: const Key('inserisciAlloggio'),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              'Inserisci Alloggio',
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
                      key: const Key('nomeAlloggioField'),
                      controller: nomeAlloggioController,
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
                        labelText: 'Nome Alloggio',
                        hintText: 'Inserisci il nome...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isNomeValid
                            ? null
                            : 'Formato nome non corretto (ex. Alloggio Example \n    [max. 50 caratteri])',
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
                      key: const Key('descrizioneField'),
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 15,
                        bottom: _isTipoValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('tipoField'),
                      controller: tipoController,
                      onChanged: (value) {
                        setState(() {
                          _isTipoValid = validateTipo(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un tipo';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Tipologia',
                        hintText: 'Inserisci il tipo di alloggio...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isTipoValid
                            ? null
                            : 'Formato tipo non corretto (ex. Bilocale \n    [max. 50 caratteri])',
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
                    'Luogo',
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
                      key: const Key('cittaField'),
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
                        hintText: 'Inserisci la città dell\'alloggio...',
                        // Cambia il colore del testo in rosso se città non è valida
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
                      key: const Key('viaField'),
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
                        hintText: 'Inserisci la via dell\'alloggio...',
                        // Cambia il colore del testo in rosso se via non è valida
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
                      key: const Key('provinciaField'),
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
                        hintText: 'Inserisci la provincia dell\'alloggio...',
                        // Cambia il colore del testo in rosso se provincia non è valida
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
                      key: const Key('emailField'),
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
                        bottom: _isSitoValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('sitoField'),
                      controller: sitoController,
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
