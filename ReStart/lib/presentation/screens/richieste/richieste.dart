import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/jwt_constants.dart';
import '../../../utils/jwt_utils.dart';
import '../../components/generic_app_bar.dart';
import '../routes/routes.dart';

class Richieste extends StatefulWidget {
  @override
  State<Richieste> createState() => _RichiesteState();
}

class _RichiesteState extends State<Richieste> {
  List<EventoDTO> eventi = [];
  List<AnnuncioDiLavoroDTO> annunci = [];

  @override
  void initState() {
    super.initState();
    fetchEventiFromServer();
    fetchAnnunciFromServer();
  }

  Future<void> fetchEventiFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/visualizzaEventi'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('eventi')) {
        final List<EventoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['eventi'])
                .map((json) => EventoDTO.fromJson(json))
                .toList();
        setState(() {
          eventi = data.where((e) => !e.approvato).toList();
        });
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> fetchAnnunciFromServer() async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneLavoro/visualizzaLavori'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('annunci')) {
        final List<AnnuncioDiLavoroDTO> data =
            List<Map<String, dynamic>>.from(responseBody['annunci'])
                .map((json) => AnnuncioDiLavoroDTO.fromJson(json))
                .toList();
        setState(() {
          annunci = data.where((a) => !a.approvato).toList();
        });
      } else {
        print('Chiave "annunci" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> approvaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/approveEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
        setState(() {
          eventi.remove(e);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaEvento(EventoDTO e) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/rejectEvento'),
      body: jsonEncode(e),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
        setState(() {
          eventi.remove(e);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> approvaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/approveLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
        setState(() {
          annunci.remove(a);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> rifiutaAnnuncio(AnnuncioDiLavoroDTO a) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneLavoro/rejectLavoro'),
      body: jsonEncode(a),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
        setState(() {
          annunci.remove(a);
        });
      }
    } else {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('result')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseBody['result'].toString(),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.blue[200],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Chiudi',
              textColor: Colors.deepPurple,
              onPressed: () {
                // Codice per chiudere la snackbar, se necessario
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (eventi.isEmpty && annunci.isEmpty) {
      // Nessuna richiesta
      return Scaffold(
        appBar: GenericAppBar(
          showBackButton: true,
        ),
        endDrawer: GenericAppBar.buildDrawer(context),
        body: const Center(
          child: Text(
            'Nessuna richiesta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: GenericAppBar(
        showBackButton: true,
      ),
      endDrawer: GenericAppBar.buildDrawer(context),
      body: ListView.builder(
        itemCount: eventi.length + annunci.length + 2,
        // Aggiungi 2 per le scritte 'Eventi' e 'Annunci di lavoro'
        itemBuilder: (context, index) {
          if (index == 0) {
            // Prima della lista degli eventi
            return buildSectionHeader('Eventi');
          } else if (index <= eventi.length) {
            // Elementi degli eventi
            final evento = eventi[index - 1];
            return buildEventItem(context, evento);
          } else if (index == eventi.length + 1) {
            // Prima della lista degli annunci di lavoro
            return buildSectionHeader('Annunci di lavoro');
          } else {
            // Elementi degli annunci di lavoro
            final annuncio = annunci[index - eventi.length - 2];
            return buildAnnouncementItem(context, annuncio);
          }
        },
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildEventItem(BuildContext context, EventoDTO evento) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.dettaglievento,
          arguments: evento,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 80,
          tileColor: Colors.grey,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(evento.immagine),
          ),
          title: Text(
            evento.nomeEvento,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(evento.descrizione),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  approvaEvento(evento);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaEvento(evento);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnnouncementItem(
      BuildContext context, AnnuncioDiLavoroDTO annuncio) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.dettagliannuncio,
          arguments: annuncio,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5, right: 5),
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 4, horizontal: 4),
          minVerticalPadding: 50,
          minLeadingWidth: 80,
          tileColor: Colors.grey,
          leading: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(annuncio.immagine),
          ),
          title: Text(
            annuncio.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(annuncio.descrizione),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  approvaAnnuncio(annuncio);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  rifiutaAnnuncio(annuncio);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Richieste()));
}
