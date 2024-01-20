import 'dart:convert';
import 'dart:io';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';
import 'package:http/http.dart' as http;

class Profilo extends StatefulWidget {
  @override
  State<Profilo> createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  late UtenteDTO? utente;
  late DateTime? selectedDate;
  var token = SessionManager().get('token');
  TextEditingController dataNascitaController = TextEditingController();

  void _checkUserAndNavigate() async {
    String token = await SessionManager().get('token');
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/autenticazione/checkUserUtente'),
        body: jsonEncode(token),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    utente = UtenteDTO(
        nome: 'nome',
        cognome: 'cognome',
        cod_fiscale: 'cod_fiscale',
        data_nascita: DateTime.now(),
        luogo_nascita: 'luogo_nascita',
        genere: 'genere',
        username: 'username',
        password: 'password',
        email: 'email',
        num_telefono: 'num_telefono',
        immagine: 'images/avatar.png',
        via: 'via',
        citta: 'citta',
        provincia: 'provincia',
        lavoro_adatto: 'lavoro_adatto');
    _checkUserAndNavigate();
    fetchProfiloFromServer();
  }

  Future<void> fetchProfiloFromServer() async {
    String user = JWTUtils.getUserFromToken(accessToken: await token);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/visualizzaUtente'),
      body: jsonEncode({'user': user}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        final UtenteDTO data = UtenteDTO.fromJson(responseBody['result']);
        setState(() {
          utente = data;
        });
      } else {
        print('Chiave "utente" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Widget buildProfileField(String label, String value, TextStyle labelStyle,
      TextStyle valueStyle, double screenWidth) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: labelStyle,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final String data = utente!.data_nascita.toIso8601String();
    final String dataBuona = data.substring(0, 10);
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.1, horizontal: screenWidth * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (utente != null)
                ListTile(
                  leading: CircleAvatar(
                    radius: screenWidth * 0.10,
                    backgroundImage: AssetImage(utente!.immagine),
                  ),
                  title: Text(
                    utente!.username,
                    style: const TextStyle(
                        fontFamily: 'PoppinsMedium', fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: screenWidth * 0.1),
              Column(
                children: [
                  buildProfileField(
                      'Email',
                      utente!.email,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Nome',
                      utente!.nome,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Cognome',
                      utente!.cognome,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Codice fiscale',
                      utente!.cod_fiscale,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Data di nascita',
                      dataBuona,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Luogo di nascita',
                      utente!.luogo_nascita,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Genere',
                      utente!.genere,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Username',
                      utente!.username,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Password',
                      '*********',
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Lavoro adatto',
                      utente!.lavoro_adatto as String,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Città',
                      utente!.citta,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Via',
                      utente!.via,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Provicia',
                      utente!.provincia,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                  buildProfileField(
                      'Numero di telefono',
                      utente!.num_telefono,
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      const TextStyle(
                        fontFamily: 'Poppins',
                      ),
                      screenWidth),
                ],
              ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.modificaprofilo,
                    arguments: utente,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  elevation: 10,
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
                        'MODIFICA',
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
      ),
    );
  }
}

class ProfiloEdit extends StatefulWidget {
  const ProfiloEdit({super.key});

  @override
  State<ProfiloEdit> createState() => _ProfiloEditState();
}

class _ProfiloEditState extends State<ProfiloEdit> {
  final _formKey = GlobalKey<FormState>();
  late bool _viewPassword;
  DateTime? selectedDate;
  String? _selectedGender;
  XFile? _image;
  late UtenteDTO utente;

  late TextEditingController? emailController;
  late TextEditingController? nomeController;
  late TextEditingController? cognomeController;
  late TextEditingController? luogoNascitaController;
  late TextEditingController? genereController;
  late TextEditingController? passwordController;
  late TextEditingController? lavoroAdattoController;
  late TextEditingController? usernameController;
  late TextEditingController? cfController;
  late TextEditingController? numTelefonoController;
  late TextEditingController? viaController;
  late TextEditingController? cittaController;
  late TextEditingController? provinciaController;
  TextEditingController dataNascitaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = null;
    nomeController = null;
    cognomeController = null;
    luogoNascitaController = null;
    genereController = null;
    passwordController = null;
    lavoroAdattoController = null;
    usernameController = null;
    cfController = null;
    numTelefonoController = null;
    viaController = null;
    cittaController = null;
    provinciaController = null;
    _viewPassword = true;
    _checkUserAndNavigate();
  }

  @override
  void dispose() {
    nomeController?.dispose();
    cognomeController?.dispose();
    emailController?.dispose();
    cittaController?.dispose();
    viaController?.dispose();
    provinciaController?.dispose();
    luogoNascitaController?.dispose();
    genereController?.dispose();
    usernameController?.dispose();
    passwordController?.dispose();
    cfController?.dispose();
    lavoroAdattoController?.dispose();
    numTelefonoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    utente = ModalRoute.of(context)?.settings.arguments as UtenteDTO;
    if (nomeController == null) {
      _selectedGender = utente.genere;
      selectedDate = utente.data_nascita;
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String data = formatter.format(utente.data_nascita);
      dataNascitaController = TextEditingController(text: data);
      nomeController = TextEditingController(text: utente.nome);
      cognomeController = TextEditingController(text: utente.cognome);
      cittaController = TextEditingController(text: utente.citta);
      viaController = TextEditingController(text: utente.via);
      provinciaController = TextEditingController(text: utente.provincia);
      emailController = TextEditingController(text: utente.email);
      usernameController = TextEditingController(text: utente.username);
      passwordController = TextEditingController(text: utente.password);
      luogoNascitaController =
          TextEditingController(text: utente.luogo_nascita);
      cfController = TextEditingController(text: utente.cod_fiscale);
      numTelefonoController = TextEditingController(text: utente.num_telefono);
      lavoroAdattoController =
          TextEditingController(text: utente.lavoro_adatto);
      genereController = TextEditingController(text: utente.genere);
    }
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserUtente();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940, 12, 31),
      lastDate: DateTime(2070, 12, 31),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dataNascitaController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void submitForm() async {
    final UtenteDTO u = ModalRoute.of(context)?.settings.arguments as UtenteDTO;

    if (_formKey.currentState!.validate()) {
      String email = emailController!.text;
      String nome = nomeController!.text;
      String cognome = cognomeController!.text;
      String luogoNascita = luogoNascitaController!.text;
      String lavoroAdatto = lavoroAdattoController!.text;
      String password = passwordController!.text;
      String username = usernameController!.text;
      String cf = cfController!.text;
      String numTelefono = numTelefonoController!.text;
      String via = viaController!.text;
      String citta = cittaController!.text;
      String provincia = provinciaController!.text;
      String imagePath = 'images/image_$username.jpg';

      UtenteDTO utenteEdit = UtenteDTO(
        id: u.id,
        email: email,
        nome: nome,
        cognome: cognome,
        data_nascita: selectedDate!,
        luogo_nascita: luogoNascita,
        genere: _selectedGender as String,
        lavoro_adatto: lavoroAdatto,
        username: username,
        password: password,
        cod_fiscale: cf,
        num_telefono: numTelefono,
        immagine: imagePath,
        via: via,
        citta: citta,
        provincia: provincia,
      );

      sendEditProfiloToServer(utenteEdit);
    }
  }

  Future<void> sendEditProfiloToServer(UtenteDTO utenteEdit) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/modifyUtente'),
      body: jsonEncode(utenteEdit),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 && _image != null) {
      final imageUrl =
          Uri.parse('http://10.0.2.2:8080/autenticazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));
      //aggiungi nome utente
      imageRequest.fields['username'] = utenteEdit.username;

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

  bool _isCodiceFiscaleValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  bool _isTelefonoValid = true;
  bool _isNomeValid = true;
  bool _isCognomeValid = true;
  bool _isLuogoNascitaValid = true;
  bool _isPasswordValid = true;

  bool validateCodiceFiscale(String codiceFiscale) {
    RegExp regex = RegExp(r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');
    return regex.hasMatch(codiceFiscale);
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
                    const SizedBox(height: 20),
                    TextFormField(
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
                        errorText: _isEmailValid
                            ? null
                            : 'Formato email non corretta (ex: esempio@esempio.com)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: nomeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci un nome';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorText: _isNomeValid
                            ? null
                            : 'Formato nome non corretto (ex. Mirko [max. 20 caratteri])',
                        errorStyle: const TextStyle(color: Colors.red),
                        labelText: 'Nome',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isNomeValid = validateNome(value);
                        });
                      },
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
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
                        labelText: 'Cognome',
                        errorText: _isCognomeValid
                            ? null
                            : 'Formato cognome non corretto (ex: Rossi [max 20 caratteri])',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: cfController,
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
                        labelText: 'Codice fiscale',
                        errorText: _isCodiceFiscaleValid
                            ? null
                            : 'Formato Codice Fiscale non corretto\n  (ex: AAABBB11C22D333E)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: dataNascitaController,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Data di nascita',
                                  hintText: 'Data di nascita',
                                  border: InputBorder.none,
                                ),
                                onTap: () {
                                  _selectDate(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Data di nascita';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Icon(
                                Icons.date_range,
                                size: 20.0, // Adjust the size as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
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
                        labelText: 'Luogo di nascita',
                        errorText: _isLuogoNascitaValid
                            ? null
                            : 'Formato luogo nascita non corretto (ex: Napoli)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Genere',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue as String;
                            });
                          },
                          items: ['Maschio', 'Femmina', 'Non specificato']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    TextFormField(
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
                      obscureText: _viewPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _isPasswordValid
                            ? null
                            : 'Formato password non corretto',
                        errorStyle: const TextStyle(color: Colors.red),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _viewPassword = !_viewPassword;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
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
                        labelText: 'Città',
                        errorText: _isCittaValid
                            ? null
                            : 'Formato città non corretto (ex: Napoli)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
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
                        errorText: _isViaValid
                            ? null
                            : 'Formato via non corretto (ex: Via Fratelli Napoli, 1)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
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
                        errorText: _isProvinciaValid
                            ? null
                            : 'Formato provincia non corretta (ex: AV)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
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
                        errorText: _isTelefonoValid
                            ? null
                            : 'Formato numero di telefono non corretto (ex: +393330000000)',
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.profilo,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Profilo modificato con successo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor: Colors.lightBlue,
                      duration: Duration(seconds: 3),
                    ),
                  );
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
      ),
    );
  }

  Widget buildProfileField(String label, String value, double screenWidth) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
