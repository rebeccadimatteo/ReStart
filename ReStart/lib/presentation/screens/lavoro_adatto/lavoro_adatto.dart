import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import 'package:http/http.dart' as http;

import '../routes/routes.dart';

class LavoroAdatto extends StatefulWidget {
  @override
  State<LavoroAdatto> createState() => _LavoroAdattoState();
}

class _LavoroAdattoState extends State<LavoroAdatto> {
  String? _selectedEducationLevel;
  int? _yearsOfExperience;
  bool _hasBeenLeader = false;
  List<String> _selectedSkills = [];
  final _formKey = GlobalKey<FormState>();
  var token = SessionManager().get('token');
  late UtenteDTO utente;

  final TextEditingController _yearsOfExperienceController =
      TextEditingController();

  //final TextEditingController selectedEducationaLevel = TextEditingController();
  late int educazione;

  /// Metodo per inviare il form al server.
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      int gender = utente.genere == 'Maschio' ? 1 : 0;
      DateTime dataNascita = utente.data_nascita;
      DateTime now = DateTime.now();
      Duration difference = now.difference(dataNascita);

      int eta = difference.inDays ~/ 365;

      Map<String, dynamic> formData = {
        'Gender Booleano': gender,
        'Age': eta,
        'Education Level': educazione,
        'Years Of Experience': _yearsOfExperience,
        'Senior': _hasBeenLeader,
        'selectedSkills': _selectedSkills,
      };
      print(formData);
      sendDataToServer(formData);
    } else {
      print("Evento non inserito");
    }
  }

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

  Future<void> sendDataToServer(Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/lavoroAdatto/findLavoroAdatto'),
      body: jsonEncode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Form mandato con successo');
    } else {
      print('Errore');
    }
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

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    fetchProfiloFromServer();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: GenericAppBar(showBackButton: true),
        endDrawer: GenericAppBar.buildDrawer(context),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedEducationLevel,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedEducationLevel = newValue;
                          switch (_selectedEducationLevel) {
                            case 'Nessuna':
                              educazione = 0;
                            case 'Licenza Media':
                              educazione = 1;
                            case 'Diploma Superiore':
                              educazione = 2;
                            case 'Laurea':
                              educazione = 3;
                            default:
                              educazione = 1;
                          }
                        });
                      },
                      items: [
                        'Nessuna',
                        'Licenza Media',
                        'Diploma Superiore',
                        'Laurea'
                      ]
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Grado di Istruzione',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _yearsOfExperienceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _yearsOfExperience = int.tryParse(value);
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        labelText: 'Anni di Esperienza',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text('Sei mai stato a capo di un lavoro?'),
                      value: _hasBeenLeader,
                      onChanged: (bool value) {
                        setState(() {
                          _hasBeenLeader = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildCheckboxListTile('Adobe Creative Suite'),
                    _buildCheckboxListTile('Back-end Development'),
                    _buildCheckboxListTile('Budget Management'),
                    _buildCheckboxListTile('Business Analysis'),
                    _buildCheckboxListTile('CRM Software'),
                    _buildCheckboxListTile('Client Relations'),
                    _buildCheckboxListTile('Communication'),
                    _buildCheckboxListTile('Communication Skills'),
                    _buildCheckboxListTile('Content Creation'),
                    _buildCheckboxListTile('Copywriting'),
                    _buildCheckboxListTile('Customer Service'),
                    _buildCheckboxListTile('Customer Support'),
                    _buildCheckboxListTile('Data Analysis'),
                    SizedBox(height: screenWidth * 0.1),
                    ElevatedButton(
                      onPressed: () {
                        submitForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        foregroundColor: Colors.black,
                        shadowColor: Colors.grey,
                        elevation: 10,
                        minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                      ),
                      child: const Text(
                        'INSERISCI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ))));
  }

  Widget _buildCheckboxListTile(String skill) {
    return CheckboxListTile(
      title: Text(skill),
      value: _selectedSkills.contains(skill),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedSkills.add(skill);
          } else {
            _selectedSkills.remove(skill);
          }
        });
      },
    );
  }
}

void main() {
  runApp(MaterialApp(home: LavoroAdatto()));
}
