
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../autenticazione/controller/autenticazione_controller.dart';
import '../gestioneCandidaturaLavoro/controller/candidatura_controller.dart';
import '../gestioneLavoro/controller/lavoro_controller.dart';
import '../gestioneRegistrazione/controller/registrazione_controller.dart';
import '../gestioneReintegrazione/controller/reintegrazione_controller.dart';
import '../gestioneEvento/controller/evento_controller.dart';
import '../lavoroAdatto/controller/lavoro_adatto_controller.dart';

/// Punto di ingresso principale per il server web basato su Shelf.
///
/// Configura e avvia un server HTTP che gestisce diverse route associate a
/// vari controller. Ogni controller gestisce una specifica area di funzionalità.
void main() {
  // Inizializza il router principale.
  final app = shelf_router.Router();

  // Associa i percorsi alle istanze dei controller.
  // Ogni controller gestisce un insieme specifico di percorsi e logica associata.
  app.mount('/autenticazione', AutenticazioneController().router.call);
  app.mount('/candidaturaLavoro', CandidaturaController().router.call);
  app.mount('/gestioneEvento', GestioneEventoController().router.call);
  app.mount('/gestioneLavoro', GestioneLavoroController().router.call);
  app.mount('/gestioneReintegrazione', ReintegrazioneController().router.call);
  app.mount('/lavoroAdatto', LavoroAdattoController().router.call);
  app.mount('/registrazione', RegistrazioneController().router.call);

  // Route di fallback per catturare le richieste a percorsi non definiti.
  // Restituisce una risposta 404 per qualsiasi richiesta non corrispondente alle route definite.
  app.all('/<ignored|.*>', (Request request) {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  });

  // Configura il middleware per registrare le richieste.
  // Utilizza il `Pipeline` di Shelf per concatenare il middleware e il gestore delle richieste.
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app.call);

  // Avvia il server sulla porta 8080 in ascolto sull'indirizzo locale.
  // Stampa l'indirizzo e la porta su cui il server è in ascolto una volta avviato.
  shelf_io.serve(handler, '127.0.0.1', 8080).then((server) {
    print('Server listening on http://${server.address.host}:${server.port}');
  });
}