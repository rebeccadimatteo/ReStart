import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../gestioneReintegrazione/controller/reintegrazione_controller.dart';

void main() {
  final app = shelf_router.Router();
  // Aggiungi i controller al router
  // app.mount('/autenticazione', AutenticazioneController().router);
  // app.mount('/candidaturaLavoro', CandidaturaLavoroController().router);
  // app.mount('/gestioneEvento', GestioneEventoController().router);
  // app.mount('/gestioneLavoro', GestioneLavoroController().router);
  app.mount('/gestioneReintegrazione', ReintegrazioneController().router);
  //app.mount('/lavoroAdatto', LavoroAdattoController().router);
  //app.mount('/registrazione', RegistrazioneController().router);

  // Aggiungi la route di fallback per le richieste non corrispondenti
  app.all('/<ignored|.*>', (Request request) {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  });

  app.post('/addCorso', (Request request) async {
    var bodyBytes = await request.read().toList();

    // Percorso in cui desideri salvare l'immagine sul server
    var directoryPath = 'images'; // Sostituisci con il percorso reale

    // Assicurati che la cartella di destinazione esista, altrimenti creala
    var directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Crea un nome univoco per il file
    var fileName = 'immagine_${DateTime.now().millisecondsSinceEpoch}.jpg';
    var filePath = '$directoryPath/$fileName'; // Percorso completo del file

    // Scrivi i byte dell'immagine su disco
    var file = File(filePath);
    await file.writeAsBytes(bodyBytes.expand((element) => element).toList());

    // Ora l'immagine è stata salvata su disco
    return Response.ok('Immagine salvata su disco con successo: $filePath',
        headers: {'Content-Type': 'text/plain'});
  });




  // Aggiungi middleware per registrare le richieste
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app);

  shelf_io.serve(handler, '127.0.0.1', 8080).then((server) {
    print('Server listening on http://${server.address.host}:${server.port}');
  });
}