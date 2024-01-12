import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restart_all_in_one/utils/jwt_utils.dart';
import '../../../model/entity/evento_DTO.dart';
import '../../../utils/auth_service.dart';
import '../../components/app_bar_ca.dart';
import 'package:http/http.dart' as http;
import '../routes/routes.dart';

/// Classe che implementa la sezione [CommunityEvents]
class CommunityEventsPubblicati extends StatefulWidget {
  @override
  _CommunityEventsState createState() => _CommunityEventsState();
}

/// Creazione dello stato di [CommunityEvents], costituito dalla lista degli eventi
class _CommunityEventsState extends State<CommunityEventsPubblicati> {
  List<EventoDTO> eventi = [];
  var token = SessionManager().get("token");

  /// Inizializzazione dello stato, con chiamata alla funzione [fetchDataFromServer]
  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  /// Metodo che permette di inviare la richiesta al server per ottenere la lista di tutti i [EventoDTO] presenti nel database
  Future<void> fetchDataFromServer() async {
    String user = JWTUtils.getUserFromToken(accessToken: await token);
    Map<String, dynamic> username = {"username": user};
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/eventiPubblicati'),
        body: json.encode(username));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('eventi')) {
        final List<EventoDTO> data =
            List<Map<String, dynamic>>.from(responseBody['eventi'])
                .map((json) => EventoDTO.fromJson(json))
                .toList();
        setState(() {
          List<EventoDTO> newData = [];
          for (EventoDTO e in data) {
            //if (e.approvato && e.id_ca == idCa) {
              newData.add(e);
            //}
          }
          eventi = newData;
        });
      } else {
        print('Chiave "eventi" non trovata nella risposta.');
      }
    } else {
      print('Errore');
    }
  }

  Future<void> deleteEvento(EventoDTO evento) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/deleteEvento'),
        body: jsonEncode(evento));
    if (response.statusCode == 200) {
      setState(() {
        eventi.remove(evento);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  /// Build del widget principale della sezione [CommunityEvents], contenente tutta l'interfaccia grafica
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: const Text(
                'GESTISCI I TUOI EVENTI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
              itemCount: eventi.length,
              itemBuilder: (context, index) {
                final evento = eventi[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.dettaglieventipub,
                      arguments: evento,
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                    child: ListTile(
                      visualDensity:
                          const VisualDensity(vertical: 4, horizontal: 4),
                      minVerticalPadding: 50,
                      minLeadingWidth: 80,
                      tileColor: Colors.grey,
                      leading: const CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais'),
                      ),
                      title: Text(evento.nomeEvento,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(evento.descrizione),
                      trailing: Container(
                        width: 100, // o un'altra dimensione adeguata
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black, size: 30),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.modificaevento,
                                    arguments: evento);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 30),
                              onPressed: () {
                                deleteEvento(evento);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class DetailsEventoPub extends StatefulWidget{
  @override
  _DetailsEventoPub createState() => _DetailsEventoPub();

}
/// Build del widget che viene visualizzato quando viene selezionato un determinato evento dalla sezione [CommunityEvents]
/// Permette di visualizzare i dettagli dell'evento selezionato
class _DetailsEventoPub extends State<DetailsEventoPub> {
  List<EventoDTO> eventi = [];
  var token = SessionManager().get("token");

  /// Inizializzazione dello stato, con chiamata alla funzione [fetchDataFromServer]
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteEvento(EventoDTO evento) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gestioneEvento/deleteEvento'),
        body: jsonEncode(evento));
    if (response.statusCode == 200) {
      setState(() {
        eventi.remove(evento);
      });
    } else {
      print("Eliminazione non andata a buon fine");
    }
  }

  @override
  Widget build(BuildContext context) {
    final EventoDTO evento =
        ModalRoute.of(context)?.settings.arguments as EventoDTO;
    final String data = evento.date.toIso8601String();
    final String dataBuona = data.substring(0, 10);
    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?size=338&ext=jpg&ga=GA1.1.1546980028.1703635200&semt=ais'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            evento.nomeEvento,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(evento.descrizione),
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Contatti',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(evento.email),
                        Text(evento.sito),
                        const SizedBox(height: 20),
                        const Text(
                          'Informazioni',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(dataBuona),
                        // Aggiunta dei pulsanti sotto la sezione "Contatti"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black, size: 40),
                              onPressed: () {
                                // Navigator.pushNamed(context, AppRoutes.modificaevento, arguments: evento);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModifyEvento(evento: evento), // Assicurati che ModifyEvento accetti un parametro 'evento'
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            // Aggiungi uno spazio tra i pulsanti
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 40),
                              onPressed: () {
                                deleteEvento(evento);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}

///Classe che rappresenta la schermata per inserire un [Evento]
class ModifyEvento extends StatefulWidget {
  final EventoDTO evento;

  ModifyEvento({required this.evento});

  @override
  _ModifyEventoState createState() => _ModifyEventoState(evento: evento);
}

/// Classe associata a [ModifyEvento] e gestisce la logica e l'interazione
/// dell'interfaccia utente per inserire un nuovo evento temporaneo.
class _ModifyEventoState extends State<ModifyEvento> {
  final EventoDTO evento;
  _ModifyEventoState({required this.evento});
  late int idCa;
  var token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set controller values here
    setControllerValues(evento);
  }

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
    token = SessionManager().get("token");
  }

  void _checkUserAndNavigate() async {
    bool isUserValid = await AuthService.checkUserCA();
    if (!isUserValid) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  TextEditingController nomeController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sitoController = TextEditingController();
  TextEditingController cittaController = TextEditingController();
  TextEditingController viaController = TextEditingController();
  TextEditingController provinciaController = TextEditingController();

  void setControllerValues(EventoDTO evento) {
    nomeController.text = evento.nomeEvento;
    descrizioneController.text = evento.descrizione;
    cittaController.text = evento.citta;
    viaController.text = evento.via;
    provinciaController.text = evento.provincia;
    emailController.text = evento.email;
    sitoController.text = evento.sito;
  }

  /// Metodo per selezionare un'immagine dalla galleria.
  void selectImage() async {
    final imagePicker = ImagePicker();
    _image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Metodo per inviare il form al server.
  void submitForm(EventoDTO event) async {
    if (_formKey.currentState!.validate()) {
      String nome = nomeController.text;
      String descrizione = descrizioneController.text;
      String citta = cittaController.text;
      String via = viaController.text;
      String provincia = provinciaController.text;
      String email = emailController.text;
      String sito = sitoController.text;
      String imagePath = 'images/image_${nome}.jpg';

      // Crea il DTO con il percorso dell'immagine
      EventoDTO evento = EventoDTO(
        id: event.id,
        nomeEvento: nome,
        descrizione: descrizione,
        approvato: true,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        sito: sito,
        immagine: imagePath,
        id_ca: JWTUtils.getIdFromToken(accessToken: await token),
        date: DateTime.now(),
      );
      // Invia i dati al server con il percorso dell'immagine
      sendDataToServer(evento);
    } else {
      print("Evento non inserito");
    }
  }

  /// Metodo per inviare i dati al server.
  Future<void> sendDataToServer(EventoDTO evento) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/gestioneEvento/modifyEvento'),
      body: jsonEncode(evento),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 && _image != null) {
      print(response);
      final imageUrl =
      Uri.parse('http://10.0.2.2:8080/gestioneReintegrazione/addImage');
      final imageRequest = http.MultipartRequest('POST', imageUrl);

      // Aggiungi l'immagine
      imageRequest.files
          .add(await http.MultipartFile.fromPath('immagine', _image!.path));

      // Aggiungi ID del corso e nome del'evento come campi di testo
      imageRequest.fields['nome'] = evento.nomeEvento;

      final imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        // L'immagine è stata caricata con successo
        print("Immagine caricata con successo.");
        Navigator.pushNamed(context, AppRoutes.eventipubblicati);
      } else {
        // Si è verificato un errore nell'upload dell'immagine
        print(
            "Errore durante l'upload dell'immagine: ${imageResponse.statusCode}");
      }
    }
  }

  /// Costruisce la UI per la schermata di inserimento di un evento temporaneo.
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.3;

    return Scaffold(
      appBar: CaAppBar(
        showBackButton: true,
      ),
      endDrawer: CaAppBar.buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.08),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text(
              'Inserisci evento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        child: CircleAvatar(
                          backgroundImage: _image != null
                              ? MemoryImage(
                              File(_image!.path).readAsBytesSync())
                              : Image.asset('images/avatar.png').image,
                        ),
                      ),
                      Positioned(
                        bottom: -1,
                        left: screenWidth * 0.18,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo_sharp),
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome evento'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {}
                      return null;
                    },
                    onChanged: (value) {
                      // Aggiorna lo stato del widget quando il testo cambia
                      setState(() {
                        nomeController.text = value;
                        // Nessuna azione specifica richiesta qui, poiché stai già utilizzando il controller
                      },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: descrizioneController,
                      decoration:
                      const InputDecoration(labelText: 'Descrizione'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la descrizione dell\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 40),
                  const Text(
                    'Contatti',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la mail dell\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: sitoController,
                      decoration: const InputDecoration(labelText: 'Sito web'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il sito web dell\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: cittaController,
                      decoration: const InputDecoration(labelText: 'Città'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la città dov\è situato l\'evento';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: viaController,
                      decoration: const InputDecoration(labelText: 'Via'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la via dov\è situato l\'evento';
                        }
                        return null;
                      }),
                  const SizedBox(height: 20),
                  TextFormField(
                      controller: provinciaController,
                      decoration: const InputDecoration(labelText: 'Provincia'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci la provincia dov\è situato l\'evento';
                        }
                        return null;
                      }),
                  SizedBox(height: screenWidth * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      submitForm(evento);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                      foregroundColor: Colors.black,
                      shadowColor: Colors.grey,
                      elevation: 10,
                      minimumSize: Size(screenWidth * 0.1, screenWidth * 0.1),
                    ),
                    child: const Text(
                      'INSERISCI',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: CommunityEventsPubblicati(),
  ));
}
