import "package:flutter/material.dart";
import "package:flutter_session_manager/flutter_session_manager.dart";
import "../../../utils/jwt_constants.dart";
import "../../../utils/jwt_utils.dart";
import "../routes/routes.dart";

/// Metodo per eseguire l'applicazione
void main() {
  runApp(MaterialApp(
    routes: AppRoutes.getRoutes(),
    theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFE0F7FA)), // Azzurro cielo chiaro
    initialRoute: AppRoutes.home,
  ));
}

/// Rappresenta la schermata iniziale dell'applicazione.
class Home extends StatelessWidget {
  Future<void> checkUser(BuildContext context) async {
    var token = await SessionManager().get("token");
    if (token != null) {
      if (JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForUtente)) {
        Navigator.pushNamed(context, AppRoutes.homeUtente);
      } else if (JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForADS)) {
        Navigator.pushNamed(context, AppRoutes.homeADS);
      } else if (JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForCA)) {
        Navigator.pushNamed(context, AppRoutes.homeCA);
      }
    }
  }

  /// Classe che builda il widget contenente l'interfaccia della Start Page
  @override
  Widget build(BuildContext context) {
    checkUser(context);
    return Scaffold(
      body: Column(
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
            padding: const EdgeInsets.only(bottom: 50),
            child: const Text(
              'RICOMINCIAMO INSIEME',
              style: TextStyle(
                fontFamily: 'CCE',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            'Hai già un account?',
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
              key: const Key('loginButton'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.login,
                );
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
          const Text(
            'Oppure',
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
              key: const Key('signUpButton'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.signup,
                );
              },
              child: const Text(
                'REGISTRATI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 23,
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
    );
  }
}
