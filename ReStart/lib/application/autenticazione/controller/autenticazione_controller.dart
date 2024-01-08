import 'dart:convert';
import 'package:restart_all_in_one/application/autenticazione/service/autenticazione_service.dart';
import 'package:restart_all_in_one/application/autenticazione/service/autonticazione_service_impl.dart';
import 'package:restart_all_in_one/model/entity/ads_DTO.dart';
import 'package:restart_all_in_one/model/entity/ca_DTO.dart';
import 'package:restart_all_in_one/model/entity/utente_DTO.dart';
import 'package:restart_all_in_one/utils/jwt_constants.dart';
import 'package:restart_all_in_one/utils/jwt_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

class AutenticazioneController {
  late final AutenticazioneService _authService;
  late final shelf_router.Router _router;

  AutenticazioneController() {
    _authService = AutenticazioneServiceImpl();
    _router = shelf_router.Router();
    _router.post('/login', _login);
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;


  Future<Response> _login(Request request) async {
    try {

      String requestBody = await request.readAsString();

      Map<String, dynamic> requestData = jsonDecode(requestBody);

      final String username = requestData['email'];
      final String password = requestData['password'];

      // Esegui l'autenticazione
      final dynamic user = await _authService.login(username, password);

      if (user != null) {
        String jwtToken = '';
        if (user is UtenteDTO) {
          jwtToken = JWTUtils.generateAccessToken(username: username, secretKey: JWTConstants.accessTokenSecretKeyForUtente);
        } else if (user is CaDTO) {
          jwtToken = JWTUtils.generateAccessToken(username: username, secretKey: JWTConstants.accessTokenSecretKeyForCA);
        } else if (user is AdsDTO) {
          jwtToken = JWTUtils.generateAccessToken(username: username, secretKey: JWTConstants.accessTokenSecretKeyForADS);
        }
        final responseBody = jsonEncode({'token': jwtToken});
        return Response.ok(responseBody, headers: {'Content-Type': 'application/json'});
      } else {
        return Response.forbidden('Credenziali non valide');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Errore durante il login: $e');
    }
  }

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
