import "package:flutter/material.dart";
import "login.dart";
/// Costruttore Stateless per la build del widget di signup
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

/// StatefulWidget per il login, con la creazione di uno stato
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

/// Classe con tutti i widget presenti nella schermata di signup
class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

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
                    child: Center(
                      child: SizedBox(
                          width: 300,
                          height: 200,
                          child: Image.asset('images/restartLogo.png')),
                    ),
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
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Nome',
                          hintText: 'Inserisci il tuo nome...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Cognome',
                          hintText: 'Inserisci il tuo cognome...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Data di nascita',
                          hintText: 'Inserisci la tua data di nascita...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Luogo di nascita',
                          hintText: 'Inserisci il tuo luogo di nascita...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Email',
                          hintText: 'Inserisci la tua email...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Password',
                          hintText: 'Inserisci la tua password...'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          labelText: 'Codice fiscale',
                          hintText: 'Inserisci il tuo codice fiscale...'),
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
                            MaterialPageRoute(builder: (context) => const LoginPage()));
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
