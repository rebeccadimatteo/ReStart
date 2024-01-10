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
    } else {
      if (usernameController.text.length >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lunghezza username errata')),
        );
      } else if (pswController.text.length >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lunghezza password errata')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
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
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Username',
                          hintText: 'Inserisci il tuo username...'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: TextFormField(
                      obscureText: _viewPassword,
                      controller: pswController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Password',
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
                          )),
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
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.login,
                );
              },
              child: const Text(
                'Password dimenticata?',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Non hai un account?',
              style: TextStyle(fontSize: 18),
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
      ),
    ));
  }
}
