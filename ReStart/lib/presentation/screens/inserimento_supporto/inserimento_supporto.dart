import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:restart/presentation/components/app_bar_ads.dart';
import '../../../model/entity/supporto_medico_DTO.dart';
import '../routes/routes.dart';

///Classe che rappresenta la schermata per inserire un [SupportoMedico]
class InserisciSupporto extends StatefulWidget {
  @override
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

  /// Verifica l'autenticazione dell'utente e naviga alla home se non autorizzato.
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

  final TextEditingController nomeMedicoController = TextEditingController();
  final TextEditingController cognomeMedicoController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();

  bool _isNomeValid = true;
  bool _isCognomeValid = true;
  bool _isDescrizioneValid = true;
  bool _isTipoValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  bool _isTelefonoValid = true;

  /// Espressioni regolari
  bool validateNome(String nome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
    return regex.hasMatch(nome);
  }

  bool validateCognome(String cognome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
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
      String nomeMedico = nomeMedicoController.text;
      String cognomeMedico = cognomeMedicoController.text;
      String descrizione = descrizioneController.text;
      String tipo = tipoController.text;
      String email = emailController.text;
      String numTelefono = numTelefonoController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String imagePath = 'images/supportomedico11.jpg';

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

      await sendDataToServer(supporto);
    } else {
      print("Errore creazione oggetto corso");
    }
  }

  /// Invia i dati del supporto medico al server.
  Future<void> sendDataToServer(SupportoMedicoDTO supporto) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addSupporto'),
      body: jsonEncode(supporto),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      imageRequest.fields['nome'] = supporto.nomeMedico;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.homeCA);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Supporto medico inserito con successo',
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
              'Impossibile inserire il supporto medico. Riprovare',
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
            'Supporto medico inserito con successo',
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
            'Impossibile inserire il supporto medico. Riprovare',
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

  /// Costruisce l'interfaccia utente per la schermata di inserimento del supporto medico.
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
        key: const Key('inserisciSupporto'),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              'Inserisci Supporto Medico',
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
                      key: const Key('nomeMedico'),
                      controller: nomeMedicoController,
                      onChanged: (value) {
                        setState(() {
                          _isNomeValid = validateNome(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il nome del medico';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nome Medico',
                        hintText: 'Inserisci il nome...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isNomeValid
                            ? null
                            : 'Formato nome non corretto (ex. Aldo \n    [max. 50 caratteri])',
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
                        bottom: _isCognomeValid ? 15 : 20),
                    child: TextFormField(
                      key: const Key('cognomeMedico'),
                      controller: cognomeMedicoController,
                      onChanged: (value) {
                        setState(() {
                          _isCognomeValid = validateNome(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il cognome del medico';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Cognome Medico',
                        hintText: 'Inserisci il cognome...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isCognomeValid
                            ? null
                            : 'Formato cognome non corretto (ex. Bianchi \n    [max. 50 caratteri])',
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
                      key: const Key('tipologia'),
                      controller: tipoController,
                      onChanged: (value) {
                        setState(() {
                          _isTipoValid = validateNome(value);
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
                        hintText: 'Inserisci il tipo di supporto...',
                        // Cambia il colore del testo in rosso se il nome non è valido
                        errorText: _isTipoValid
                            ? null
                            : 'Formato tipo non corretto (ex. Psicologo \n    [max. 50 caratteri])',
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
                        hintText: 'Inserisci la città...',
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
                        hintText: 'Inserisci la via...',
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
                        hintText: 'Inserisci la provincia...',
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
                      key: const Key('numTelefono'),
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
                        key: const Key('inserisciSupportoButton'),
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
