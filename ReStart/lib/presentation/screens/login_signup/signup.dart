import "package:flutter/material.dart";
import "package:restart_all_in_one/presentation/screens/login_signup/login.dart";

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

// Aggiungi un controller per il campo del codice fiscale
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

// Aggiungi una variabile booleana per tenere traccia dello stato di validità del codice fiscale
  bool _isCodiceFiscaleValid = true;
  bool _isUsernameValid = true;
  bool _isEmailValid = true;
  bool _isViaValid = true;
  bool _isCittaValid = true;
  bool _isProvinciaValid = true;
  bool _isTelefonoValid = true;
  //bool _isImmagineValid = true;
  bool _isNomeValid = true;
  bool _isCognomeValid = true;
  bool _isLuogoNascitaValid = true;
  bool _isPasswordValid = true;

// Aggiungi un metodo per la validazione del codice fiscale
  bool validateCodiceFiscale(String codiceFiscale) {
    RegExp regex = RegExp(r'^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');
    return regex.hasMatch(codiceFiscale);
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(r'^[A-z0-9, %+-]+@[A-z0-9,-]+\.[A-z]{6,40}$');
    return regex.hasMatch(email);
  }

  bool validateUsername(String username) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9_.@]{3,15}$');
    return regex.hasMatch(username);
  }

  bool validateVia(String via) {
    RegExp regex = RegExp(r'^[0-9A-z À-ù‘-]{2,30}$');
    return regex.hasMatch(via);
  }

  bool validateCitta(String citta) {
    RegExp regex = RegExp(r'^[A-z À-ù‘-]{2,50}$');
    return regex.hasMatch(citta);
  }

  bool validateProvincia(String provincia) {
    RegExp regex = RegExp(r'^[A-Z]{2}');
    return regex.hasMatch(provincia);
  }

  bool validateTelefono(String telefono) {
    RegExp regex = RegExp(r'^\+?\d{10,13}$');
    return regex.hasMatch(telefono);
  }

  bool validateImmagine(String immagine) {
    RegExp regex = RegExp(r'^.+\.jpe?g$');
    return regex.hasMatch(immagine);
  }

  bool validateNome(String nome) {
    RegExp regex = RegExp(r'^[A-z À-ù ‘-]{2,20}$');
    return regex.hasMatch(nome);
  }

  bool validateCognome(String cognome) {
    RegExp regex = RegExp(r'^[A-z À-ù ‘-]{2,20}$');
    return regex.hasMatch(cognome);
  }

  bool validatePassword(String password) {
    return password.length <= 15 && password.length >= 3;
  }

  bool validateLuogoNascita(String password) {
    return password.length <= 20 && password.length >= 3;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
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
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  'Inserisci i tuoi dati',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Dati anagrafici',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: nomeController,
                  onChanged: (value) {
                    setState(() {
                      _isNomeValid = validateNome(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Nome',
                    hintText: 'Inserisci il tuo nome...',
                    // Cambia il colore del testo in rosso se il nome non è valido
                    errorText:
                        _isNomeValid ? null : 'Formato nome non corretto (ex. Mirko [max. 20 caratteri])',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: cognomeController,
                  onChanged: (value) {
                    setState(() {
                      _isCognomeValid = validateCognome(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Cognome',
                    hintText: 'Inserisci il tuo cognome...',
                    // Cambia il colore del testo in rosso se il nome non è valido
                    errorText:
                        _isCognomeValid ? null : 'Formato cognome non corretto (ex: Rossi [max 20 caratteri])',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      labelText: 'Data di nascita',
                      hintText: 'Inserisci la tua data di nascita...'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: luogoNascitaController,
                  onChanged: (value) {
                    setState(() {
                      _isLuogoNascitaValid = validateLuogoNascita(value);
                    });
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
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: codiceFiscaleController,
                  onChanged: (value) {
                    setState(() {
                      _isCodiceFiscaleValid = validateCodiceFiscale(value);
                    });
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
                        : 'Codice Fiscale non corretto (ex: AAABBB11C22D333E)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 25),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Genere',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Indirizzo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                // CITTA
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: cittaController,
                  onChanged: (value) {
                    setState(() {
                      _isCittaValid = validateCitta(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Citta',
                    hintText: 'Inserisci la tua Città...',
                    // Cambia il colore del testo in rosso se città non è valida
                    errorText: _isCittaValid
                        ? null
                        : 'Formato città non corretto (ex: Napoli)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                // VIA
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: viaController,
                  onChanged: (value) {
                    setState(() {
                      _isViaValid = validateVia(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Via',
                    hintText: 'Inserisci la tua via...',
                    // Cambia il colore del testo in rosso se via non è valida
                    errorText: _isViaValid
                        ? null
                        : 'Formato via non corretto (ex: Via Fratelli Napoli, 1)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                // PROVINCIA
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: provinciaController,
                  onChanged: (value) {
                    setState(() {
                      _isProvinciaValid = validateProvincia(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Provincia',
                    hintText: 'Inserisci la tua provincia...',
                    // Cambia il colore del testo in rosso se provincia non è valida
                    errorText: _isProvinciaValid
                        ? null
                        : 'Formato provincia non corretta (ex: AV)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Contatti',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      _isEmailValid = validateEmail(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Email',
                    hintText: 'Inserisci la tua email...',
                    // Cambia il colore del testo in rosso se email non è valida
                    errorText: _isEmailValid
                        ? null
                        : 'Formato email non corretta (ex: esempio@esempio.com)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: telefonoController,
                  onChanged: (value) {
                    setState(() {
                      _isTelefonoValid = validateTelefono(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Numero di telefono',
                    hintText: 'Inserisci il tuo numero di telefono...',
                    // Cambia il colore del testo in rosso se telefono non è valido
                    errorText: _isTelefonoValid
                        ? null
                        : 'Formato numero di telefono non corretto (ex: +393330000000)',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Credenziali',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: usernameController,
                  onChanged: (value) {
                    setState(() {
                      _isUsernameValid = validateUsername(value);
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Username',
                    hintText: 'Inserisci il tuo username...',
                    // Cambia il colore del testo in rosso se username non è valido
                    errorText: _isUsernameValid
                        ? null
                        : 'Formato username non corretto (ex: prova123. [caratteri speciali consentiti: _ . @])',
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: TextFormField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      _isPasswordValid = validatePassword(value);
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Password',
                    hintText: 'Inserisci la tua password...',
                    // Cambia il colore del testo in rosso se password non è valida
                    errorText: _isPasswordValid
                        ? null
                        : 'Formato password non corretto',
                    errorStyle: const TextStyle(color: Colors.red),
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                  child: const Text(
                    'REGISTRATI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
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
                  style: TextStyle(fontSize: 18),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    'ACCEDI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
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
        )),
      ),
    );
  }
}

void main() {
  runApp(const SignUp());
}
