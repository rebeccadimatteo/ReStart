import "package:flutter/material.dart";
import "signup.dart";
/// Costruttore Stateless per la build del widget di login
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (const Login());
  }
}

/// StatefulWidget per il login, con la creazione di uno stato
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

/// Classe con tutti i widget presenti nella schermata di login
class _LoginDemoState extends State<Login> {
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
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
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
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
