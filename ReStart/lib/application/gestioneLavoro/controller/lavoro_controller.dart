import 'dart:convert';
import 'dart:io';

import 'package:restart_all_in_one/application/gestioneLavoro/service/lavoro_service_impl.dart';
import 'package:restart_all_in_one/model/entity/annuncio_di_lavoro_DTO.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

class GestioneLavoroController {
 late final LavoroServiceImpl _service;
 late final shelf_router.Router _router;
 
 GestioneLavoroController(){
  _service = LavoroServiceImpl();
  _router = shelf_router.Router();

  _router.post('/visualizzaLavori', _visualizzaLavori);
  _router.post('/aggiungiLavoro', _aggiungiLavoro);
  _router.get('/dettagliLavoro', _dettagliLavoro);
  _router.all('/<ignored|.*>', _notFound);
 }
 
 shelf_router.Router get router => _router;

  Future<Response> _visualizzaLavori(Request request) async {
      try{
      final List<AnnuncioDiLavoroDTO> listaLavori = await _service.offerteLavoro();
      final responseBody = jsonEncode({'annunci':listaLavori});
      return Response.ok(responseBody ,
      headers: {'Content-Type' : 'apllication/json'});
  }catch(e){
  return Response.internalServerError(
    body: 'Errore durante la visualizzazzione della richiesta');
    }
  }
 Future<Response> _aggiungiLavoro(Request request) async {
      try{
       final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      // Ottieni i valori dei parametri
      final String nomeLavoro= params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final bool approvato = params['approvato'] == 'true';
      final String via= params['via'] ?? '';
      final String citta = params['città'] ?? '';
      final String provincia = params['provincia'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String email = params['email'] ?? '';
      final String numTelefono = params['num_telefono'] ?? '';

      //capire il noid come si utilizza 
      AnnuncioDiLavoroDTO lavoro = AnnuncioDiLavoroDTO(
          
          nomeLavoro: nomeLavoro,
          descrizione: descrizione,
          approvato: approvato,
          via: via,
          citta : citta,
          provincia: provincia,
          immagine: immagine,
          email: email,
          numTelefono: numTelefono);

      if (await _service.addLavoro(lavoro)) {
        final responseBody = jsonEncode({'result': "Inserimento effettuato."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      }
      else {
        final responseBody = jsonEncode(
            {'result': 'Inserimento non effettuato'});
        return Response.badRequest(
            body: responseBody,
            headers: {'Content-Type': 'application/json'}
        );
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei supporti medici: $e');
    }
  }
Future<Response> _dettagliLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = parseFormBody(requestBody);
      final int? idLavoro = int.tryParse(params['id_lavoro'] ?? '');

      if (idLavoro != null) {
        AnnuncioDiLavoroDTO? lavoroDTO = await _service.detailsLavoro(idLavoro);
        if (lavoroDTO != null) {
          final responseBody = jsonEncode({'result': 'Dettagli del lavoro', 'lavoro': lavoroDTO.toJson()});
          return Response.ok(responseBody, headers: {'Content-Type': 'application/json'});
        } else {
           final responseBody = jsonEncode({'result': 'ID lavoro non valido'});
      return Response(
        HttpStatus.badRequest,
        body: responseBody,
        headers: {'Content-Type': 'application/json'},
      );
        }
      } else {
        final responseBody = jsonEncode({'result': 'ID lavoro non valido'});
        return Response.badRequest(
          body: responseBody,
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      return Response.internalServerError(
        body: 'Errore durante il recupero dei dettagli del lavoro: $e',
      );
    }
  }
   // Gestisci le richieste non corrispondenti
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }
  Map<String, dynamic> parseFormBody(String body) {
  final Map<String, dynamic> formData = {};
  final List<String> pairs = body.split("&");
  for (final String pair in pairs) {
    final List<String> keyValue = pair.split("=");
    if (keyValue.length == 2) {
      final String key = Uri.decodeQueryComponent(keyValue[0]);
      final String value = Uri.decodeQueryComponent(keyValue[1]);
      formData[key] = value;
    }
  }
  return formData;
  }

}


