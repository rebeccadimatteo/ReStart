import 'package:flutter/material.dart';
import 'package:restart_all_in_one/presentation/components/generic_app_bar.dart';

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

  final TextEditingController _yearsOfExperienceController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        labelText: 'Years of Experience',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Sei mai stato a capo di un lavoro?'),
                      value: _hasBeenLeader,
                      onChanged: (bool value) {
                        setState(() {
                          _hasBeenLeader = value;
                        });
                      },
                    ),
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
