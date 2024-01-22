import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Classe astratta [JWTUtils] fornisce metodi statici per la gestione dei token JWT.
abstract class JWTUtils {
  /// Genera un token JWT di accesso.
  ///
  /// Prende in input [userId], [username], [secretKey], e [userType] e restituisce un token JWT.
  /// Il token scade dopo 1 giorno.
  static String generateAccessToken({
    required String userId,
    required String username,
    required String secretKey,
    required String userType,
  }) {
    final jwt = JWT({
      'userId': userId,
      'username': username,
      'userType': userType,
    });

    return jwt.sign(
      SecretKey(secretKey),
      expiresIn: const Duration(days: 1),
    );
  }

  /// Verifica la validità di un token JWT di accesso.
  ///
  /// Prende in input [accessToken] e [secretKey] e restituisce un valore booleano.
  /// Restituisce `true` se il token è valido, altrimenti `false`.
  static bool verifyAccessToken(
      {required String accessToken, required String secretKey}) {
    try {
      JWT.verify(accessToken, SecretKey(secretKey));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Estrae l'ID dell'utente dal token JWT.
  ///
  /// Prende in input [accessToken] e restituisce l'ID dell'utente.
  static int getIdFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // ignore: avoid_dynamic_calls
    return int.parse(jwt.payload['userId'] as String);
  }

  /// Estrae il nome utente dal token JWT.
  ///
  /// Prende in input [accessToken] e restituisce il nome utente.
  static String getUserFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // ignore: avoid_dynamic_calls
    return jwt.payload['username'] as String;
  }

  /// Estrae il tipo di utente dal token JWT.
  ///
  /// Prende in input [accessToken] e restituisce il tipo di utente.
  /// Se il campo 'userType' non è presente, restituisce un valore predefinito o gestisce l'errore.
  static String getUserTypeFromToken({required String accessToken}) {
    final jwt = JWT.decode(accessToken);
    // Controlla se il campo 'userType' esiste nel payload del token
    if (jwt.payload.containsKey('userType')) {
      return jwt.payload['userType'] as String;
    } else {
      // Se il campo 'userType' non è presente, restituisci un valore predefinito o gestisci l'errore in base alle tue esigenze.
      return 'utente'; // Valore predefinito o gestione dell'errore
    }
  }
}
