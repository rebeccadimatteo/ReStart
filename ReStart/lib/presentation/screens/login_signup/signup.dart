import 'dart:convert';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../model/entity/utente_DTO.dart';
import '../routes/routes.dart';
import 'dart:io';

/// Rappresenta la schermata di registrazione dell'applicazione.
class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

/// Gestisce la logica e l'interazione dell'interfaccia utente per la registrazione.
class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender = 'Non specificato';
  DateTime? selectedDate;
  XFile? _image;

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per selezionare la data di nascita.
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime eighteenYearsAgo = now.subtract(const Duration(days: 365 * 18));

    DateTime initialDate = DateTime(2006, 01, 01);
    DateTime lastDate = now.isAfter(eighteenYearsAgo) ? eighteenYearsAgo : now;
    DateTime firstAllowedDate = DateTime(now.year - 18, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940, 12, 31),
      lastDate: lastDate,
      selectableDayPredicate: (DateTime day) {
        return day.isBefore(firstAllowedDate);
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dataNascitaController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  final TextEditingController codiceFiscaleController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController cognomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController luogoNascitaController = TextEditingController();
  final TextEditingController dataNascitaController = TextEditingController();

  bool _isCodiceFiscaleValid = true;
  bool _isUsernameValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  bool _isTelefonoValid = true;
  bool _isNomeValid = true;
  bool _isCognomeValid = true;
  bool _isLuogoNascitaValid = true;
  bool _isPasswordValid = true;

  /// Espressioni regolari
  bool validateCodiceFiscale(String codiceFiscale) {
    RegExp regex = RegExp(r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');
    return regex.hasMatch(codiceFiscale);
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(r'^[A-Za-z0-9_.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    if (email.length < 6 || email.length > 40) {
      return false;
    }
    return regex.hasMatch(email);
  }

  bool validateUsername(String username) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.@]{3,15}$');
    return regex.hasMatch(username);
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

  bool validateNome(String nome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
    return regex.hasMatch(nome);
  }

  bool validateCognome(String cognome) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,20}$');
    return regex.hasMatch(cognome);
  }

  bool validatePassword(String password) {
    return password.length <= 15 && password.length >= 3;
  }

  bool validateLuogoNascita(String luogo) {
    return luogo.length <= 20 && luogo.length >= 3;
  }

  /// Metodo per inviare il form di registrazione al metodo [sendDataToServer].
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String nome = nomeController.text;
      String cognome = cognomeController.text;
      String luogoNascita = luogoNascitaController.text;
      String password = passwordController.text;
      String username = usernameController.text;
      String cf = codiceFiscaleController.text;
      String numTelefono = telefonoController.text;
      String via = viaController.text;
      String citta = cittaController.text;
      String provincia = provinciaController.text;
      String imagePath = 'images/utente6.jpg';

      UtenteDTO utente = UtenteDTO(
        email: email,
        nome: nome,
        cognome: cognome,
        data_nascita: selectedDate!,
        luogo_nascita: luogoNascita,
        genere: _selectedGender as String,
        lavoro_adatto: '',
        username: username,
        password: password,
        cod_fiscale: cf,
        num_telefono: numTelefono,
        immagine: imagePath,
        via: via,
        citta: citta,
        provincia: provincia,
      );

      sendDataToServer(utente);
    }
  }

  /// Metodo per inviare i dati di registrazione al server.
  Future<void> sendDataToServer(UtenteDTO utente) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/registrazione/signup'),
      body: jsonEncode(utente),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      final imageUrl = Uri.parse('http://10.0.2.2:8080/registrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);
      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));
      imageRequest.fields['nome'] = utente.username;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        Navigator.pushNamed(context, AppRoutes.login);
        print("Immagine caricata con successo.");
      } else {
        print(
            "Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    } else if (response.statusCode == 200) {
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  /// Costruisce l'interfaccia utente per la schermata di registrazione.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.4;
    return Scaffold(
      body: SingleChildScrollView(
        key: const Key('signUpPage'),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Image.asset('images/restartLogo.png')),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'RICOMINCIAMO INSIEME',
                  style: TextStyle(
                    fontFamily: 'CCE',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  'Inserisci i tuoi dati',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarSize / 3,
                      backgroundImage: _image != null
                          ? MemoryImage(
                              File(_image!.path).readAsBytesSync(),
                            )
                          : Image.asset('images/avatar.png').image,
                    ),
                    Positioned(
                      bottom: screenWidth * 0.03,
                      left: screenWidth * 0.22,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo_sharp),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Dati anagrafici',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 15,
                    bottom: _isNomeValid ? 15 : 20),
                child: TextFormField(
                  key: const Key('nomeField'),
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Nome',
                    hintText: 'Inserisci il tuo nome...',
                    // Cambia il colore del testo in rosso se il nome non è valido
                    errorText: _isNomeValid
                        ? null
                        : 'Formato nome non corretto (ex. Mirko [max. 20 caratteri])',
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
                  key: const Key('cognomeField'),
                  controller: cognomeController,
                  onChanged: (value) {
                    setState(() {
                      _isCognomeValid = validateCognome(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un cognome';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Cognome',
                    hintText: 'Inserisci il tuo cognome...',
                    // Cambia il colore del testo in rosso se il nome non è valido
                    errorText: _isCognomeValid
                        ? null
                        : 'Formato cognome non corretto (ex: Rossi [max 20 caratteri])',
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFormField(
                          key: const Key('dataNascitaField'),
                          readOnly: true,
                          controller: dataNascitaController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            labelText: 'Data di nascita',
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'Inserisci la tua data di nascita...',
                            suffixIcon: Icon(Icons.date_range),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci una data di nascita';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 15,
                    bottom: _isLuogoNascitaValid ? 15 : 20),
                child: TextFormField(
                  key: const Key('luogoNascitaField'),
                  controller: luogoNascitaController,
                  onChanged: (value) {
                    setState(() {
                      _isLuogoNascitaValid = validateLuogoNascita(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un luogo di nascita';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Luogo di Nascita',
                    hintText: 'Inserisci il luogo di nascita...',
                    // Cambia il colore del testo in rosso se luogo nascita non è valido
                    errorText: _isLuogoNascitaValid
                        ? null
                        : 'Formato luogo nascita non corretto (ex: Napoli)',
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
                    bottom: _isCodiceFiscaleValid ? 15 : 20),
                child: TextFormField(
                  key: const Key('cfField'),
                  controller: codiceFiscaleController,
                  onChanged: (value) {
                    setState(() {
                      _isCodiceFiscaleValid = validateCodiceFiscale(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un codice fiscale';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Codice fiscale',
                    hintText: 'Inserisci il tuo codice fiscale...',
                    // Cambia il colore del testo in rosso se il codice fiscale non è valido
                    errorText: _isCodiceFiscaleValid
                        ? null
                        : 'Formato Codice Fiscale non corretto\n  (ex: AAABBB11C22D333E)',
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
                    bottom: _isCodiceFiscaleValid ? 15 : 20),
                child: DropdownButtonFormField<String>(
                  key: const Key('genereField'),
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un genere';
                    }
                    return null;
                  },
                  items: ['Maschio', 'Femmina', 'Non specificato']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          key: Key(value),
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Genere',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Indirizzo',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Citta',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci la tua Città...',
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Via',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci la tua via...',
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Provincia',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci la tua provincia...',
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Contatti',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci la tua email...',
                    // Cambia il colore del testo in rosso se email non è valida
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
                  key: const Key('telefonoField'),
                  controller: telefonoController,
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
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Numero di telefono',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci il tuo numero di telefono...',
                    // Cambia il colore del testo in rosso se telefono non è valido
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Credenziali',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 15,
                    bottom: _isUsernameValid ? 15 : 20),
                child: TextFormField(
                  key: const Key('usernameField'),
                  controller: usernameController,
                  onChanged: (value) {
                    setState(() {
                      _isUsernameValid = validateUsername(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci il tuo username...',
                    // Cambia il colore del testo in rosso se username non è valido
                    errorText: _isUsernameValid
                        ? null
                        : 'Formato username non corretto (ex: prova123. \n  [caratteri speciali consentiti: _ . @])',
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
                    bottom: _isPasswordValid ? 15 : 20),
                child: TextFormField(
                  key: const Key('passwordField'),
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      _isPasswordValid = validatePassword(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci una password';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Inserisci la tua password...',
                    // Cambia il colore del testo in rosso se password non è valida
                    errorText: _isPasswordValid
                        ? null
                        : 'Formato password non corretto',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                    )),
                child: TextButton(
                  key: const Key('signUpButton'),
                  onPressed: () {
                    submitForm();
                  },
                  child: const Text(
                    'REGISTRATI',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Hai già un account?',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30, top: 12),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ],
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                    )),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.login,
                    );
                  },
                  child: const Text(
                    'ACCEDI',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
