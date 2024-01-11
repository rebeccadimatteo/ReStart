import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_session_manager/flutter_session_manager.dart";
import "../../../utils/jwt_utils.dart";
import "../routes/routes.dart";
import "package:http/http.dart" as http;

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _viewPassword;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

  bool validateUsername(String username) {
    return username.length <= 15 && username.length >= 3;
  }

  bool validatePsw(String password) {
    return password.length <= 15 && password.length >= 3;
  }

  @override
  void initState() {
    _viewPassword = true;
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      String email = usernameController.text;
      String psw = pswController.text;
      Map<String, String> data = {
        'email': email,
        'password': psw,
      };
      String authJson = jsonEncode(data);
      auth(context, authJson);
    }
  }

  void auth(BuildContext context, String authJson) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/autenticazione/login'),
      body: authJson,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      var token = responseBody['token'];
      await SessionManager().set("token", token);
      if (JWTUtils.getUserTypeFromToken(accessToken: token) == "Utente") {
        Navigator.pushNamed(
          context,
          AppRoutes.homeUtente,
        );
      } else if (JWTUtils.getUserTypeFromToken(accessToken: token) == "ADS") {
        Navigator.pushNamed(
          context,
          AppRoutes.homeADS,
        );
      } else if (JWTUtils.getUserTypeFromToken(accessToken: token) == "CA") {
        Navigator.pushNamed(
          context,
          AppRoutes.homeCA,
        );
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Username o password errati',
            style: TextStyle(
              color: Colors.white, // Colore del testo
              fontSize: 16, // Dimensione del testo
            ),
          ),
          backgroundColor: Colors.red, // Colore di sfondo della snackbar
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: SizedBox(
                    width: 500,
                    height: 320,
                    child: Image.asset('images/restartLogo.png')),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: const Text(
                'RICOMINCIAMO INSIEME',
                style: TextStyle(
                  fontFamily: 'CCE',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      top: 15,
                      bottom: _isUsernameValid ? 15 : 20),
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
                          labelStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Inserisci il tuo username...',
                          errorText: _isUsernameValid
                              ? null
                              : 'Formato username non valido \n(ex: mariorossi1 [max 15 caratteri]',
                          errorStyle: const TextStyle(color: Colors.red)
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
                      controller: pswController,
                      onChanged: (value) {
                        setState(() {
                          _isPasswordValid = validatePsw(value);
                        });
                      },
                      obscureText: _viewPassword,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blueGrey,
                          ),
                          onPressed: () {
                            setState(() {
                              _viewPassword = !_viewPassword;
                            });
                          },
                        ),
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
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 5),
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
                  submitForm();
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
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.login,
                );
              },
              child: const Text(
                'Password dimenticata?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Non hai un account?',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
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
                    AppRoutes.signup,
                  );
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
          ],
        ),
      ),
    );
  }
}
