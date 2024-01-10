import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../../utils/utils.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';
import 'package:http/http.dart' as http;

class Profilo extends StatefulWidget {
  @override
  State<Profilo> createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  late UtenteDTO? utente;
  var token = SessionManager().get('token');

  @override
  void initState() {
    super.initState();
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
    fetchProfiloFromServer();
  }

  Future<void> fetchProfiloFromServer() async {
    String user = JWTUtils.getUserIdFromToken(accessToken: await token);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/visualizzaUtente'),
      body: jsonEncode(user),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.1;
    double buttonHeight = screenWidth * 0.1;
    final String data = utente!.data_nascita.toIso8601String();
    final String dataBuona = data.substring(0,10);

    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (utente != null)
                ListTile(
                  leading: CircleAvatar(
                    radius: screenWidth * 0.1,
                    backgroundImage: AssetImage(utente!.immagine),
                  ),
                  title: Text(
                    utente!.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: screenWidth * 0.1),
              Column(
                children: [
                  buildProfileField('Email', utente!.email, screenWidth),
                  buildProfileField('Nome', utente!.nome, screenWidth),
                  buildProfileField('Cognome', utente!.cognome, screenWidth),
                  buildProfileField(
                      'Codice fiscale', utente!.cod_fiscale, screenWidth),
                  buildProfileField('Data di nascita', dataBuona, screenWidth),
                  buildProfileField('Luogo di nascita',
                      utente!.luogo_nascita as String, screenWidth),
                  buildProfileField('Genere', utente!.genere, screenWidth),
                  buildProfileField('Username', utente!.username, screenWidth),
                  buildProfileField('Password', '*********', screenWidth),
                  buildProfileField('Lavoro adatto',
                      utente!.lavoro_adatto as String, screenWidth),
                  buildProfileField('Città', utente!.citta, screenWidth),
                  buildProfileField('Via', utente!.via, screenWidth),
                  buildProfileField('Provicia', utente!.provincia, screenWidth),
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
                  backgroundColor: Colors.blue[200],
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  elevation: 10,
                  minimumSize: Size(buttonWidth, buttonHeight),
                ),
                child: const Text(
                  'MODIFICA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
  ProfiloEdit({super.key});

  @override
  State<ProfiloEdit> createState() => _ProfiloEditState();
}

class _ProfiloEditState extends State<ProfiloEdit> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    _image = img;
  }

  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? _selectedGender = 'Maschio';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cognomeController = TextEditingController();
  final TextEditingController dataNascitaController = TextEditingController();
  final TextEditingController luogoNascitaController = TextEditingController();
  final TextEditingController genereController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lavoroAdattoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController cfController = TextEditingController();
  final TextEditingController numTelefonoController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController cittaController = TextEditingController();
  final TextEditingController provinciaController = TextEditingController();

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
        dataNascitaController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void submitForm() async {
    final UtenteDTO u = ModalRoute.of(context)?.settings.arguments as UtenteDTO;

    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String nome = nomeController.text;
      String cognome = cognomeController.text;
      String luogoNascita = luogoNascitaController.text;
      String lavoroAdatto = lavoroAdattoController.text;
      String password = passwordController.text;
      String username = usernameController.text;
      String cf = cfController.text;
      String numTelefono = numTelefonoController.text;
      String via = viaController.text;
      String citta = cittaController.text;
      String provincia = provinciaController.text;

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
        immagine: 'images/avatar.png',
        via: via,
        citta: citta,
        provincia: provincia,
      );

      sendEditProfiloToServer(utenteEdit);
    }
  }

  Future<void> sendEditProfiloToServer(UtenteDTO utenteEdit) async {
    print("mando al server");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/modifyUtente'),
      body: jsonEncode(utenteEdit),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        print("Funziona");
      }
    }
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
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          child: CircleAvatar(
                            backgroundImage: _image != null
                                ? MemoryImage(_image!)
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
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                    TextFormField(
                      controller: cognomeController,
                      decoration: const InputDecoration(
                        labelText: 'Cognome',
                      ),
                    ),
                    TextFormField(
                      controller: cfController,
                      decoration: const InputDecoration(
                        labelText: 'Codice fiscale',
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: TextFormField(
                            readOnly: true,
                            controller: dataNascitaController,
                            decoration: const InputDecoration(
                              labelText: 'Data di nascita',
                            ),
                            onTap: () {
                              _selectDate(context);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Seleziona la data di nascita';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ]),
                    TextFormField(
                      controller: luogoNascitaController,
                      decoration: const InputDecoration(
                        labelText: 'Luogo di nascita',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15),
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
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Genere',
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    TextFormField(
                      controller: cittaController,
                      decoration: const InputDecoration(
                        labelText: 'Città',
                      ),
                    ),
                    TextFormField(
                      controller: viaController,
                      decoration: const InputDecoration(
                        labelText: 'Via',
                      ),
                    ),
                    TextFormField(
                      controller: provinciaController,
                      decoration: const InputDecoration(
                        labelText: 'Provincia',
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.grey,
                  elevation: 10,
                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                ),
                child: const Text(
                  'APPLICA MODIFICHE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
