import 'package:restart_all_in_one/application/gestioneLavoro/controller/lavoro_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../autenticazione/controller/autenticazione_controller.dart';
import '../gestioneCandidaturaLavoro/controller/candidatura_controller.dart';
import '../gestioneRegistrazione/controller/registrazione_controller.dart';
import '../gestioneReintegrazione/controller/reintegrazione_controller.dart';
import '../gestioneEvento/controller/evento_controller.dart';
import '../lavoroAdatto/controller/lavoro_adatto_controller.dart';

void main() {
  final app = shelf_router.Router();
  // Aggiungi i controller al router
  app.mount('/autenticazione', AutenticazioneController().router);
  app.mount('/candidaturaLavoro', CandidaturaController().router);
  app.mount('/gestioneEvento', GestioneEventoController().router);
  app.mount('/gestioneLavoro', GestioneLavoroController().router);
  app.mount('/gestioneReintegrazione', ReintegrazioneController().router);
  app.mount('/lavoroAdatto', LavoroAdattoController().router);
  app.mount('/registrazione', RegistrazioneController().router);

  // Aggiungi la route di fallback per le richieste non corrispondenti
  app.all('/<ignored|.*>', (Request request) {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  });

  // Aggiungi middleware per registrare le richieste
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app.call);

  shelf_io.serve(handler, '127.0.0.1', 8080).then((server) {
    print('Server listening on http://${server.address.host}:${server.port}');
  });
}