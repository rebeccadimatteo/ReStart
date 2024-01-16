import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
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
        'Adobe Creative Suite':
            _selectedSkills.contains('Adobe Creative Suite') ? 1 : 0,
        'Back-end Development':
            _selectedSkills.contains('Back-end Development') ? 1 : 0,
        'Budget Management':
            _selectedSkills.contains('Budget Management') ? 1 : 0,
        'Business Analysis':
            _selectedSkills.contains('Business Analysis') ? 1 : 0,
        'CRM Software': _selectedSkills.contains('CRM Software') ? 1 : 0,
        'Client Relations':
            _selectedSkills.contains('Client Relations') ? 1 : 0,
        'Communication': _selectedSkills.contains('Communication') ? 1 : 0,
        'Communication Skills':
            _selectedSkills.contains('Communication Skills') ? 1 : 0,
        'Content Creation':
            _selectedSkills.contains('Content Creation') ? 1 : 0,
        'Copywriting': _selectedSkills.contains('Copywriting') ? 1 : 0,
        'Customer Service':
            _selectedSkills.contains('Customer Service') ? 1 : 0,
        'Customer Support':
            _selectedSkills.contains('Customer Support') ? 1 : 0,
        'Data Analysis': _selectedSkills.contains('Data Analysis') ? 1 : 0
      };
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
      body: json.encode({'id': utente.id, 'form': formData}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('result')) {
        final String lavoroAdatto = responseBody['result'];
        print(lavoroAdatto);
      } else {
        print('Errore');
      }
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
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                items:
                    ['Nessuna', 'Licenza Media', 'Diploma Superiore', 'Laurea']
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
                    color: Colors.black,
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text(
                  'Sei mai stato a capo di un lavoro?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                value: _hasBeenLeader,
                onChanged: (bool value) {
                  setState(() {
                    _hasBeenLeader = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildCheckboxListTile(
                'Adobe Creative Suite',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Back-end Development',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Budget Management',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Business Analysis',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'CRM Software',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Client Relations',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Communication',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Communication Skills',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Content Creation',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Copywriting',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Customer Service',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Customer Support',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              _buildCheckboxListTile(
                'Data Analysis',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.visualizzaLavoroAdatto,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxListTile(String skill, {TextStyle? style}) {
    return CheckboxListTile(
      title: Text(
        skill,
        style: style,
      ),
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
