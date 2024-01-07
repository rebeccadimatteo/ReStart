import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../gestioneReintegrazione/controller/reintegrazione_controller.dart';

void main() {
  final handler = const Pipeline()
      .addMiddleware(logRequests()) // middleware per registrare le richieste
      .addHandler((Request request) async {
    // handler principale per gestire le richieste

    final pathSegments = request.url.pathSegments;
    print(pathSegments);

    if (pathSegments.isNotEmpty) {
      final controllerName = pathSegments.first;
      switch (controllerName) {
        /*      case 'autenticazione':
          return; // userController.handleRequest(request);
        case 'candidaturaLavoro':
          return; // productController.handleRequest(request);
        case 'gestioneEvento':
          return; // userController.handleRequest(request);
        case 'gestioneLavoro':
          return; // productController.handleRequest(request);
    */
        case 'gestioneReintegrazione':
          return ReintegrazioneController().handleRequest(request);
/*        case 'lavoroAdatto':
          return; // productController.handleRequest(request);
        case 'registrazione':
          return; // userController.handleRequest(request);
*/
        default:
          return Response.notFound('Controller non trovato');
      }
    } else {
      return Response.notFound('Nessun controller specificato');
    }
  });

  shelf_io.serve(handler, '127.0.0.1', 8080).then((server) {
    print('Server listening on http://${server.address.host}:${server.port}');
  });
}
