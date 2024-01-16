import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../../../model/entity/utente_DTO.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';

import 'package:http/http.dart' as http;

import '../routes/routes.dart';

void main() => runApp(MaterialApp(home: VisualizzaLavoroAdatto()));

class VisualizzaLavoroAdatto extends StatefulWidget {
  const VisualizzaLavoroAdatto({super.key});

  @override
  State<VisualizzaLavoroAdatto> createState() => _VisualizzaLavoroAdattoState();
}

class _VisualizzaLavoroAdattoState extends State<VisualizzaLavoroAdatto> {
  late UtenteDTO utente; // Definizione del futuro per l'utente
  var token = SessionManager().get('token');

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
    return Scaffold(
      appBar: GenericAppBar(showBackButton: true),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: Stack(
        children: [
          // Aggiungi la linea diagonale come sfondo
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalLinePainter(),
            ),
          ),
          // Il testo e il pulsante sono sopra la linea diagonale
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 40),
                  Text(
                    'IL LAVORO CHE FA',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PER TE È:',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    utente.lavoro_adatto ?? 'Nessun lavoro adatto trovato', // Fornisce un valore di fallback
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text(
                    'Vuoi ripetere il test?',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Aggiungi qui la logica per il clic del pulsante
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Text color
                      backgroundColor: Colors.grey, // Background color
                    ),
                    child: Text('Clicca qui!'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter per disegnare la linea diagonale
class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;
// Disegna una linea dal punto in basso a sinistra (0, size.height)
// al punto in alto a destra (size.width, 0)
    canvas.drawLine(Offset(-150, size.height), Offset(size.width, 200), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
