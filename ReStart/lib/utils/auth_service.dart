import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'jwt_constants.dart';
import 'jwt_utils.dart';

/// Classe [AuthService] fornisce metodi per verificare l'autenticazione degli utenti.
class AuthService {

  /// Verifica se l'utente corrente è un 'Utente'.
  ///
  /// Ottiene il token dall'archiviazione della sessione e verifica il token.
  /// Restituisce `true` se il token è valido, altrimenti `false`.
  static Future<bool> checkUserUtente() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForUtente);
    }
    return false;
  }

  /// Verifica se l'utente corrente è un 'CA' (Centro di Assistenza).
  ///
  /// Ottiene il token dall'archiviazione della sessione e verifica il token.
  /// Restituisce `true` se il token è valido, altrimenti `false`.
  static Future<bool> checkUserCA() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForCA);
    }
    return false;
  }

  /// Verifica se l'utente corrente è un 'ADS' (Amministratore del Sistema).
  ///
  /// Ottiene il token dall'archiviazione della sessione e verifica il token.
  /// Restituisce `true` se il token è valido, altrimenti `false`.
  static Future<bool> checkUserADS() async {
    var token = await SessionManager().get("token");
    if (token != null) {
      return JWTUtils.verifyAccessToken(
          accessToken: await token,
          secretKey: JWTConstants.accessTokenSecretKeyForADS);
    }
    return false;
  }
}